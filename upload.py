# Import gcloud
# sudo pip3 install --upgrade google-cloud-storage
from google.cloud import storage
import os
import picamera
from time import *
from subprocess  import call
import datetime as dt
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
import time
from datetime import datetime


os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="/home/pi/Documents/FIT5140New/FIT5140-auth.json"
# Enable Storage
client = storage.Client()
bucket = client.get_bucket('fit5140-assignment3-257610.appspot.com')
# Reference an existing bucket.

command = "rm video.h264"
call([command], shell=True)



camera = picamera.PiCamera(resolution=(1280, 720), framerate=24)
camera.start_preview()
camera.annotate_background = picamera.Color('black')
camera.annotate_text = dt.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
camera.start_recording('video.h264')
start = dt.datetime.now()
while (dt.datetime.now() - start).seconds < 10:
    camera.annotate_text = dt.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    camera.wait_recording(0.2)
camera.stop_recording()

now = datetime.now()
nowTime = now.strftime("%Y") + "-"+ now.strftime("%m")+ "-"+ now.strftime("%d") + "-"+ now.strftime("%X")
videoTime = now.strftime("%Y") +"-"+ now.strftime("%m")+ "-"+now.strftime("%d") + "-"+ now.strftime("%X")
videofilename = "%s.mp4" % videoTime
filename = "%s.jpeg" % nowTime
videopath = "/home/pi/"
filepath = "/home/pi/captures/"

    
command = "MP4Box -add video.h264 %s" % videofilename
call([command], shell=True)

camera.start_preview()
sleep(3)
camera.capture(filepath+filename)
camera.stop_preview()

 



# Upload a local file to a new file to be created in your bucket.
videoPath = "video/%s" % videofilename
blob = bucket.blob(videoPath)
blob.upload_from_filename(videopath+videofilename)
blob.make_public()
print(blob.public_url)

imagePath = "image/%s" % filename
imageBlob = bucket.blob(imagePath)
imageBlob.upload_from_filename(filepath+filename)
print(imageBlob.public_url)

message = Mail(
    from_email='HomeSecurity@gmail.com',
    to_emails='tuacdawx@gmail.com',
    subject='You have a new vistor',
    html_content='<strong>Please check the app. There is a new vistor</strong>')



try:
    sg = SendGridAPIClient('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')
    response = sg.send(message)
    print(response.status_code)
    print(response.body)
    print(response.headers)
except Exception as e:
    print(str(e))








