FROM cgr.dev/chainguard/go@sha256:990bb8eeb6ecb77e7721bc118b2df8b57075f3c954e2e955a26216633df55d5f AS builder

WORKDIR /app
COPY . /app

RUN go install github.com/swaggo/swag/cmd/swag@latest; \
    /root/go/bin/swag init; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:84330a5c2f3b425a77320bc599a6a813fa986aab9b6a0fd7f58d753d6fe2143e

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
