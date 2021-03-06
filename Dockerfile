FROM adoptopenjdk/maven-openjdk11

RUN mkdir /usr/myapp

COPY target/java-kubernetes.jar /usr/myapp/app.jar
WORKDIR /usr/myapp

EXPOSE 8080

ENTRYPOINT [ "sh", "-c", "java  $JAVA_OPTS -jar app.jar" ]
