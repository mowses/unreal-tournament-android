# list ports: python -m serial.tools.list_ports
import serial
import time
import socket
import sys
import argparse

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
args1, unknown = parser.parse_known_args()

i = 0

# socket UDP
UDP_IP = args1.ip
UDP_PORT = 8000
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

arduino = serial.Serial(
    port=args1.serial,
    baudrate=args1.baudrate,
    timeout=0.1
)

print('waiting...')
time.sleep(5)
arduino.isOpen()
print('sending some text to start the capture...')
arduino.write('send some text just to start the capture'.encode('utf-8'))

log = open('log.txt', 'w')

while True:
    try:
        line = arduino.readline()
        if not line:
            continue
        
        line = line.decode('utf8')
        log.write(line)
        cols = line.strip().split('\t')

        if cols[0] != 'yp' or len(cols) != 3:
            continue

        y = str((float(cols[1])+180)*-1).ljust(20, '0')
        p = str(float(cols[2])).ljust(20, '0')
        i += 1
        ts = str(i).rjust(20, '0')
        
        sock.sendto(("{0}|{1},{2}".format(ts, y, p).encode('utf-8')), (UDP_IP, UDP_PORT))
        print (ts, y, p)
    except:
        pass


print('closing serial...')
arduino.close()
log.close()