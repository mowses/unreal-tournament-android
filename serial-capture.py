#!/usr/bin/env python
# list ports: python -m serial.tools.list_ports
import signal
import serial
import time
import socket
import sys
import argparse
import pyautogui

pyautogui.PAUSE = 0
OUTPUT_FLOAT_PRECISION = 24

# ====================================================================
def startCapture(arduino, udp):
    log_serial = open('./logs/log_serial.txt', 'w')
    log_udp = open('./logs/log_udp.txt', 'w')
    log_error = open('./logs/log_error.txt', 'w')

    i = 0
    line = ''
    while True:
        try:
            # i think its better to use read() instead of readLine()
            char = arduino.read().decode('ascii')
            if (char != '\n'):
                line += char
                continue

            line = line.strip()
            if (line == ''):
                continue

            i += 1
            ts = str(i).rjust(OUTPUT_FLOAT_PRECISION, '0')
            cols = line.split('\t')
            
            # log to serial file
            if (args1.debug):
                log_serial.write("{0}:{1}\n".format(ts, line))

            if cols[0] == 'ypr#0' and len(cols) == 4:
                y = str((float(cols[1])+180)).ljust(OUTPUT_FLOAT_PRECISION, '0')
                p = str(float(cols[2])).ljust(OUTPUT_FLOAT_PRECISION, '0')
                
                sent_udp = "{0}:{1},{2}".format(ts, y, p)
                udp.send(sent_udp.encode('ascii'))

                # log to udp file
                if (args1.debug):
                    log_udp.write("{0}{1}".format(sent_udp, "\n"))
                
                print (sent_udp)

            # check for mouse clicks
            elif cols[0] == 'BUTTON#3':
                if (cols[1] == '1'):
                    pyautogui.mouseDown(button='left')
                else:
                    pyautogui.mouseUp(button='left')

                print('{0} {1}'.format(cols[0], cols[1]))
            
            line = ''


            

        except Exception as e:
            err = str(e)
            log_error.write("{0}:{1}\n".format(ts, err))
            print(err)


    log_serial.close()
    log_udp.close()
    log_error.close()




def parseArgs():
    parser = argparse.ArgumentParser(description='Listen for data to send to UT99 via UDP')
    parser.add_argument(
        '-i', '--ip',
        #action='append',
        #nargs='+',
        #const='',
        default='192.168.1.100',
        type=str,
        required=True,
        help='ip number to send captured data to'
    )
    parser.add_argument(
        '-s', '--serial',
        #action='append',
        #nargs='+',
        #const='',
        default='/dev/ttyACM0',
        type=str,
        required=True,
        help='serial address in which it should get data'
    )
    parser.add_argument(
        '-b', '--baudrate',
        #action='append',
        #nargs='+',
        #const='',
        default=115200,
        type=int,
        required=True,
        help='communication baudrate'
    )
    parser.add_argument(
        '-d', '--debug',
        action='store_true',
        help='log all usefull values from arduino to log file'
    )

    return parser.parse_known_args()



def openSerial(port, baudrate):
    arduino = serial.Serial(
        port=port,
        baudrate=baudrate,
        timeout=0,
        write_timeout=0
    )

    return arduino



def initSerial(arduino):
    print('waiting...')
    time.sleep(5)
    while (not arduino.isOpen() or not arduino.inWaiting()):
        pass

    # arduino.flushInput()  # Flush input buffer, discarding all its contents
    print('sending some text to start the capture...')
    command = (b'\nDEBUG ON\n' if args1.debug else b'\nDEBUG OFF\n')
    arduino.write(bytes(command))



def openUDP(ip, port=8000):
    # socket UDP
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.connect((ip, port))

    return sock



def exit_application(signal, frame):
    print('You pressed Ctrl+C!')
    arduino.close()
    sys.exit(0)



if __name__ == "__main__":
    args1, unknow = parseArgs()
    
    arduino = openSerial(args1.serial, args1.baudrate)
    signal.signal(signal.SIGINT, exit_application)
    print('Press Ctrl+C to exit')

    initSerial(arduino);
    
    udp = openUDP(args1.ip)
    startCapture(arduino, udp)
