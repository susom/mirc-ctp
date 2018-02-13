#!/bin/bash

##
##  Example anonymization script. 
## 

# The new, anonymous patient ID:
PATIENTID="MRN1234"

# The new, anonymous, accession number:
ACCESSION="ACN1234"

# Anonymize dates by subtracting or adding this value, in days:
JITTER="-10"

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <SOURCE> <DESTINATION>"
	echo "	<SOURCE>	: A directory containing dicom instances to anonymize"
	echo "	<DESTINATION>	: Destination for the de-identified instances"
	exit 1
fi

java -jar DAT/DAT.jar -n 4 \
	-in $1 \
	-out $2 \
	-f stanford-filter.script \
	-da stanford-anonymizer.script \
	-pPATIENTID "$PATIENTID" \
	-pJITTER "$JITTER" \
	-pACCESSION "$ACCESSION" \ 
