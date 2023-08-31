FROM cgr.dev/chainguard/go@sha256:6fee3fff87854aa6e4762c7998c127436a68b09877f9c1010deca35e0f1e27bc AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:2996996931f356b385c81f4c0f7cd8ddf66f8b4ebbb086cecc6516c8a4552e1c

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
