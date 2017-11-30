FROM arm64v8/debian:stretch

RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

RUN apt-get update -y && apt-get -y install curl && \
   curl -O https://fastdl.mongodb.org/linux/mongodb-linux-arm64-ubuntu1604-3.4.10.tgz && \
   tar -zxvf mongodb-linux-arm64-ubuntu1604-3.4.10.tgz && \
   mv mongodb-linux-aarch64-ubuntu1604-3.4.10/bin/* /usr/bin/ && \
   rm mongodb-linux-arm64-ubuntu1604-3.4.10.tgz && \
   curl -O http://ftp.fr.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u6_arm64.deb && \
   dpkg -i libssl1.0.0_1.0.1t-1+deb8u6_arm64.deb && \
   apt-get remove --purge -y curl && \
   rm -rf /tmp/* /var/tmp/* && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data/db && chown -R mongodb:mongodb /data/db

USER mongodb

# Define mountable directories.
VOLUME ["/data/db"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["mongod"]

# Expose ports.
#   - 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017
