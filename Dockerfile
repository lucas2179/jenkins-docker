FROM jenkins/jenkins

ARG HOST_UID=1004
ARG HOST_GID=999

USER root
RUN apt-get -y update && \
    apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io
RUN apt-get install -y jq
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install --yes nodejs
RUN node -v
RUN npm -v
RUN curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
RUN 	apt-get install -y python-pip
RUN 	pip install --upgrade pip
RUN 	pip install --upgrade zapcli
RUN usermod -u $HOST_UID jenkins
RUN groupmod -g $HOST_GID docker
RUN usermod -aG docker jenkins




COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER jenkins
