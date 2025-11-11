# Dockerfile for running CTP DicomAnonymizerTool with required dependencies
FROM eclipse-temurin:8-jdk AS build

ENV ANT_VERSION=1.10.15
ENV ANT_HOME=/opt/ant

# change to tmp folder
WORKDIR /tmp

# Download and extract apache ant to opt folder
RUN wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz.sha512 \
    && echo "$(cat apache-ant-${ANT_VERSION}-bin.tar.gz.sha512) apache-ant-${ANT_VERSION}-bin.tar.gz" | sha512sum -c \
    && tar -zvxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz.sha512

# add executables to path
RUN update-alternatives --install "/usr/bin/ant" "ant" "/opt/ant/bin/ant" 1 && \
    update-alternatives --set "ant" "/opt/ant/bin/ant" 

# Build CTP & DicomAnonymizerTool
COPY CTP/ /build/CTP/
COPY DicomAnonymizerTool/ /build/DicomAnonymizerTool/
WORKDIR /build/CTP
RUN ant
WORKDIR /build/DicomAnonymizerTool
RUN ant

# Install
FROM eclipse-temurin:8 AS dat
COPY --from=build /build/DicomAnonymizerTool/build/DicomAnonymizerTool/ /opt/DAT/
ADD lib* /opt/lib/
RUN chmod +x /opt/lib/*.bin

WORKDIR /opt/java/openjdk
RUN echo yes | /opt/lib/jai-1_1_3-lib-linux-amd64-jdk.bin
RUN echo yes | /opt/lib/jai_imageio-1_1-lib-linux-amd64-jdk.bin

WORKDIR /opt/DAT
ENV CLASSPATH=/opt/DAT/DAT.jar:/opt/DAT/imageio/*:/opt/DAT/libraries/*
CMD ["java","org.rsna.dicomanonymizertool.DicomAnonymizerTool"]
