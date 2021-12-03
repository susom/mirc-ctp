# Dockerfile for running CTP DicomAnonymizerTool with required dependencies
FROM openjdk:8

ENV HOME /app

WORKDIR /app
ADD DAT /app/DAT
ADD lib /app/lib
ADD DicomAnonymizerTool/source/files/log4j.properties /app

WORKDIR /usr/local/openjdk-8
RUN chmod +x /app/lib/*.bin
RUN echo yes | /app/lib/jai-1_1_3-lib-linux-amd64-jdk.bin
RUN echo yes | /app/lib/jai_imageio-1_1-lib-linux-amd64-jdk.bin 

WORKDIR /app
CMD ["java","-cp","/app/DAT/*","org.rsna.dicomanonymizertool.DicomAnonymizerTool"]
