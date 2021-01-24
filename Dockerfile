FROM ubuntu:latest

# Just need to install dependencies
RUN apt-get install python3
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt
