ARG UID
ARG GID
FROM python:3.9

# Create the jenkins user with a home directory
RUN groupadd --gid $GID jenkins && useradd --uid $UID --gid $GID --create-home jenkins

COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt
