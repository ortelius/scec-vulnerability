FROM cgr.dev/chainguard/go@sha256:f4db6d6cf7edf5190b8b4923ecd8aeeeab856bc7777fcdddbd9c542aeb7aac92 AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:3f5e1fc01f9b1de01f3ba03c95db51844ed9068938b3e6be43935c6967565450

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
