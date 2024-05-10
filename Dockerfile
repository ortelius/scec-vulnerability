FROM cgr.dev/chainguard/go@sha256:4d51574ef33b4edc57a22da062fe335a500eda30a1f1315cb39b4977bf2aef5f AS builder

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
