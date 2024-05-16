FROM cgr.dev/chainguard/go@sha256:6011c1778c16972f52b9c840bf668b23973e5cdfa5ad09ce24af6c76673bc492 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:663e3dd9d4c09141cc0a8a534662bc286318ad9102e9824121d97b332627713b

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
