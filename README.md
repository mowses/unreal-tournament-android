# unreal-tournament99-VR
This project aims to turn Unreal Tournament '99 Goty into a Virtual Reality VR using some kind of oculus.
I have done it using my own mobile phone in a cardboard. My phone had no gyroscopes so to make it work I adapted two mpu6050 sensors: one for the head and another for the weapon.

Also I have decoupled all default weapons from UT to make it aim independently of the player's view.
In other words, you can face to a direction while shoot to another completely different direction.

This worked very well, but it has a minimal latency while you move the weapon and view. The latency is less than 100 milliseconds.
The communication is done from the sensors with arduino using C, then goes to PC and communicate via UDP to UT99 using python.
UDP does not garantee packets arriving in the same order as they have been sent, but we already deal with this discarding old packets.

Feel free to fork, comment and improve this project.
