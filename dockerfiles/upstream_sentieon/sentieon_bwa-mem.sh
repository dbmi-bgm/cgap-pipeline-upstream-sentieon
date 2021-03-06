#!/bin/sh

# *******************************************
# Script to generate a raw bam file
# for a single sample with paired fastq files.
# *******************************************

## Command line arguments
# fastq
fastq_1=$1
fastq_2=$2

# reference data files
reference_fa=$3
reference_bwt=$4

## Other settings
nt=$(nproc) #number of threads to use in computation, set to number of cores in the server

## SymLink to reference files
fasta="reference.fasta"

# fasta
ln -s ${reference_fa}.fa reference.fasta
ln -s ${reference_fa}.fa.fai reference.fasta.fai
ln -s ${reference_fa}.dict reference.dict

# bwt
ln -s ${reference_bwt}.bwt reference.fasta.bwt
ln -s ${reference_bwt}.ann reference.fasta.ann
ln -s ${reference_bwt}.amb reference.fasta.amb
ln -s ${reference_bwt}.pac reference.fasta.pac
ln -s ${reference_bwt}.sa reference.fasta.sa
ln -s ${reference_bwt}.alt reference.fasta.alt


# ******************************************
# 1. Mapping reads with BWA-MEM.
# The results of this call are dependent on
# the number of threads used.
# To have number of threads independent results,
# add chunk size option -K 10000000.
# ******************************************
( sentieon bwa mem -t $nt -K 10000000 $fasta $fastq_1 $fastq_2 || exit 1 ) | samtools view -@ $nt -Shb - > raw.bam || exit 1

# ******************************************
# 2. Check bam integrity.
# ******************************************
py_script="
import sys, os

def check_EOF(filename):
    EOF_hex = b'\x1f\x8b\x08\x04\x00\x00\x00\x00\x00\xff\x06\x00\x42\x43\x02\x00\x1b\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00'
    size = os.path.getsize(filename)
    fb = open(filename, 'rb')
    fb.seek(size - 28)
    EOF = fb.read(28)
    fb.close()
    if EOF != EOF_hex:
        sys.stderr.write('EOF is missing\n')
        sys.exit(1)
    else:
        sys.stderr.write('EOF is present\n')

check_EOF('raw.bam')
"

python -c "$py_script" || exit 1
