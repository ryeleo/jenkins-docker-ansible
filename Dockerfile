FROM ubuntu:latest

# Just need to install dependencies
RUN apt-get update
RUN yes | apt-get upgrade 
RUN yes | apt-get install python3.8 python3-pip

COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt
