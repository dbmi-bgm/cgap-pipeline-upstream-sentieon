#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

  - class: EnvVarRequirement
    envDef:
      -
        envName: SENTIEON_LICENSE
        envValue: LICENSEID

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/upstream_sentieon:VERSION

baseCommand: [sentieon, driver]

inputs:
  - id: input_gvcfs
    type:
      -
        items: File
        type: array
        inputBinding:
          prefix: -v
    inputBinding:
      position: 7
    secondaryFiles:
      - .tbi
    doc: input gvcf files

  - id: reference
    type: File
    inputBinding:
      position: 1
      prefix: -r
    secondaryFiles:
      - ^.dict
      - .fai
    doc: expect the path to the fa file

  - id: algo
    type: string
    default: "GVCFtyper"
    inputBinding:
      position: 2
      prefix: --algo
    doc: algorithm used

  - id: known-sites-snp
    type: File
    inputBinding:
      position: 3
      prefix: -d
    secondaryFiles:
      - .tbi
    doc: expect the path to the dbsnp vcf gz file

  - id: call_threshold
    type: int
    default: 10
    inputBinding:
      position: 4
      prefix: --call_conf
    doc: -stand-call-conf call threshold (must match emit_threshold)

  - id: emit_threshold
    type: int
    default: 10
    inputBinding:
      position: 5
      prefix: --emit_conf
    doc: -stand-call-conf emit threshold (must match call_threshold)

  - id: emit_mode
    type: string
    default: "variant"
    inputBinding:
      position: 6
      prefix: --emit_mode
    doc: --emit_mode with options of "variant", "confident", or "all"

  - id: outputfile
    default: "out.vcf.gz"
    type: string
    inputBinding:
      position: 8
    doc: output file name

outputs:
  - id: vcf
    type: File
    outputBinding:
      glob: $(inputs.outputfile)
    secondaryFiles:
      - .tbi

doc: |
  run sentieon GVCFtyper to jointly call multiple gvcf files
