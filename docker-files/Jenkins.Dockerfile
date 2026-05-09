FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*
USER jenkins
COPY --chown=jenkins:jenkins certificate.pfx /var/lib/jenkins/certificate.pfx
COPY --chown=jenkins:jenkins https.key /var/lib/jenkins/pk
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8080 --httpsKeyStore=/var/lib/jenkins/certificate.pfx --httpsKeyStorePassword=yogeshs
EXPOSE 8080