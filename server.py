import time
import paho.mqtt.client as mqtt
import Adafruit_DHT
import os

mqttc=mqtt.Client()
mqttc.connect("iot.eclipse.org",1883,60)
mqttc.loop_start()

print "inside Humidity sensor"
print "Inside Humidity sensor"

#read temperature
def read_temp_data():
	humidity, temperature = Adafruit_DHT.read_retry(11, 4)	
	print humidity
	return humidity

#publish temperature
while 1:
	t=read_temp_data()
	print "Publishing Humidity data"
	device_uuid=os.environ['RESIN_DEVICE_UUID'];
	print device_uuid
	(result,mid)=mqttc.publish("topic/GeneralizedIoT/"+str(device_uuid),t,2)
	time.sleep(1)

mqttc.loop_stop()
mqttc.disconnect()
