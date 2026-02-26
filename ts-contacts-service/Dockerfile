FROM eclipse-temurin:8-jre

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

WORKDIR /app

COPY target/ts-contacts-service-1.0.jar app.jar

EXPOSE 12347
ENTRYPOINT ["java", "-jar", "app.jar"]
