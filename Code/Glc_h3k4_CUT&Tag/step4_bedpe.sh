#!/bin/bash

#BSUB -J bedpe
#BSUB -m fat01
#BSUB -q normal
#BSUB -n 10
#BSUB -e error.log
#BSUB -o out.log

bampath="/share/home/ShuiKM/Glc_CUT_Tag/step3_alignments"
sample="/share/home/ShuiKM/Glc_CUT_Tag/list.txt"
bedpath="/share/home/ShuiKM/Glc_CUT_Tag/step4_bedpe"

cat $sample | while read id
do
	bedtools bamtobed -bedpe -i <(samtools sort -n $bampath/$id.rmdup.bam) > $bedpath/$id.bedpe
done
