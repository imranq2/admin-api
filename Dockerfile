FROM node:14.15.0

# Enable apt-get to run from the new sources.
RUN printf "deb http://archive.debian.org/debian/ \
    jessie main\ndeb-src http://archive.debian.org/debian/ \
    jessie main\ndeb http://security.debian.org \
    jessie/updates main\ndeb-src http://security.debian.org \
    jessie/updates main" > /etc/apt/sources.list

# Update everything on the box
RUN apt-get -y update
RUN apt-get clean

# Install required gnupg package
RUN apt-get update && apt-get -y install gnupg wget

# Install required ca-certificates to prevent the error in the certificate verification
RUN apt-get -y install ca-certificates && update-ca-certificates

# Download the Amazon DocumentDB Certificate Authority (CA) certificate required to authenticate to your cluster
RUN cd / && wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem

RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

RUN apt-get -y update

# Install the MongoDB packages
#RUN apt-get -y install mongodb-org-shell
RUN apt-get -y install mongodb-org-tools

# Set the working directory
WORKDIR /srv/src

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json /srv/src/

RUN cd /srv/src && npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 8080

CMD [ "node", "app.js" ]