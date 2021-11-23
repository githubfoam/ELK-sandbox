#FROM jenkins/jenkins:jdk11
FROM jenkins/jenkins:lts-jdk11

#copy the list of plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt

# run the install-plugins script to install the plugins
# RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh configuration-as-code job-dsl blueocean workflow-job workflow-cps ansible matrix-auth cobertura parameterized-trigger

# disable the setup wizard as jenkins as code is run
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# copy the seedjob file into the image
COPY seedjob.groovy /usr/local/seedjob.groovy
COPY seedjob.groovy /usr/local/example_job_1.groovy 

# copy the config-as-code yaml file into the image
# COPY jenkins-casc.yaml /usr/local/jenkins-casc.yaml
COPY jenkins.yaml /usr/local/jenkins.yaml

# config-as-code plugin where to find the yaml file
ENV CASC_JENKINS_CONFIG /usr/local/jenkins.yaml