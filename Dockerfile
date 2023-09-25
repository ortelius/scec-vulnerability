FROM cgr.dev/chainguard/go@sha256:3dfe24aeddaceb07a93513cad9afc89e0b2d34b7c8fd5cba6e3dc7618adcf822 AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:f3b9f809336da19d31c28a0bd2344b09ce0545ddccac8fa19422d525c4bb2fb9

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/docs docs

ENV ARANGO_HOST localhost
ENV ARANGO_USER root
ENV ARANGO_PASS rootpassword
ENV ARANGO_PORT 8529
ENV MS_PORT 8080

EXPOSE 8080

ENTRYPOINT [ "/app/main" ]
