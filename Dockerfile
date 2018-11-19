FROM debian:jessie-slim
LABEL maintainer="Omid_A <omid@kabal.se>"

ARG SIAPRIME_VERSION="1.3.5.1"
ARG SIAPRIME_PACKAGE="SiaPrime-v${SIAPRIME_VERSION}-linux-amd64"
ARG SIAPRIME_ZIP="${SIAPRIME_PACKAGE}.zip"
ARG SIAPRIME_RELEASE="https://siaprime.net/releases/${SIA_ZIP}"
ARG SIAPRIME_DIR="/siaprime"
ARG SIAPRIME_DATA_DIR="/siaprime-data"

RUN apt-get update && apt-get install -y \
  socat \
  wget \
  unzip

RUN wget "https://siaprime.net/releases/SiaPrime-v1.3.5.1-linux-amd64.zip" && \
      mkdir "$SIAPRIME_DIR" && \
      unzip -j "$SIAPRIME_ZIP" "${SIAPRIME_PACKAGE}/spc" -d "$SIAPRIME_DIR" && \
      unzip -j "$SIAPRIME_ZIP" "${SIAPRIME_PACKAGE}/spd" -d "$SIAPRIME_DIR"

# Clean up. 
RUN apt-get remove -y wget unzip && \
    rm "$SIAPRIME_ZIP" && \
    rm -rf /var/lib/apt/lists/* && \
    rm -Rf /usr/share/doc && \
    rm -Rf /usr/share/man && \
    apt-get autoremove -y && \
    apt-get clean

EXPOSE 4280 4281 4282

WORKDIR "$SIAPRIME_DIR"

ENV SIAPRIME_DATA_DIR "$SIAPRIME_DATA_DIR"
ENV SIAPRIME_MODULES gctwhr

ENTRYPOINT socat tcp-listen:4280,reuseaddr,fork tcp:localhost:8000 & \
  ./spd \
    --modules "$SIAPRIME_MODULES" \
    --sia-directory "$SIAPRIME_DATA_DIR" \
--api-addr "localhost:8000"
