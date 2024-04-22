FROM cgr.dev/chainguard/go@sha256:159e1bcd846e4244fdb412845b18e91e34342fe4c518087184b944916f9d03fe AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:6dff3d81e2edaa0ef48ea87b808c34c4b24959169d9ad317333bdda4ec3c4002

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
