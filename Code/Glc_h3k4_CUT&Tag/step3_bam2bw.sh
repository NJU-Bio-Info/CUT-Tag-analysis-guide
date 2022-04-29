#!/bin/bash

#BSUB -J bam2bw
#BSUB -m fat01
#BSUB -q normal
#BSUB -n 10
#BSUB -e error.log
#BSUB -o out.log

bampath="/share/home/ShuiKM/Glc_CUT_Tag/step3_alignments"
sample="/share/home/ShuiKM/Glc_CUT_Tag/list.txt"

cat $sample | while read id
do
	samtools index -b -@ 10 $bampath/$id.rmdup.bam $bampath/$id.rmdup.bam.bai
	bamCoverage -b $bampath/$id.rmdup.bam -o $bampath/$id.rmdup.bw --extendReads --normalizeUsing RPKM -p 10
done
