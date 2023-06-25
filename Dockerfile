FROM cgr.dev/chainguard/go@sha256:3807753600b59b460ba610816bd552c20e7a213ea04ae4a77d30f25252015ec8 AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:bad6f750e63d7641635623295026d0736b40849f66b0421ce80be9e1c421f6c0

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
