FROM multiarch/crossbuild

ENV MACOSX_DEPLOYMENT_TARGET=10.8
ENV CROSS_TRIPLE=x86_64-apple-darwin

ARG LDC_VERSION=1.5.0-beta1

ADD https://github.com/ldc-developers/ldc/releases/download/v${LDC_VERSION}/ldc2-${LDC_VERSION}-linux-x86_64.tar.xz /root/ldc-linux.tar.xz
ADD https://github.com/ldc-developers/ldc/releases/download/v${LDC_VERSION}/ldc2-${LDC_VERSION}-osx-x86_64.tar.xz /root/ldc-darwin.tar.xz

RUN \
  mkdir /root/ldc-linux && \
  mkdir /root/ldc-darwin

RUN cd /root && tar --strip 1 -C /root/ldc-linux -x -f /root/ldc-linux.tar.xz
RUN cd /root && tar --strip 1 -C /root/ldc-darwin -x -f /root/ldc-darwin.tar.xz

RUN mkdir -p /usr/local/libexec/ldc

RUN cp -R /root/ldc-linux/bin /usr/local/libexec/ldc
RUN ln -s /usr/local/libexec/ldc/bin/* /usr/local/bin
RUN rm /usr/local/bin/ldc2

RUN cp -R /root/ldc-darwin/lib /usr/local/libexec/ldc
RUN cp -R /root/ldc-darwin/etc /usr/local/libexec/ldc
RUN cp -R /root/ldc-darwin/import /usr/local/libexec/ldc

RUN echo '#!/bin/bash\n\nset -eu\n\n/usr/local/libexec/ldc/bin/ldc2 -mtriple x86_64-apple-darwin $@' > /usr/local/bin/ldc2
RUN chmod +x /usr/local/bin/ldc2

RUN rm -rf /root/ldc*
