import time
time.sleep(12)
import socketio
import eventlet
import eventlet.wsgi
import sys
from flask import Flask, render_template
sys.path.append('./mouse/')
from mouse import mouse


sio = socketio.Server()
app = Flask(__name__)
last_timestamp = 0
last_pan = None
last_tilt = None

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
    
    if last_timestamp >= ts:
        return

    last_timestamp = ts
    
    pan = int(data['orientation']['pan'])
    if pan != last_pan:
        last_pan = pan
        pan = mouse.absoluteRotateTo(360-pan)

    tilt = int(data['orientation']['tilt'])
    if tilt != last_tilt:
        last_tilt = tilt
        tilt = mouse.absoluteTiltTo(-tilt)

    print('update data', pan, tilt)
    

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