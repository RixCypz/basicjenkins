#FROM openjdk:17
FROM openjdk:17-jdk-slim-buster
EXPOSE 8081
ADD target/simple-0.0.1-SNAPSHOT.jar simple-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/simple-0.0.1-SNAPSHOT.jar"]