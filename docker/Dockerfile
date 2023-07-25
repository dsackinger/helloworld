# syntax=docker/dockerfile:1
FROM golang:1.20-alpine AS builder
WORKDIR /src
ADD . /src
RUN apk update && apk add \
    make \
    git \
    ncurses
RUN make install

# Clean final image
FROM alpine
COPY --from=builder /go/bin/hello /app/hello
WORKDIR /app
ENTRYPOINT ["./hello"]
