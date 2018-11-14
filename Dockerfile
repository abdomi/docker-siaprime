FROM golang AS builder
LABEL maintainer="Omid_A <omid@kabal.se>"

ENV GOOS linux
ENV GOARCH amd64
ENV CGO_ENABLED 0

RUN go get -d -u gitlab.com/SiaPrime/... && \
    cd $GOPATH/src/gitlab.com/SiaPrime && \
    make release

FROM alpine
LABEL maintainer="Omid_A <omid@kabal.se>"

ENV SIAPRIME_DIR /siaprime
ENV SIAPRIME_DATA_DIR="/siaprime-data"
ENV SIAPRIME_MODULES gctwhr

RUN apk --no-cache add socat

WORKDIR "$SIAPRIME_DIR"
COPY --from=builder /go/bin/spd ./
COPY --from=builder go/bin/spc ./
ENTRYPOINT socat tcp-listen:4480,reuseaddr,fork tcp:localhost:8000 & \
  ./spd \
    --modules "$SIAPRIME_MODULES" \
    --siaprime-directory "$SIAPRIME_DATA_DIR" \
--api-addr "localhost:8000"
