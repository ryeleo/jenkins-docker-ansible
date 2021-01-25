# Jenkins Docker Ansible via requirements.txt
A continuous build/deploy solution that installs ansible via `requirements.txt`. This example runs `ansible-playbook` for a simple "hello world" Ansible `main.yml` file.

> Tip: It is nice to lock/set your project's ansible `version` via `requirements.txt`.

The Jenkins console output of this solution copied below for reference: 

```
20:57:07 Connecting to https://api.github.com with no credentials, anonymous access
20:57:07 Jenkins-Imposed API Limiter: Current quota for Github API usage has 47 remaining (5 under budget). Next quota of 60 in 41 min
Obtained Jenkinsfile from e14aaada78cdac7e0fc25ccd0b754e20c5ddf82f
Running in Durability level: MAX_SURVIVABILITY
[Pipeline] Start of Pipeline
[Pipeline] node
Running on nts in /opt/jenkins/workspace/er_ansible_demo_non-ansible-test
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
The recommended git tool is: NONE
No credentials specified
Fetching changes from the remote Git repository
Fetching without tags
Checking out Revision e14aaada78cdac7e0fc25ccd0b754e20c5ddf82f (non-ansible-test)
Commit message: "Simplifying again"
 > git rev-parse --is-inside-work-tree # timeout=10
 > git config remote.origin.url https://github.com/terminalstderr/jenkins-docker-ansible.git # timeout=10
Fetching upstream changes from https://github.com/terminalstderr/jenkins-docker-ansible.git
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
 > git fetch --no-tags --progress https://github.com/terminalstderr/jenkins-docker-ansible.git +refs/heads/non-ansible-test:refs/remotes/origin/non-ansible-test # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f e14aaada78cdac7e0fc25ccd0b754e20c5ddf82f # timeout=10
 > git rev-list --no-walk 0406f84a8af7efdb8a3ada100a80058ee4add8a3 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Agent Setup)
[Pipeline] isUnix
[Pipeline] readFile
[Pipeline] sh
+ docker build -t 572c6a921e7af07e54d412f207ad505d5455249b -f Dockerfile .
Sending build context to Docker daemon  127.5kB

Step 1/3 : FROM python:3.9
3.9: Pulling from library/python
Digest: sha256:d2f437a450a830c4d3b0b884c3d142866cc879268ebc83f00f74fc4f2d9eaaa1
Status: Downloaded newer image for python:3.9
 ---> da24d18bf4bf
Step 2/3 : COPY requirements.txt /tmp/
 ---> Using cache
 ---> d1d3622d2304
Step 3/3 : RUN pip3 install -r /tmp/requirements.txt
 ---> Running in 046555b2ed53
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
  Created wheel for ansible: filename=ansible-2.9.13-py3-none-any.whl size=16181746 sha256=0699cb3b823459517b2b0a07c90d67b1b3dff248e5a19bec6cad3042bae510af
  Stored in directory: /root/.cache/pip/wheels/6d/17/8f/7f0d6d49a07447b4867d9e188023c7c8c8160bd67fa61a8a99
  Building wheel for MarkupSafe (setup.py): started
  Building wheel for MarkupSafe (setup.py): finished with status 'done'
  Created wheel for MarkupSafe: filename=MarkupSafe-1.1.1-cp39-cp39-linux_x86_64.whl size=32236 sha256=8beead5d6d6d4de48163736d63d34e8aa8d5e3d754825f6298c571eef7ddd519
  Stored in directory: /root/.cache/pip/wheels/e0/19/6f/6ba857621f50dc08e084312746ed3ebc14211ba30037d5e44e
Successfully built ansible MarkupSafe
Installing collected packages: pycparser, six, MarkupSafe, cffi, PyYAML, jinja2, cryptography, ansible
Successfully installed MarkupSafe-1.1.1 PyYAML-5.4.1 ansible-2.9.13 cffi-1.14.4 cryptography-3.3.1 jinja2-2.11.2 pycparser-2.20 six-1.15.0
[91mWARNING: You are using pip version 20.3.3; however, version 21.0 is available.
You should consider upgrading via the '/usr/local/bin/python -m pip install --upgrade pip' command.
[0mRemoving intermediate container 046555b2ed53
 ---> 2f6d4a483c1e
Successfully built 2f6d4a483c1e
Successfully tagged 572c6a921e7af07e54d412f207ad505d5455249b:latest
[Pipeline] }
[Pipeline] // stage
[Pipeline] isUnix
[Pipeline] sh
+ docker inspect -f . 572c6a921e7af07e54d412f207ad505d5455249b
.
[Pipeline] withDockerContainer
nts does not seem to be running inside a container
$ docker run -t -d -u 10:888 --user 0:0 -w /opt/jenkins/workspace/er_ansible_demo_non-ansible-test -v /opt/jenkins/workspace/er_ansible_demo_non-ansible-test:/opt/jenkins/workspace/er_ansible_demo_non-ansible-test:rw,z -v /opt/jenkins/workspace/er_ansible_demo_non-ansible-test@tmp:/opt/jenkins/workspace/er_ansible_demo_non-ansible-test@tmp:rw,z -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** 572c6a921e7af07e54d412f207ad505d5455249b cat
$ docker top 998160e63a669bf3ac17250e2ba6d463c1c370457f70d4afa19c5891c678c9df -eo pid,comm
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Checkout repository)
[Pipeline] checkout
The recommended git tool is: NONE
No credentials specified
Warning: JENKINS-30600: special launcher org.jenkinsci.plugins.docker.workflow.WithContainerStep$Decorator$1@517f00bb; decorates RemoteLauncher[hudson.remoting.Channel@510fd07b:nts] will be ignored (a typical symptom is the Git executable not being run inside a designated container)
Fetching changes from the remote Git repository
Fetching without tags
Checking out Revision e14aaada78cdac7e0fc25ccd0b754e20c5ddf82f (non-ansible-test)
Commit message: "Simplifying again"
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
 > git fetch --no-tags --progress https://github.com/terminalstderr/jenkins-docker-ansible.git +refs/heads/non-ansible-test:refs/remotes/origin/non-ansible-test # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f e14aaada78cdac7e0fc25ccd0b754e20c5ddf82f # timeout=10
ansible 2.9.13
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
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
$ docker stop --time=1 998160e63a669bf3ac17250e2ba6d463c1c370457f70d4afa19c5891c678c9df
$ docker rm -f 998160e63a669bf3ac17250e2ba6d463c1c370457f70d4afa19c5891c678c9df
[Pipeline] // withDockerContainer
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```