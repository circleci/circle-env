FROM circleci/ubuntu-server:trusty-latest
RUN apt-get update
RUN apt-get install -y git-core
RUN git clone https://github.com/sstephenson/bats.git && cd bats && ./install.sh /usr/local
ADD dist/circle-env-trusty /usr/local/bin/circle-env
ADD tests/insecure-ssh-key.pub /home/ubuntu/.ssh/authorized_keys
RUN chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys
ADD tests/unit /home/ubuntu/tests
ADD dist/circle-env-trusty /usr/local/bin/circle-env
