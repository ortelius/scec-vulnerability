FROM cgr.dev/chainguard/go@sha256:08d316c0f1d271a94cc9fe70e926f531cb3714f87ac9025e6bb64f5e55650541 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:f74e4803c121ac05ee18b475f412d9cf10302587592ce625ea94e2751b57237d

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
