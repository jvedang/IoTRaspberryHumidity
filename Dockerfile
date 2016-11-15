FROM resin/rpi-raspbian

#Install Utility

RUN apt-get -q update \
	&& apt-get -qy install \
 		wget \
		python python-dev python-pip python-virtualenv \
		build-essential  \
		curl \
        	git 
		
RUN apt-get -y install nodejs
RUN apt-get install npm
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install Node.js
#RUN \
#	curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
#	sudo apt-get install -y nodejs

# Defines our working directory in container
WORKDIR /usr/src/app
# Copies the package.json first for better cache on later pushes
COPY package.json package.json

# This install npm dependencies on the resin.io build server,
# making sure to clean up the artifacts it creates in order to reduce the image size.
RUN JOBS=MAX npm install --production --unsafe-perm && npm cache clean && rm -rf /tmp/*

# This will copy all files in our root to the working  directory in the container
COPY . ./

# Enable systemd init system in container
ENV INITSYSTEM=on

# server.js will run when container starts up on the device
CMD ["npm", "start"]
