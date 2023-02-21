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

Since we run this tool on MacOS, it requires docker (see below)

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

Update the included CTP and DicomAnonymizerTool modules, compile and build a docker image by typing `make` at the command prompt:

```
$ make
git submodule update --init --recursive
# This one brings the changes to local
git submodule update --remote --merge
cd CTP
git fetch
cd ..
cd DicomAnonymizerTool
git fetch
cd ..
make -C CTP
make[1]: Entering directory '<parent-folder>/mirc-ctp/CTP'
ant
Buildfile: <parent-folder>/mirc-ctp/CTP/build.xml

clean:
   [delete] Deleting directory <parent-folder>/mirc-ctp/CTP/build
   [delete] Deleting directory <parent-folder>/mirc-ctp/CTP/documentation
.
.
BUILD SUCCESSFUL
Total time: 14 seconds
make[1]: Leaving directory '<parent-folder>/mirc-ctp/CTP'
ant
Buildfile: /<parent-folder>/mirc-ctp/build.xml

clean:
   [delete] Deleting directory <parent-folder>/mirc-ctp/DicomAnonymizerTool/build
   [delete] Deleting directory <parent-folder>/mirc-ctp/DicomAnonymizerTool/documentation

init:
     [echo] Time now 17:20:35 UTC
.
.
BUILD SUCCESSFUL
Total time: 3 seconds
docker build -f Dockerfile --pull -t starr-radio-kit:1.0.0 .
Sending build context to Docker daemon  298.5MB
Step 1/12 : FROM openjdk:8
8: Pulling from library/openjdk
.
.
.
Successfully built 0cb2eecc701d
Successfully tagged starr-radio-kit:1.0.0
```

You can now place some test DICOM studies in the directory `DICOM` and run the shell script which will anonymize the studies (all to the same anonymous MRN and Accession Number) and place them in `DICOM-ANON`

```
$ ./anonymize.sh
----
Thread: pool-1-thread-1: Anonymizing /data/dicom/DICOM/1.3.12.2.1107.5.1.4.0.30000010041913435648400002130.dcm
   No matching signature found for pixel anonymization.
   The DICOMAnonymizer returned OK.
   Anonymized file: /data/dicom/DICOM-ANON/MRN1234-CT-CT ANGIO THORAX-20100409/1_Series 1-2.dcm
----
Elapsed time: 0.634
```

You can now open the DICOM files in `DICOM-ANON` to make sure they work with your intended application.

### Pixel filtering and MacOS 

In order to read DICOM encoded with the JPEG Lossless syntax, you need to have the Java Advanced Imaging ImageIO libraries.
Unfortunately, these are not available for Mac. To get around this limitation, this application executes within Docker. 
A Dockerfile is included in this distribution.
