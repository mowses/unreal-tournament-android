#from __future__ import division
#import numpy as np
import cv2
import math

pos = [244, 42]
hue_range = 179 / 8
colors = ['red', 'gold', 'lime', 'lightgreen', 'cyan', 'blue', 'magenta', 'pink', 'red']
keys = ['w', 'wd', 'd', 'sd', 's', 'sa', 'a', 'wa', 'w']

cap = cv2.VideoCapture(0)
frame = cv2.imread('./images/8-section-pie-chart.jpg', cv2.IMREAD_COLOR)
cv2.namedWindow('result', flags = cv2.WINDOW_NORMAL)

while True:
	_, frame = cap.read()
	hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
	color = hsv[pos[1], pos[0]]
	index = int(color[0] / hue_range)
	color_name = colors[index]
	print 'index: {0}, color name: {1}, color: {2}, keys: {3}'.format(index, color_name, color, keys[index])
	
	# draw circle
	cv2.circle(frame,(pos[0],pos[1]), 5, (0,0,255), 2)
	cv2.imshow('result',frame)
	
	# check for ESC key
	k = cv2.waitKey(5) & 0xFF
	if k == 27:
		break

cv2.destroyAllWindows()
cap.release()