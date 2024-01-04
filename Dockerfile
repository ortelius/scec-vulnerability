FROM cgr.dev/chainguard/go@sha256:1bb05a6845f122363e4a6992773aac5d41de47774fb9345352f2cccc82a1c9fa AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:0b83a18dcd8c46f47cdb9b3b3583f4af7aa5f35b0e7cbe12cae09a07a72f4bd8

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
