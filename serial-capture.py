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
args1, unknown = parser.parse_known_args()

def exit_application(signal, frame):
    print('You pressed Ctrl+C!')
    arduino.close()
    sys.exit(0)

signal.signal(signal.SIGINT, exit_application)
print('Press Ctrl+C to exit')

# socket UDP
UDP_IP = args1.ip
UDP_PORT = 8000
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

arduino = serial.Serial(
    port=args1.serial,
    baudrate=args1.baudrate,
    timeout=0.1
)
OUTPUT_FLOAT_PRECISION = 24

if arduino.isOpen():
    arduino.close()

arduino.open()

print('waiting...')
time.sleep(5)
while (not arduino.isOpen() or not arduino.inWaiting()):
    pass

arduino.flushInput()
print('sending some text to start the capture...')
command = (b'\nDEBUG ON\n' if args1.debug else b'\nDEBUG OFF\n')
arduino.write(bytes(command))

log_serial = open('./logs/log_serial.txt', 'w')
log_udp = open('./logs/log_udp.txt', 'w')
log_error = open('./logs/log_error.txt', 'w')

i = 0
while True:
    try:
        if not arduino.inWaiting():  #if incoming bytes are waiting to be read from the serial input buffer
            continue

        line = arduino.readline()
        if not line:
            continue

        i += 1
        ts = str(i).rjust(OUTPUT_FLOAT_PRECISION, '0')
        line = line.decode('ascii').strip()
        cols = line.split('\t')
        
        # log to serial file
        log_serial.write("{0}:{1}\n".format(ts, line))

        if cols[0] == 'ypr' and len(cols) == 4:
            y = str((float(cols[1])+180)*-1).ljust(OUTPUT_FLOAT_PRECISION, '0')
            p = str(float(cols[2])).ljust(OUTPUT_FLOAT_PRECISION, '0')
            
            sent_udp = "{0}:{1},{2}".format(ts, y, p)
            sock.sendto(sent_udp.encode('ascii'), (UDP_IP, UDP_PORT))

            # log to udp file
            log_udp.write("{0}{1}".format(sent_udp, "\n"))
            print (sent_udp)
            continue

        # check for mouse clicks
        if cols[0] == 'BUTTON 3':
            if (cols[1] == '1'):
                pyautogui.mouseDown(button='left')
            else:
                pyautogui.mouseUp(button='left')

            print('{0} {1}'.format(cols[0], cols[1]))
            continue


        

    except Exception as e:
        err = str(e)
        log_error.write("{0}:{1}\n".format(ts, err))
        print(err)


print('closing serial...')
arduino.close()
log_serial.close()
log_udp.close()
log_error.close()