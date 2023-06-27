FROM cgr.dev/chainguard/go@sha256:f4db6d6cf7edf5190b8b4923ecd8aeeeab856bc7777fcdddbd9c542aeb7aac92 AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:56e24b2276c3974632aa747f0f8d9d443588d4317cb32752b5492c98f03a24b5

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
