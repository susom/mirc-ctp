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

Since we run this tool on MacOS, it requires docker (see below) and the 'make' command from HomeBrew or MacOS command line tools: `xcode-select --install`

### Installation

Create a clone of this repository on your workstation:
```
git clone --recurse-submodules https://github.com/susom/mirc-ctp.git
```

Type `make` and the Docker image should build. 

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

