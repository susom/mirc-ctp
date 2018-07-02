# Dockerfile for running anonymizer on a Mac with full native Image-IO support
FROM openjdk:8

ENV HOME /app

WORKDIR /app
ADD DAT /app/DAT
ADD lib /app/lib

WORKDIR /usr/lib/jvm/java-8-openjdk-amd64
RUN chmod +x /app/lib/*.bin
RUN echo yes | /app/lib/jai-1_1_3-lib-linux-amd64-jdk.bin
RUN echo yes | /app/lib/jai_imageio-1_1-lib-linux-amd64-jdk.bin 

ENTRYPOINT ["java","-jar","/app/DAT/DAT.jar"]
