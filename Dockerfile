FROM cgr.dev/chainguard/go@sha256:38db527239c4b33c6ebd1751007041e33cdf81de45f2195b1a60816eb351def1 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:31073f3a1add4bfc3ce4ee474ee171bf9dcc9799a468a39c8180c45ddf11c883

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
