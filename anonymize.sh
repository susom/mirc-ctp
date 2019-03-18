#!/bin/bash

##
##  Example anonymization script for Mac which uses Docker for native ImageIO
##  Place DICOM with PHI in the 'DICOM' directory
##  and it will write anonymized DICOM to 'DICOM-ANON'
## 

# The new, anonymous patient ID
PATIENTID="MRN1234"

# The new, anonymous, accession number:
ACCESSION="ACN1234"

# Anonymize dates by subtracting or adding this value, in days:
JITTER="-10"

OPTIND=1

while getopts "h?vd" opt; do
    case "$opt" in
    h|\?)
        echo "Usage: $0 -dv"
        echo "  -d  Wait for Java debugger to attach to port 8000"
        echo "  -v  Verbose output"
        exit 0
        ;;
    v)  VERBOSE="-Dlog4j.configuration=file:/app/log4j.xml"
        ;;
    d)  DEBUG="-agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=y"
        echo "Java debugging enabled"
        ;;
    esac
done

shift $((OPTIND-1))
[[ "${1:-}" = "--" ]] && shift

docker run --rm  -e JAVA_TOOL_OPTIONS=${DEBUG} \
    -p 8000:8000 -v ${PWD}:/data/dicom mirc-ctp java ${VERBOSE} -cp /app/DAT/* org.rsna.dicomanonymizertool.DicomAnonymizerTool -v -n 8 \
	-in /data/dicom/DICOM \
	-out /data/dicom/DICOM-ANON \
	-dec \
	-rec \
	-f /tmp/stanford-filter.script \
	-da /tmp/stanford-anonymizer.script \
	-dpa /tmp/stanford-scrubber.script \
	-pPATIENTID "$PATIENTID" \
	-pJITTER "$JITTER" \
	-pACCESSION "$ACCESSION"
