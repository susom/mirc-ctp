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

java -jar DAT/DAT.jar -n 4 \
	-in DICOM \
	-out DICOM-ANON \
	-f stanford-filter.script \
	-da stanford-anonymizer.script \
	-pPATIENTID "$PATIENTID" \
	-pJITTER "$JITTER" \
	-pACCESSION "$ACCESSION" \ 
