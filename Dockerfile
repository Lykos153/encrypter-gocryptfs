FROM golang:alpine AS builder
ARG GOCRYPTFS_VERSION=v1.8.0

RUN apk add bash gcc git libc-dev openssl-dev
RUN git clone https://github.com/rfjakob/gocryptfs.git
WORKDIR gocryptfs

RUN git checkout ${GOCRYPTFS_VERSION}
RUN ./build.bash
RUN mv gocryptfs /bin/gocryptfs

FROM alpine:3.14

COPY --from=builder /bin/gocryptfs /usr/local/bin/gocryptfs
RUN apk --no-cache add fuse

COPY run.sh /run.sh

CMD ["/run.sh"]
