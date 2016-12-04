FROM resin/rpi-raspbian

#Install Utility

RUN apt-get -q update \
	&& apt-get -qy install \
 		wget \
		python python-dev python-pip python-virtualenv \
		build-essential  \
		curl \
        	git 
		
#RUN apt-get -y install nodejs
#RUN apt-get install npm
#RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN pip install paho-mqtt
# Install Node.js
#RUN \
#	curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
#	sudo apt-get install -y nodejs

# Enable systemd init system in container
ENV INITSYSTEM=on



#Adding code to testing
# Defines our working directory in container
WORKDIR /usr/src/app

RUN git clone https://github.com/jvedang/IoTRaspberryHumidity.git

WORKDIR /usr/src/app/IoTRaspberryHumidity

# Copies the package.json first for better cache on later pushes
#COPY package.json package.json

RUN git clone https://github.com/adafruit/Adafruit_Python_DHT.git

WORKDIR /usr/src/app/IoTRaspberryHumidity/Adafruit_Python_DHT
RUN sudo python setup.py install --force-pi2
#CMD ["python", "setup.py install"]

#WORKDIR /usr/src/app

# RUN su root -c "python server.py"
# This install npm dependencies on the resin.io build server,
# making sure to clean up the artifacts it creates in order to reduce the image size.
#RUN JOBS=MAX npm install --production --unsafe-perm && npm cache clean && rm -rf /tmp/*

# This will copy all files in our root to the working  directory in the container
COPY . ./

# server.py will run when container starts up on the device
CMD ["python", "/usr/src/app/IoTRaspberryHumidity/server.py"]
