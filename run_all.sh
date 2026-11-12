#!/bin/bash

# runs all bsub scripts from repo root
set -euo pipefail

SAMPLE_FILE=data/metadata/sample_names.txt
if [ ! -s "$SAMPLE_FILE" ]; then
    echo "Error: $SAMPLE_FILE is missing or empty" >&2
    exit 1
fi
N_SAMPLES=$(wc -w < "$SAMPLE_FILE" | tr -d ' ')

# create output directories
mkdir -p results/{1_QC,2_adaptor_trimming,3_filtering,4_assembly,5_gene_annotation}
mkdir -p logs/{1_QC,2_adaptor_trimming,3_filtering,4_assembly,5_gene_annotation}
mkdir -p figures

# Submit a job and print only its job ID
submit() {
    local out id
    out=$(bsub "$@")
    id=$(echo "$out" | sed -n 's/^Job <\([0-9]*\)>.*/\1/p')
    if [ -z "$id" ]; then
        echo "Error: submission failed: $out" >&2
        exit 1
    fi
    echo "$id"
}

# submit jobs one after each other
j1=$(submit < bsub/1_QC.bsub)
j2=$(submit -w "done($j1)" -ti < bsub/2_adaptor_trimming.bsub)
j3=$(submit -w "done($j2)" -ti < bsub/3_filtering.bsub)
j4=$(submit -J "flye[1-$N_SAMPLES]" -w "done($j3)" -ti < bsub/4_assembly.bsub)
j5=$(submit -w "done($j4)" -ti < bsub/5_gene_annotation.bsub)

# report on progress
echo "Submitted pipeline for $N_SAMPLES samples:"
echo "  1 QC          job $j1"
echo "  2 porechop    job $j2  (after $j1)"
echo "  3 filtlong    job $j3  (after $j2)"
echo "  4 flye array  job $j4  [1-$N_SAMPLES]  (after $j3)"
echo "  5 bakta       job $j5  (after all of $j4)"
echo "Monitor with: bjobs"
