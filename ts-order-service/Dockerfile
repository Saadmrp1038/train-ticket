FROM eclipse-temurin:8-jre

LABEL maintainer="TrainTicket F1 Fault Injection"

WORKDIR /app

COPY target/ts-order-service-1.0.jar app.jar

EXPOSE 12031

ENTRYPOINT ["java", "-jar", "app.jar"]
