FROM jenkins/jenkins:lts-jdk11

COPY --chown=jenkins:jenkins certificate.pfx /var/lib/jenkins/certificate.pfx
COPY --chown=jenkins:jenkins https.key /var/lib/jenkins/pk
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8083 --httpsKeyStore=/var/lib/jenkins/certificate.pfx --httpsKeyStorePassword=Password12
EXPOSE 8083