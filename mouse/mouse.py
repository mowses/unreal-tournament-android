import pyautogui # https://pypi.python.org/pypi/PyAutoGUI
import time
#time.sleep(12)

def angDiff(a1, a2):
	return 180 - abs(abs(a1 - a2) - 180)

def getDirection(a, b):
	return 1 if (a - b + 360) % 360 >= 180 else -1

screenWidth, screenHeight = pyautogui.size()
half_width = screenWidth / 2
half_height = screenHeight / 2
pyautogui.moveTo(half_width, half_height)
currentMouseX, currentMouseY = pyautogui.position()
currentRotation = 0
currentTilt = 0
tiltCenter = 393
pixelsByDegreesTilt = (tiltCenter * 2) / 45
pixelsByDegrees = half_width / 45
pyautogui.PAUSE = 0
pyautogui.FAILSAFE = True

def absoluteRotateTo(deg):
	global currentRotation

	deg = deg % 360
	diff = angDiff(currentRotation, deg)
	direction = getDirection(currentRotation, deg)
	x = diff / 45
	while x >= 1:
		currentRotation += 45 * direction
		pyautogui.moveTo(screenWidth if direction >= 0 else 0, currentMouseY, 0)
		x -= 1

	remainder = (diff % 45) * direction
	pyautogui.moveTo(half_width + remainder * pixelsByDegrees, currentMouseY, 0)
	currentRotation += remainder
	currentRotation = currentRotation % 360
	return currentRotation


def absoluteTiltTo(deg):  # deg ranges: 0 to 90, 0 to -90
	global currentTilt

	diff = abs(currentTilt - deg)
	direction = 1 if deg - currentTilt >= 0 else -1
	x = min(diff / 45, 1)  # limited to 1 because may bug but I dont really know
	while x >= 1:
		currentTilt += 45 * direction
		pyautogui.moveRel(None, -half_height * direction, 0)
		x -= 1

	remainder = (diff % 45) * direction
	pyautogui.moveRel(None, -remainder * pixelsByDegreesTilt, 0)
	currentTilt += remainder
	
	return currentTilt



print(screenWidth, 'x', screenHeight)
print(half_width, 'x', half_height)
print(currentMouseX, 'x', currentMouseY)
print('============')
# mouse sensitivity 1.31 without mouse smoothing - set x to 0 to in game rotate 45 degrees
degrees = 0

# while True:
# 	current = absoluteTiltTo(0)
# 	print(current)
# 	time.sleep(1)

# 	current = absoluteTiltTo(45)
# 	print(current)
# 	time.sleep(1)

# 	current = absoluteTiltTo(90)
# 	print(current)
# 	time.sleep(1)


# 	current = absoluteTiltTo(45)
# 	print(current)
# 	time.sleep(1)


# 	current = absoluteTiltTo(0)
# 	print(current)
# 	time.sleep(1)


# 	current = absoluteTiltTo(-45)
# 	print(current)
# 	time.sleep(1)

# 	current = absoluteTiltTo(-90)
# 	print(current)
# 	time.sleep(1)

# 	current = absoluteTiltTo(-45)
# 	print(current)
# 	time.sleep(1)


# 	current = absoluteTiltTo(0)
# 	print(current)
# 	time.sleep(1)

# 	current = absoluteTiltTo(90)
# 	print(current)
# 	time.sleep(1)


# 	current = absoluteTiltTo(-90)
# 	print(current)
# 	time.sleep(1)

	
# 	break
# 	#degrees += 45
# 	print('====loop')
	
	# absoluteRotateTo(45)
	# time.sleep(2)
#pyautogui.click()
#pyautogui.rightClick()

# pyautogui.moveRel(None, 10) # move mouse 10 pixels down
# pyautogui.doubleClick()
# pyautogui.moveTo(500, 500, duration=2, tween=pyautogui.tweens.easeInOutQuad) # use tweening/easing function to move mouse over 2 seconds.
# pyautogui.typewrite('Hello world!', interval=0.25) # type with quarter-second pause in between each key
# pyautogui.press('esc')
# pyautogui.keyDown('shift')
# pyautogui.typewrite(['left', 'left', 'left', 'left', 'left', 'left'])
# pyautogui.keyUp('shift')
# pyautogui.hotkey('ctrl', 'c')