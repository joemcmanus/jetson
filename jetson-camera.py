#!/usr/bin/env python3
import os
import time
from jetbot import Camera, bgr8_to_jpeg

interval_seconds = 5
#camera = Camera()
camera = Camera(width=1025, height=768)

count = 0

while True:
    file_name = os.path.join("./", 'image_%d.jpg' % count)
    with open(file_name, 'wb') as f:
        f.write(bgr8_to_jpeg(camera.value))
    count +=  1
    time.sleep(interval_seconds)
