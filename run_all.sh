#!/bin/bash

mkdir -p results/{1_QC,2_adaptor_trimming,3_filtering,4_assembly,5_gene_annotation}
mkdir -p logs/{1_QC,2_adaptor_trimming,3_filtering,4_assembly,5_gene_annotation}
mkdir -p figures

bsub < bsub/1_QC.bsub
bsub < bsub/2_adaptor_trimming.bsub
bsub < bsub/3_filtering.bsub
bsub < bsub/4_assembly.bsub
bsub < bsub/5_gene_annotation.bsub

echo "done"