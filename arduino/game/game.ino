#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

MPU6050 mpu;

//#define OUTPUT_READABLE_QUATERNION
//#define OUTPUT_READABLE_EULER
#define OUTPUT_READABLE_YAWPITCHROLL
//#define OUTPUT_READABLE_REALACCEL
//#define OUTPUT_READABLE_WORLDACCEL
//#define OUTPUT_TEAPOT

#define OUTPUT_FLOAT_PRECISION 24
#define INTERRUPT_PIN 2  // use pin 2 on Arduino Uno & most boards
#define LED_PIN 13 // (Arduino is 13, Teensy is 11, Teensy++ is 6)
#define BAUDRATE 115200  // baudrate value

bool blinkState = false;
// MPU control/status vars
bool dmpReady = false;  // set true if DMP init was successful
uint8_t mpuIntStatus;   // holds actual interrupt status byte from MPU
uint8_t devStatus;      // return status after each device operation (0 = success, !0 = error)
uint16_t packetSize;    // expected DMP packet size (default is 42 bytes)
uint16_t fifoCount;     // count of all bytes currently in FIFO
uint8_t fifoBuffer[64]; // FIFO storage buffer

// orientation/motion vars
Quaternion q;           // [w, x, y, z]         quaternion container
VectorInt16 aa;         // [x, y, z]            accel sensor measurements
VectorInt16 aaReal;     // [x, y, z]            gravity-free accel sensor measurements
VectorInt16 aaWorld;    // [x, y, z]            world-frame accel sensor measurements
VectorFloat gravity;    // [x, y, z]            gravity vector
float euler[3];         // [psi, theta, phi]    Euler angle container
float ypr[3];           // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector
float pi_m = 180/M_PI;

// packet structure for InvenSense teapot demo
uint8_t teapotPacket[14] = { '$', 0x02, 0,0, 0,0, 0,0, 0,0, 0x00, 0x00, '\r', '\n' };

// ================================================================
// ===               INTERRUPT DETECTION ROUTINE                ===
// ================================================================

volatile bool mpuInterrupt = false;     // indicates whether MPU interrupt pin has gone high
void dmpDataReady() {
    mpuInterrupt = true;
}

// ================================================================
// ===                      INITIAL SETUP                       ===
// ================================================================

void setup() {
    // join I2C bus (I2Cdev library doesn't do this automatically)
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
        //Wire.setClock(400000); // 400kHz I2C clock. Comment this line if having compilation difficulties
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    Serial.begin(BAUDRATE);
    while (!Serial); // wait for Leonardo enumeration, others continue immediately

    // initialize device
    Serial.println(F("Initializing I2C devices..."));
    mpu.initialize();
    pinMode(INTERRUPT_PIN, INPUT);

    // verify connection
    Serial.println(F("Testing device connections..."));
    Serial.println(mpu.testConnection() ? F("MPU6050 connection successful") : F("MPU6050 connection failed"));

    // wait for ready
    Serial.println(F("\nSend any character to begin DMP programming and demo: "));
    while (Serial.available() && Serial.read()); // empty buffer
    //while (!Serial.available());                 // wait for data
    while (Serial.available() && Serial.read()); // empty buffer again

    // load and configure the DMP
    Serial.println(F("Initializing DMP..."));
    devStatus = mpu.dmpInitialize();

    // supply your own gyro offsets here, scaled for min sensitivity
    // mpu.setXGyroOffset(220);
    // mpu.setYGyroOffset(76);
    // mpu.setZGyroOffset(-85);
    // mpu.setZAccelOffset(1788); // 1688 factory default for my test chip

    // make sure it worked (returns 0 if so)
    if (devStatus == 0) {
        // turn on the DMP, now that it's ready
        Serial.println(F("Enabling DMP..."));
        mpu.setDMPEnabled(true);

        // enable Arduino interrupt detection
        Serial.println(F("Enabling interrupt detection (Arduino external interrupt 0)..."));
        //attachInterrupt(digitalPinToInterrupt(INTERRUPT_PIN), dmpDataReady, RISING);
        mpuIntStatus = mpu.getIntStatus();

        // set our DMP Ready flag so the main loop() function knows it's okay to use it
        Serial.println(F("DMP ready! Waiting for first interrupt..."));
        dmpReady = true;

        // get expected DMP packet size for later comparison
        packetSize = mpu.dmpGetFIFOPacketSize();
    } else {
        // ERROR!
        // 1 = initial memory load failed
        // 2 = DMP configuration updates failed
        // (if it's going to break, usually the code will be 1)
        Serial.print(F("DMP Initialization failed (code "));
        Serial.print(devStatus);
        Serial.println(F(")"));
    }

    // configure LED for output
    pinMode(LED_PIN, OUTPUT);
}

// ================================================================
// ===                    MAIN PROGRAM LOOP                     ===
// ================================================================

void loop() {

    // if programming failed, don't try to do anything
    if (!dmpReady) return;

    // wait for MPU interrupt or extra packet(s) available
    while (!mpuInterrupt && fifoCount < packetSize) {
      break;
        // other program behavior stuff here
        // .
        // .
        // .
        // if you are really paranoid you can frequently test in between other
        // stuff to see if mpuInterrupt is true, and if so, "break;" from the
        // while() loop to immediately process the MPU data
        // .
        // .
        // .
    }

    // reset interrupt flag and get INT_STATUS byte
    mpuInterrupt = false;
    mpuIntStatus = mpu.getIntStatus();

    // get current FIFO count
    fifoCount = mpu.getFIFOCount();

    // check for overflow (this should never happen unless our code is too inefficient)
    if ((mpuIntStatus & 0x10) || fifoCount == 1024) {
        // reset so we can continue cleanly
        mpu.resetFIFO();
        Serial.println(F("FIFO overflow!"));

    // otherwise, check for DMP data ready interrupt (this should happen frequently)
    } else if (mpuIntStatus & 0x02) {
        // wait for correct available data length, should be a VERY short wait
        while (fifoCount < packetSize) fifoCount = mpu.getFIFOCount();

        // read a packet from FIFO
        mpu.getFIFOBytes(fifoBuffer, packetSize);
        // https://arduino.stackexchange.com/questions/10308/how-to-clear-fifo-buffer-on-mpu6050
        // *** no projeto final, nao mexi no arquivo MPU6050_6Axis_MotionApps20.h ***, escrevi comentario abaixo so para constar a opcao
        // To prevent overflow problems, please, go to MPU6050_6Axis_MotionApps20.h and modify that line:
        // 0x02,   0x16,   0x02,   0x00, **0x01**                // D_0_22 inv_set_fifo_rate
        // The value in bold is the objective! Change it to 0x03 or 0x04 or 0x05 to reduce the Hz of rate. I am using 0x03 and not getting error values, junk data, or overflows anymore.
        mpu.resetFIFO();
        
        // track FIFO count here in case there is > 1 packet available
        // (this lets us immediately read more without waiting for an interrupt)
        fifoCount -= packetSize;

        #ifdef OUTPUT_READABLE_QUATERNION
            // display quaternion values in easy matrix form: w x y z
            mpu.dmpGetQuaternion(&q, fifoBuffer);
            Serial.print("quat\t");
            Serial.print(q.w, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.print(q.x, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.print(q.y, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.println(q.z, OUTPUT_FLOAT_PRECISION);
        #endif

        #ifdef OUTPUT_READABLE_EULER
            // display Euler angles in degrees
            mpu.dmpGetQuaternion(&q, fifoBuffer);
            mpu.dmpGetEuler(euler, &q);
            Serial.print("euler\t");
            Serial.print(euler[0] * pi_m, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.print(euler[1] * pi_m, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.println(euler[2] * pi_m, OUTPUT_FLOAT_PRECISION);
        #endif

        #ifdef OUTPUT_READABLE_YAWPITCHROLL
            int a = 0;
            Serial.println("fifoBuffer:");
            for(a=0;a<=64;a++) {
                Serial.println(fifoBuffer[a]);
            }
            Serial.println("end fifoBuffer:");
            // display Euler angles in degrees
            mpu.dmpGetQuaternion(&q, fifoBuffer);
            Serial.print("quat\t");
            Serial.print(q.w, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.print(q.x, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.print(q.y, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.println(q.z, OUTPUT_FLOAT_PRECISION);
            
            mpu.dmpGetGravity(&gravity, &q);
            Serial.print("gravity\t");
            Serial.print(gravity.x, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.print(gravity.y, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.println(gravity.z, OUTPUT_FLOAT_PRECISION);

            mpu.dmpGetYawPitchRoll(ypr, &q, &gravity);
            Serial.print("ypr original\t");
            Serial.print(ypr[0], OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.print(ypr[1], OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.println(ypr[2], OUTPUT_FLOAT_PRECISION);

            Serial.print("ypr\t");
            Serial.print(ypr[0] * pi_m, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.print(ypr[1] * pi_m, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.println(ypr[2] * pi_m, OUTPUT_FLOAT_PRECISION);
        #endif

        #ifdef OUTPUT_READABLE_REALACCEL
            // display real acceleration, adjusted to remove gravity
            mpu.dmpGetQuaternion(&q, fifoBuffer);
            mpu.dmpGetAccel(&aa, fifoBuffer);
            mpu.dmpGetGravity(&gravity, &q);
            mpu.dmpGetLinearAccel(&aaReal, &aa, &gravity);
            Serial.print("areal\t");
            Serial.print(aaReal.x, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.print(aaReal.y, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.println(aaReal.z, OUTPUT_FLOAT_PRECISION);
        #endif

        #ifdef OUTPUT_READABLE_WORLDACCEL
            // display initial world-frame acceleration, adjusted to remove gravity
            // and rotated based on known orientation from quaternion
            mpu.dmpGetQuaternion(&q, fifoBuffer);
            mpu.dmpGetAccel(&aa, fifoBuffer);
            mpu.dmpGetGravity(&gravity, &q);
            mpu.dmpGetLinearAccel(&aaReal, &aa, &gravity);
            mpu.dmpGetLinearAccelInWorld(&aaWorld, &aaReal, &q);
            Serial.print("aworld\t");
            Serial.print(aaWorld.x, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.print(aaWorld.y, OUTPUT_FLOAT_PRECISION);
            Serial.print("\t");
            Serial.println(aaWorld.z, OUTPUT_FLOAT_PRECISION);
        #endif
    
        #ifdef OUTPUT_TEAPOT
            // display quaternion values in InvenSense Teapot demo format:
            teapotPacket[2] = fifoBuffer[0];
            teapotPacket[3] = fifoBuffer[1];
            teapotPacket[4] = fifoBuffer[4];
            teapotPacket[5] = fifoBuffer[5];
            teapotPacket[6] = fifoBuffer[8];
            teapotPacket[7] = fifoBuffer[9];
            teapotPacket[8] = fifoBuffer[12];
            teapotPacket[9] = fifoBuffer[13];
            Serial.write(teapotPacket, 14);
            teapotPacket[11]++; // packetCount, loops at 0xFF on purpose
        #endif
        
        // blink LED to indicate activity
        blinkState = !blinkState;
        digitalWrite(LED_PIN, blinkState);
    }
}





