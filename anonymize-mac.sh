#!/bin/bash

##
##  Example anonymization script for Mac which uses Docker for native ImageIO
##  Place DICOM with PHI in the 'DICOM' directory
##  and it will write anonymized DICOM to 'DICOM-ANON'
## 

# The new, anonymous patient ID:
PATIENTID="MRN1234"

# The new, anonymous, accession number:
ACCESSION="ACN1234"

# Anonymize dates by subtracting or adding this value, in days:
JITTER="-10"

# Helpful for debugging why pixel scrubbing is failing
#java -Dlog4j.configuration=file:log4j.xml -jar DAT/DAT.jar -n 4 \

docker run -v `pwd`:/tmp mirc-ctp -v -n 4 \
	-in /tmp/DICOM \
	-out /tmp/DICOM-ANON \
	-dec \
	-rec \
	-f /tmp/stanford-filter.script \
	-da /tmp/stanford-anonymizer.script \
	-dpa /tmp/stanford-scrubber.script \
	-pPATIENTID "$PATIENTID" \
	-pJITTER "$JITTER" \
	-pACCESSION "$ACCESSION" 
