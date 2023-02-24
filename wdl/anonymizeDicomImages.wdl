version development

task AnonymizeImages {
  parameter_meta {
    folderIn : { description: "Folder with images to be anonymized" }
    outPattern : { description: "" }
    patientId : { description: "Anonymized Patient Id" }
    accessionNumber : { description: "Anonymized accession number" }
    jitter : { description: "Jitter to be used during anonymization" }
    filterScript : { description: "" }
    anonymizerScript : { description: "" }
    scrubScript : { description: "" }
    radioDockerImage : { description: "DicomAnonymizerTool docker image e.g. - starr-radio-kit:latest" }
  }
  
  input {
    Directory folderIn
    String? outPattern
    String patientId
    String accessionNumber
    String jitter
    File filterScript
    File anonymizerScript
    File scrubScript
    String radioDockerImage = "starr-radio-kit:latest"
    Int cpu = 1
    String memory = "128 MB"
  }

  command <<<
    mkdir DICOM_ANON
    PATH="${PATH}:/usr/local/openjdk-8/bin"
    java -Dlog4j.configuration=/app/log4j.properties -classpath /app/DAT/DAT.jar org.rsna.dicomanonymizertool.DicomAnonymizerTool \
      -in '~{folderIn}' \
      -out DICOM_ANON \
      -outPattern '~{outPattern}' \
      -dec \
      -rec \
      -f '~{filterScript}'  \
      -da '~{anonymizerScript}'  \
      -dpa '~{scrubScript}' \
      -pPATIENTID '~{patientId}' \
      -pJITTER '~{jitter}'  \
      -pACCESSION '~{accessionNumber}' 
  >>>

  output {
    Directory anonDir = "DICOM_ANON"
  }

  runtime {
    docker: radioDockerImage
    cpu: cpu
    memory: memory
  }
}