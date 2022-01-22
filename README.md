## MIRC-CTP IRT Anonymization and Filter scripts

**DISCLAIMER: These anonymization scripts are only provided for testing the MIRC-CTP DICOM file output with your application. They are not intended to be used in a clinical or research setting, and should be considered incomplete test samples. DICOM files filtered through this program and associated scripts are not guaranteed to be free of PHI.**

This project contains baseline MIRC-CTP de-identification and filtering scripts used within Stanford IRT-RIT for anonymizing DICOM studies at scale. Use these scripts to verify that the Stanford IRT-RIT de-identification pipeline produces output acceptable for your study.

**Note**

These scripts are oriented towards removing PHI *and* images that are not useful for machine learning. Image types that are "DERIVED" or "SECONDARY" are excluded, as they are generally not useful for machine learning and are far more likely to contain pixel-PHI. If you modify
these scripts to include "SECONDARY" or "DERIVED" it is very likely the pixel scrubbing scripts will pass-through images that still contain pixel-PHI.

Included in this project is the MIRC-CTP command-line [DicomAnonymizerTool](https://github.com/johnperry/DicomAnonymizerTool) which allows de-identification of DICOM studies without installing the entire MIRC-CTP application. The Stanford IRT-RIT anonymization pipeline uses this same library. 

### DICOM anonymization scripts ###
* `stanford-anonymizer.script`: This file specifies which DICOM tags should be modified or removed. 
* `stanford-filter.script`: This file specifies which DICOM instances should be removed. Currently includes image types known to have pixel data with PHI, for example secondary derived screens (screenshots). 
* `stanford-scrubber.script`: MIRC-CTP standard pixel scrubbing definitions with additional rules added by Stanford.

The anonymization scripts are based off the [DICOM-PS3.15E-Basic](http://dicom.nema.org/dicom/2013/output/chtml/part15/PS3.15.html) profile with additional rules for tags known to contain PHI. All vendor-specific (eg. odd-numbered) tags are also removed.

A DICOM tag reference can be found [here](https://dicom.innolitics.com/ciods/cr-image/patient).

### Requirements

Since we run this tool on macOS, it requires docker (see below). Although we use macOS, community users have also reported running it successfully on Ubuntu Linux (but you must ensure you are using JDK v.8 and JRE v.8: on Ubuntu use `update-alternatives` to select your Java version).

### Installation

First ensure you have the [Oracle JDK v.8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) installed. 

Create a clone of this repository on your workstation:
```
git clone --recurse-submodules https://github.com/susom/mirc-ctp.git
```

If you do not have the `ant` program installed, install it with [HomeBrew](https://brew.sh/) (which will need to be installed if you haven't done so already)

```
$ brew install ant
```

Compile the included DicomAnonymizerTool by typing `ant` at the command prompt:

```
$ ant
Buildfile: /Users/jdoe/Projects/mirc-ctp/build.xml

clean:

init:
     [echo] Time now 15:56:40 PST
     [echo] ant.java.version = 1.8
    [mkdir] Created dir: /Users/jdoe/Projects/mirc-ctp/DicomAnonymizerTool/build
...

```

You should now have a directory called `DAT` which contains the `DicomAnonymizerTool`. You can try running it: 

```
$ java -jar DAT/DAT.jar
Usage: java -jar DAT {parameters}
where:
  -in {input} specifies the file or directory to be anonymized
       If {input} is a directory, all files in it and its subdirectories are processed.
  -out {output} specifies the file or directory in which to store the anonymized file or files.
...
```

Now the application needs to be placed in a Docker image. To create the image: 

`docker build -f Dockerfile --pull -t mirc-ctp .` 

You can now place some test DICOM studies in the directory `DICOM` and run the shell script which will anonymize the studies (all to the same anonymous MRN and Accession Number) and place them in `DICOM-ANON`

```
$ ./anonymize.sh
----
Thread: pool-1-thread-1: Anonymizing DICOM/1.2.840.4267.32.293501795892579834759834759834759834
   Anonymized file: DICOM-ANON/1.2.840.4267.32.10027221686667529588514012002002498656
----
Thread: pool-1-thread-2: Anonymizing DICOM/1.2.840.4267.32.093248509348509384509384509834059840
   Anonymized file: DICOM-ANON/1.2.840.4267.32.10134745174550989356450666756661275833
----
Elapsed time: 0.634
```

You can now open the DICOM files in `DICOM-ANON` to make sure they work with your intended application.

### Pixel filtering and MacOS 

In order to read DICOM encoded with the JPEG Lossless syntax, you need to have the Java Advanced Imaging ImageIO libraries.
Unfortunately, these are not available for Mac. To get around this limitation, this application executes within Docker. 
A Dockerfile is included in this distribution.
