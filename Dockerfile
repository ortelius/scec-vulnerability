FROM cgr.dev/chainguard/go@sha256:de4e3ede01a508b268fa5abd35b0fd43aed8c98af92225304b34680e797d14a1 AS builder

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
