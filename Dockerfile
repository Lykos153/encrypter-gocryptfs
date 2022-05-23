FROM golang:alpine AS builder
ARG GOCRYPTFS_VERSION=v2.2.1

RUN apk add bash gcc git libc-dev openssl-dev gnupg
RUN git clone https://github.com/rfjakob/gocryptfs.git

RUN wget https://nuetzlich.net/gocryptfs-signing-key.pub
RUN gpg --import gocryptfs-signing-key.pub

WORKDIR gocryptfs

RUN git tag -v ${GOCRYPTFS_VERSION}
RUN git checkout ${GOCRYPTFS_VERSION}
RUN ./build.bash
RUN mv gocryptfs /bin/gocryptfs

FROM alpine:3.16

COPY --from=builder /bin/gocryptfs /usr/local/bin/gocryptfs
RUN apk --no-cache add fuse

COPY run.sh /run.sh

CMD ["/run.sh"]
