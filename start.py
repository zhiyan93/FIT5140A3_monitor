from google.cloud import storage
import os
import time
from time import *
import time
from datetime import datetime
from subprocess  import call
import datetime as dt
import RPi.GPIO as io


io.setmode(io.BCM)
pir_pin = 23
io.setup(pir_pin, io.IN)         # activate input




os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="/home/pi/Documents/FIT5140New/FIT5140-auth.json"
# Enable Storage
client = storage.Client()
bucket = client.get_bucket('fit5140-assignment3-257610.appspot.com')
# Reference an existing bucket.

blob = bucket.blob('validation/true.jpeg')
modeBlob = bucket.blob('validation/mode.jpeg')

def checkMode():
    try:
        filess = modeBlob.download_to_filename('/home/pi/mode.jpeg')
        print("Dectection Mode")
        check()
    except:
        print("Streaming Mode")
        command = "python3 streaming.py"
        call([command], shell=True)


def check():
    try:
      filess = blob.download_to_filename('/home/pi/true.jpeg')
      print("Someone at home")
      print("Home security Unopened")
      print(" ")

    except:
      print("Nobody at home")
      print("Home security Start Working")
      command = "python3 upload.py"
      call([command], shell=True)
      
def checkStreamingMode():
    try:
        filess = modeBlob.download_to_filename('/home/pi/mode.jpeg')
    except:
        print("Streaming Mode")
        command = "python3 streaming.py"
        call([command], shell=True)




    
while True:
    if io.input(pir_pin):
        print ('check status')
        checkMode()
        time.sleep(2)
    time.sleep(0.1)
    checkStreamingMode()
    
    




