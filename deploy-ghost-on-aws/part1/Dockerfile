# Base our image from the community managed ghost image
FROM ghost:3.21.0

# Install mysql cli client
RUN apt-get update -y && apt-get install -y default-mysql-client
# Copy across the 'wait for it' shell script used to wait for mysql to be available
COPY ./wait-for-mysql.sh /usr/local/bin/wait-for-mysql.sh