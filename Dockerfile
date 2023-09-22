FROM debian:latest
ARG TARGETARCH
ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="Ronan <ronan@parapente.eu.org>"
RUN apt update -y \
    && apt install -y lld llvm clang curl vim cmake openssl build-essential
RUN echo "Run for $TARGETARCH" && \
    if [[ "$TARGETARCH" == "amd64" ]] ; then \
        _ARCH=amd64; \
    else \
        _ARCH=aarch64 ; \
    fi \
    && curl -fLSs https://github.com/Jake-Shadle/xwin/releases/download/0.3.1/xwin-0.3.1-${_ARCH}-unknown-linux-musl.tar.gz | tar -xvz \
    && mv xwin-0.3.1-${_ARCH}-unknown-linux-musl/xwin /usr/local/bin/  \
    && xwin --accept-license splat --output /usr/share/msvc \
    && rm -rf xwin-0.3.1-${_ARCH}-unknown-linux-musl \
    && rm -rf .xwin-cache
# bug in debian base image ???
RUN cmake --version 1> /dev/null 2> /dev/null \
    && apt update -y \
    && apt reinstall libssl3 openssl \
    && cmake --version
COPY test /usr/share/msvc/test 
RUN chmod ugo+x /usr/share/msvc/test/test.sh
CMD "/usr/bin/sleep infinity"