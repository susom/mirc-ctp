version development

import ../../wdl/anonymizeDicomImages.wdl

workflow AnonymizeDicomImagesTest {
  input {
    String folderIn
    String patientId
    String accessionNumber
    String jitter
    File filterScript
    File anonymizerScript
    File scrubScript
    String radioDockerImage
    String? outPattern

    call AnonymizeImages as anonymizeImages {
        input:
          folderIn = folderIn,
          outPattern = outPattern,
          patientId = patientId,
          accessionNumber = accessionNumber,
          jitter = jitter,
          filterScript = filterScript,
          anonymizerScript = anonymizerScript,
          scrubScript = scrubScript,
          radioDockerImage = radioDockerImage 
      }
    output {
      Directory anonDir = "DICOM_ANON"
    }
  }