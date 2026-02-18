FROM eclipse-temurin:8-jre-alpine

# Install timezone data and set Shanghai timezone
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone

WORKDIR /app

# Copy the JAR file
COPY target/ts-contacts-service-1.0.jar app.jar

EXPOSE 12347
ENTRYPOINT ["java", "-jar", "app.jar"]