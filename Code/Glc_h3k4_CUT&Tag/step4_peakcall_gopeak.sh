#!/bin/bash

#BSUB -J peakcall
#BSUB -m fat01
#BSUB -q normal
#BSUB -n 10
#BSUB -e error.log
#BSUB -o out.log

bampath="/share/home/ShuiKM/Glc_CUT_Tag/step3_alignments"
sample="/share/home/ShuiKM/Glc_CUT_Tag/list.txt"
bedpath="/share/home/ShuiKM/Glc_CUT_Tag/step4_bedpe"

mkdir -p $bedpath/peakcall/GoPeak

cat $sample | while read id
do
	gopeaks -b $bampath/$id.rmdup.bam -p 0.01 -o $bedpath/peakcall/GoPeak/$id
done
