FROM cgr.dev/chainguard/go@sha256:c87a8cf30c9a4e58df04712e1bb0b98d8d0421cc924e88f6fca4a6fabf45c6b4 AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:85d814d0b8684622d0da580ccd9cb2fbbcc9962b480dd1fb948d3462d18d3847

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
