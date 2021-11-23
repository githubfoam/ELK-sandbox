# Had to use alpine since the normal latest jenkins doesn't support dind (docker in docker)
FROM jenkins/jenkins:alpine

# disable the setup wizard as jenkins as code is run
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Jenkins config
COPY jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml

# Required for CASC plugin
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs/jenkins.yaml

# Install plugins via install-plugins.sh. Also possible to write plugins in text file and mount here
# RUN /usr/local/bin/install-plugins.sh configuration-as-code configuration-as-code-support job-dsl workflow-aggregator bitbucket cloudbees-bitbucket-branch-source docker-plugin
RUN /usr/local/bin/install-plugins.sh configuration-as-code job-dsl workflow-aggregator bitbucket cloudbees-bitbucket-branch-source docker-plugin

# Root user for permissions
USER root
# Install stuff needed in for builds. If using seperate slave nodes not necessary
# RUN apk --no-cache add docker && apk --no-cache add sudo && apk --no-cache add py-pip && apk update

# RUN pip install docker-compose
# Give jenkins access to docker with sudo. (Safer than adding jenkins to docker group)
RUN echo "jenkins ALL=(ALL) NOPASSWD: /usr/bin/docker" >> /etc/sudoers
RUN echo "jenkins ALL=(ALL) NOPASSWD: /usr/bin/docker-compose" >> /etc/sudoers

# Switch back to jenkins user for security
USER jenkins