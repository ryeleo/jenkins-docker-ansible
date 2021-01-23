FROM python:3

# Just need to install dependencies
copy requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt
