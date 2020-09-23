FROM openjdk:11-jdk-slim

RUN apt-get update -y
RUN apt-get install curl -y
RUN apt-get install unzip -y

#RUN apk add --no-cache curl tar bash procps

# MAVEN SETUP
ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
RUN mkdir -p /usr/share/maven && \
curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
# Maven JVM optimization
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
#ENTRYPOINT ["/usr/bin/mvn"]


# GRADLE SETUP
ARG GRADLE_VERSION=6.6
RUN mkdir -p /usr/share/gradle && \
curl -L https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip -o gradle-$GRADLE_VERSION-bin.zip && unzip gradle-$GRADLE_VERSION-bin.zip && cp -r gradle-$GRADLE_VERSION/* /usr/share/gradle/ && \
ln -s /usr/share/gradle/bin/mvn /usr/bin/gradle
ENV GRADLE_HOME /usr/share/gradle
ENV PATH "$PATH:$GRADLE_HOME/bin"


# Install project dependencies and keep sources
# make source folder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# install maven POM
COPY pom.xml /usr/src/app

# install gradle build
COPY build.gradle /usr/src/app

# copy other source files
COPY src /usr/src/app/src

#RUN mvn -T 1C install && rm -rf target

# copy build script
#COPY  build-app.sh /usr/src/app
#RUN chmod +x build-app.sh
# Run the build
#CMD   build-app.sh

#maven:
#RUN mvn clean install

#gradle:
#RUN gradle build


CMD ["/bin/bash"]


