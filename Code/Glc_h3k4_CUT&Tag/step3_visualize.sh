#!/bin/bash

#BSUB -J visualize
#BSUB -m fat01
#BSUB -q normal
#BSUB -n 10
#BSUB -e error.log
#BSUB -o out.log

bampath="/share/home/ShuiKM/Glc_CUT_Tag/step3_alignments"
sample="/share/home/ShuiKM/Glc_CUT_Tag/list.txt"
genes="/share/home/ShuiKM/reference/refdata-GRCh38-v38/gencode.v38.genes.bed"

computeMatrix scale-regions -R $genes \
	-S $bampath/S20220404113.rmdup.bw $bampath/S20220404114.rmdup.bw $bampath/S20220404115.rmdup.bw \
	-o $bampath/h3k4.gz \
	-a 5000 \
	-b 5000 \
	-m 10000 \
	-p 10 \
	--samplesLabel S20220404113 S20220404114 S20220404115

plotHeatmap -m $bampath/h3k4.gz -o h3k4.pdf
