import time
#time.sleep(12)
import socket
import socketio
import eventlet
import eventlet.wsgi
import sys
import argparse
from flask import Flask, render_template
#sys.path.append('./mouse/')
#from mouse import mouse

parser = argparse.ArgumentParser(description='Listen for data to send to UT99 via UDP')
parser.add_argument(
    '-i', '--ip',
    #action='append',
    #nargs='+',
    #const='',
    default='192.168.1.12',
    type=str,
    required=True,
    help='ip number to send captured data to'
)   
args1, unknown = parser.parse_known_args()

sio = socketio.Server()
app = Flask(__name__)
last_timestamp = 0
last_pan = None
last_tilt = None

# socket UDP
UDP_IP = args1.ip
UDP_PORT = 8000
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

@app.route('/')
def index():
    """Serve the client-side application."""
    return render_template('index.html')

#@sio.on('connect', namespace='/body')
@sio.on('connect')
def connect(sid, environ):
    last_timestamp = 0
    print("connected body sensors:", sid)

#@sio.on('update data', namespace='/body')
@sio.on('update data')
def message(sid, data):
    global last_timestamp
    global last_pan
    global last_tilt

    ts = data['ts']
    
    if ts <= last_timestamp:
        return

    last_timestamp = ts
    
    pan = str(float(data['orientation']['pan'])).ljust(20, '0')
    # if pan != last_pan:
    #     last_pan = pan
    #     #pan = mouse.absoluteRotateTo(360-data['orientation']['pan'])

    tilt = str(float(data['orientation']['tilt'])).ljust(20, '0')
    # if tilt != last_tilt:
    #     last_tilt = tilt
    #    #tilt = mouse.absoluteTiltTo(-data['orientation']['tilt'])

    ts = str(ts).rjust(20, '0')

    sock.sendto(bytes("{0}|{1},{2}".format(ts, pan, tilt), 'utf-8'), (UDP_IP, UDP_PORT))
    print('update data', ts, pan, tilt)
    

#@sio.on('disconnect', namespace='/body')
@sio.on('disconnect')
def disconnect(sid):
    print("disconnected body sensors:", sid)


# @app.route('/shutdown')
# def shutdown():
#     shutdown_server()
#     return 'Server shutting down...'

if __name__ == '__main__':
    # wrap Flask application with engineio's middleware
    app = socketio.Middleware(sio, app)

    # deploy as an eventlet WSGI server
    eventlet.wsgi.server(eventlet.listen(('', 8000)), app)