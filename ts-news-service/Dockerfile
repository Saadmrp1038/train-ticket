FROM golang:1.21 AS builder

WORKDIR /app
COPY ./src/main/main.go .

RUN CGO_ENABLED=0 go build -o app main.go

FROM alpine:3.19
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone

WORKDIR /app
COPY --from=builder /app/app .
CMD ["./app"]
EXPOSE 12862
