FROM openjdk:11
COPY target/*.jar application.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","application.jar"]