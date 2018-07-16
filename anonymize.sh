#!/bin/bash

##
##  Example anonymization script. 
##  Place DICOM with PHI in the 'DICOM' directory
##  and it will write anonymized DICOM to 'DICOM-ANON'
## 

# The new, anonymous patient ID:
PATIENTID="MRN1234"

# The new, anonymous, accession number:
ACCESSION="ACN1234"

# Anonymize dates by subtracting or adding this value, in days:
JITTER="-10"

PLATFORM=`uname`
if [[ "$PLATFORM" == 'Darwin' ]]; then
	echo "Warning: MacOS supports a limited subset of DICOM transfer syntaxes due to lack of native Java ImageIO."
	echo "Pixel scrubbing will skip unsupported formats such as JPEG Lossless"
fi

# Helpful for debugging why pixel scrubbing is failing
#java -Dlog4j.configuration=file:log4j.xml -jar DAT/DAT.jar -n 4 \

java -jar DAT/DAT.jar -v -n 4 \
	-in DICOM \
	-out DICOM-ANON \
	-dec \
	-rec \
	-f stanford-filter.script \
	-da stanford-anonymizer.script \
	-dpa stanford-scrubber.script \
	-pPATIENTID "$PATIENTID" \
	-pJITTER "$JITTER" \
	-pACCESSION "$ACCESSION" 
