FROM cgr.dev/chainguard/go@sha256:a50b9f354ad5a645e15b2bf97ac1153e650e7a0eec46cb014875019db1081a4d AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:0d70ebbd9ea42ce8111ebd3c21479ff00ebabea4bc39477aad44408b9ec3c13b

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
