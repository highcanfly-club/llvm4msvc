FROM ubuntu:noble
# possible values arm64 amd64
ARG TARGETARCH=amd64
ARG XWIN_VERSION="0.6.6-rc.2"
ARG DEBIAN_FRONTEND=noninteractive
# possible values x86 x86_64
ARG MSVC_ARCH=x86_64
# possible values i686 x86_64
ARG LLVM_ARCH=x86_64 
LABEL maintainer="Ronan <ronan@parapente.eu.org>"
RUN apt update -y \
    && apt install -y cmake openssl build-essential lld llvm clang curl vim
RUN echo "Run for ${TARGETARCH} / ${MSVC_ARCH} / ${LLVM_ARCH} " ; \
    if [ "$TARGETARCH" = "amd64" ] ; then \
        export _ARCH=x86_64; \
    else \
        export _ARCH=aarch64 ; \
    fi \
    && echo "TARGETARCH=$_ARCH" \
    && export URL="https://github.com/Jake-Shadle/xwin/releases/download/${XWIN_VERSION}/xwin-${XWIN_VERSION}-${_ARCH}-unknown-linux-musl.tar.gz" \
    && echo "URL=$URL" \
    && curl -fLSs "$URL" | tar -xvz \
    && mv xwin-${XWIN_VERSION}-${_ARCH}-unknown-linux-musl/xwin /usr/local/bin/  \
    && xwin --arch $MSVC_ARCH --accept-license splat --output /usr/share/msvc \
    && rm -rf xwin-${XWIN_VERSION}-${_ARCH}-unknown-linux-musl \
    && rm -rf .xwin-cache
# bug in debian base image ???
#&& ln -sf lld-link-18 /usr/bin/lld-link 
RUN cmake --version 1> /dev/null 2> /dev/null \
    && apt update -y \
    && apt reinstall libssl3 openssl \
    && cmake --version
RUN ln -sf clang-18 /usr/bin/clang-cl && ln -sf llvm-ar-18 /usr/bin/llvm-lib \ 
    && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100 \
    && apt-get remove -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*;

ENV MSVC_BASE="/usr/share/msvc" \
    CC_x86_64_pc_windows_msvc="clang-cl" \
    CXX_x86_64_pc_windows_msvc="clang-cl" \
    AR_x86_64_pc_windows_msvc="llvm-lib" \
    LINK_x86_64_pc_windows_msvc="lld-link"

ENV CL_FLAGS="-Wno-unused-command-line-argument -fuse-ld=lld-link /I ${MSVC_BASE}/crt/include /I ${MSVC_BASE}/sdk/include/ucrt /I ${MSVC_BASE}/sdk/include/um /I ${MSVC_BASE}/sdk/include/shared" \ 
    LINK_FLAGS="/libpath:${MSVC_BASE}/sdk/lib/um/${MSVC_ARCH} /libpath:${MSVC_BASE}/sdk/lib/ucrt/${MSVC_ARCH} /libpath:${MSVC_BASE}/crt/lib/${MSVC_ARCH}"
ENV CFLAGS_x86_64_pc_windows_msvc="${CL_FLAGS}" \
    CXXFLAGS_x86_64_pc_windows_msvc="${CL_FLAGS}" \
    CL="${CC_x86_64_pc_windows_msvc} --target=${LLVM_ARCH}-pc-windows-msvc ${CL_FLAGS}" \
    LINK="${LINK_x86_64_pc_windows_msvc} /lldignoreenv  ${LINK_FLAGS}" 
COPY test /usr/share/msvc/test 
RUN chmod ugo+x /usr/share/msvc/test/test.sh
RUN cd /usr/lib/llvm-18/bin/ && ln -svf clang clang-cl
CMD ["/usr/bin/sleep", "infinity"]