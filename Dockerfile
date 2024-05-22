FROM cgr.dev/chainguard/go@sha256:c531ef65c3190e83318cf19b3d6386d3e4be6a66cca2d76bb6ff15bce8ee6a02 AS builder

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
