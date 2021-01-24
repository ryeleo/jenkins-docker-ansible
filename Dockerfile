FROM python:3.8-slim

# Just need to install dependencies
copy requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt
