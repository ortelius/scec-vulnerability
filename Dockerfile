FROM cgr.dev/chainguard/go@sha256:9aa4a854b43f17f60257be559dd2faed470f38a6b0d78d76f3fda47a08bc024a AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:5992cb1b65c19a68f941f0bfca09df63aac7206f94809648f30e9491d5e96c6b

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
