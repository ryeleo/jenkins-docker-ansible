# Jenkins Docker Ansible via requirements.txt

A continuous build/deploy solution that installs ansible in a docker container via `requirements.txt`. This example runs `ansible-playbook` for a simple "hello world" Ansible `main.yml` file.

> Tip: It is nice to lock/set your project's ansible `version` via `requirements.txt`.

## WARNING

NOT RECOMMENDED: After some playing around with this solution, I recognize that this solution does not actually offer good 'seperation of responsability', unfortunately. My Dockerfile needs be aware of the GID and UID of the running Jenkins agent (see below discussion). There might be a solution that allows us to dynamically determine these UID and GID in the Jenkinsfile and pass it as a `--build-arg` -- with that solution I have propogated a strange detail (the jenkins user's details) through my whole CI/CD solution.

CI/CD should be concerned with _integration and deployment_ and should not be concerned with _jenkins server details_. 

> RECOMMENDATION: For running Ansible workflows in Jenkins, I recommend directly managing the Python version on your Jenkins Agent, and use python virtual environments for installing dependencies.

### What's with the 'groupId' and 'userId' in the Jenkinsfile/Dockerfile?

This solution has turned out to be surprisingly complex -- this is because: 

0. Docker and the Jenkins host shared single pool of uids and gids, which is described in ["Understanding how uid and gid work in Docker containers" (external article)](https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf).
1. When ansible runs inside of the docker container, it requires access to some different parts of the filesystem. E.g., it expects a home directory to exist for the user running ansible commands.
2. Some parts of the filesystem are shared between the Jenkins workspace and the docker container (via Docker 'bind volumes'). 
3. We don't want to run 'as root' inside of the container. In particular, this will cause issues if we create any files in the Jenkins workspace -- thos files will be owned by 'user 0' (aka root) even outside of the container. This is a major issue since the 'jenkins' user that is running Jenkins will not be able to delete files owned by user '0' -- jenkins will not be able to cleanup its own jenkins workspaces!

So, our solution that works around all of these issues:
1. Create a 'jenkins' user in our docker container that has the same userId and groupId as the 'jenkins' user that is executing the pipeline.
2. Create a home directory inside the container for that user.

This solution results in a docker container will be able to (1) run ansible commands, and (2) write files to the 'jenkins workspace' where the scripts are running.

## Console Output from a successful run

The Jenkins console output of this solution copied below for reference: 

```
Started by user rleonar7
 > git rev-parse --is-inside-work-tree # timeout=10
Setting origin to https://github.com/terminalstderr/jenkins-docker-ansible.git
 > git config remote.origin.url https://github.com/terminalstderr/jenkins-docker-ansible.git # timeout=10
Fetching origin...
Fetching upstream changes from origin
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
 > git config --get remote.origin.url # timeout=10
using GIT_SSH to set credentials Github access key to access terminalstderr repositories (rleonar7@uoregon.edu)
 > git fetch --tags --progress origin +refs/heads/*:refs/remotes/origin/* # timeout=10
Seen branch in repository origin/main
Seen branch in repository origin/non-ansible-test
Seen 2 remote branches
Obtained Jenkinsfile from 4602205dbf367e87db3b75fd3c8890b8c4ff1348
Running in Durability level: MAX_SURVIVABILITY
[Pipeline] Start of Pipeline
[Pipeline] node
Running on nts in /opt/jenkins/workspace/NTS_docker_ansible_demo_main
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential github_rleonar7
Fetching changes from the remote Git repository
Fetching without tags
Checking out Revision 4602205dbf367e87db3b75fd3c8890b8c4ff1348 (main)
Commit message: "Incorrect capitalization of variables"
 > git rev-parse --is-inside-work-tree # timeout=10
 > git config remote.origin.url https://github.com/terminalstderr/jenkins-docker-ansible.git # timeout=10
Fetching upstream changes from https://github.com/terminalstderr/jenkins-docker-ansible.git
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
using GIT_SSH to set credentials Github access key to access terminalstderr repositories (rleonar7@uoregon.edu)
 > git fetch --no-tags --progress https://github.com/terminalstderr/jenkins-docker-ansible.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 4602205dbf367e87db3b75fd3c8890b8c4ff1348 # timeout=10
 > git rev-list --no-walk 0680c023b025895a42a54dd0e5e1cfe249248485 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Agent Setup)
[Pipeline] isUnix
[Pipeline] readFile
[Pipeline] sh
+ docker build -t 21359bfcb27082f8b8577fa3bd22a049cc7adee6 --build-arg UID=1888 --build-arg GID=1888 -f Dockerfile .
Sending build context to Docker daemon  236.5kB

Step 1/6 : FROM python:3.9
 ---> da24d18bf4bf
Step 2/6 : ARG UID
 ---> Using cache
 ---> 734d989d95ef
Step 3/6 : ARG GID
 ---> Using cache
 ---> 8797c41e92f5
Step 4/6 : RUN groupadd --gid $GID jenkins && useradd --uid $UID --gid $GID --create-home jenkins
 ---> Running in 44280bd41f33
Removing intermediate container 44280bd41f33
 ---> 8bde7dbab0be
Step 5/6 : COPY requirements.txt /tmp/
 ---> 9d6686ae6c88
Step 6/6 : RUN pip3 install -r /tmp/requirements.txt
 ---> Running in 13feeecf941b
Collecting ansible==2.9.13
  Downloading ansible-2.9.13.tar.gz (14.3 MB)
Collecting cryptography
  Downloading cryptography-3.3.1-cp36-abi3-manylinux2010_x86_64.whl (2.6 MB)
Collecting cffi>=1.12
  Downloading cffi-1.14.4-cp39-cp39-manylinux1_x86_64.whl (405 kB)
Collecting six>=1.4.1
  Downloading six-1.15.0-py2.py3-none-any.whl (10 kB)
Collecting jinja2
  Downloading Jinja2-2.11.2-py2.py3-none-any.whl (125 kB)
Collecting MarkupSafe>=0.23
  Downloading MarkupSafe-1.1.1.tar.gz (19 kB)
Collecting pycparser
  Downloading pycparser-2.20-py2.py3-none-any.whl (112 kB)
Collecting PyYAML
  Downloading PyYAML-5.4.1-cp39-cp39-manylinux1_x86_64.whl (630 kB)
Building wheels for collected packages: ansible, MarkupSafe
  Building wheel for ansible (setup.py): started
  Building wheel for ansible (setup.py): finished with status 'done'
  Created wheel for ansible: filename=ansible-2.9.13-py3-none-any.whl size=16181746 sha256=a40f3865a2796c17f940424d73d9876de59fda0185a0834f7c70da71248c699c
  Stored in directory: /root/.cache/pip/wheels/6d/17/8f/7f0d6d49a07447b4867d9e188023c7c8c8160bd67fa61a8a99
  Building wheel for MarkupSafe (setup.py): started
  Building wheel for MarkupSafe (setup.py): finished with status 'done'
  Created wheel for MarkupSafe: filename=MarkupSafe-1.1.1-cp39-cp39-linux_x86_64.whl size=32245 sha256=71d2aac876fc3055b333d3ba722c145cebe2984e1e27d59259e93ec2c73cdb93
  Stored in directory: /root/.cache/pip/wheels/e0/19/6f/6ba857621f50dc08e084312746ed3ebc14211ba30037d5e44e
Successfully built ansible MarkupSafe
Installing collected packages: pycparser, six, MarkupSafe, cffi, PyYAML, jinja2, cryptography, ansible
Successfully installed MarkupSafe-1.1.1 PyYAML-5.4.1 ansible-2.9.13 cffi-1.14.4 cryptography-3.3.1 jinja2-2.11.2 pycparser-2.20 six-1.15.0
[91mWARNING: You are using pip version 20.3.3; however, version 21.0 is available.
You should consider upgrading via the '/usr/local/bin/python -m pip install --upgrade pip' command.
[0mRemoving intermediate container 13feeecf941b
 ---> 2464bd5b0e74
Successfully built 2464bd5b0e74
Successfully tagged 21359bfcb27082f8b8577fa3bd22a049cc7adee6:latest
[Pipeline] }
[Pipeline] // stage
[Pipeline] isUnix
[Pipeline] sh
+ docker inspect -f . 21359bfcb27082f8b8577fa3bd22a049cc7adee6
.
[Pipeline] withDockerContainer
nts does not seem to be running inside a container
$ docker run -t -d -u 1888:1888 -w /opt/jenkins/workspace/NTS_docker_ansible_demo_main -v /opt/jenkins/workspace/NTS_docker_ansible_demo_main:/opt/jenkins/workspace/NTS_docker_ansible_demo_main:rw,z -v /opt/jenkins/workspace/NTS_docker_ansible_demo_main@tmp:/opt/jenkins/workspace/NTS_docker_ansible_demo_main@tmp:rw,z -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** 21359bfcb27082f8b8577fa3bd22a049cc7adee6 cat
$ docker top 3ab5016638759332318dfc71aa59aa465bef5d8fda89003ad2ca7e9bf34a2b19 -eo pid,comm
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Checkout repository)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential github_rleonar7
Warning: JENKINS-30600: special launcher org.jenkinsci.plugins.docker.workflow.WithContainerStep$Decorator$1@1e8dc537; decorates RemoteLauncher[hudson.remoting.Channel@5366540a:nts] will be ignored (a typical symptom is the Git executable not being run inside a designated container)
Fetching changes from the remote Git repository
Fetching without tags
Checking out Revision 4602205dbf367e87db3b75fd3c8890b8c4ff1348 (main)
Commit message: "Incorrect capitalization of variables"
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Run ansible in docker, eh?)
[Pipeline] sh
+ ansible --version
 > git rev-parse --is-inside-work-tree # timeout=10
 > git config remote.origin.url https://github.com/terminalstderr/jenkins-docker-ansible.git # timeout=10
Fetching upstream changes from https://github.com/terminalstderr/jenkins-docker-ansible.git
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
using GIT_SSH to set credentials Github access key to access terminalstderr repositories (rleonar7@uoregon.edu)
 > git fetch --no-tags --progress https://github.com/terminalstderr/jenkins-docker-ansible.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 4602205dbf367e87db3b75fd3c8890b8c4ff1348 # timeout=10
ansible 2.9.13
  config file = None
  configured module search path = ['/home/jenkins/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.9/site-packages/ansible
  executable location = /usr/local/bin/ansible
  python version = 3.9.1 (default, Jan 12 2021, 16:45:25) [GCC 8.3.0]
[Pipeline] sh
+ ansible-playbook main.yml
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that
the implicit localhost does not match 'all'

PLAY [Just debugging playbook] *************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [Hello world] *************************************************************
ok: [127.0.0.1] => {
    "msg": "Hello, world!"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

[Pipeline] }
[Pipeline] // stage
[Pipeline] }
$ docker stop --time=1 3ab5016638759332318dfc71aa59aa465bef5d8fda89003ad2ca7e9bf34a2b19
$ docker rm -f 3ab5016638759332318dfc71aa59aa465bef5d8fda89003ad2ca7e9bf34a2b19
[Pipeline] // withDockerContainer
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```