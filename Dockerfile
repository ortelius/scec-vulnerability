FROM cgr.dev/chainguard/go@sha256:6da11f839eb4b911f7aa8c289cd0b8acfe5ebd2a8face82f7c403f400bac30a3 AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:bdd5ed7cfa9ee9704283c61eb5d27ef5381c6198ef5aab8b736038c1c60befca

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
