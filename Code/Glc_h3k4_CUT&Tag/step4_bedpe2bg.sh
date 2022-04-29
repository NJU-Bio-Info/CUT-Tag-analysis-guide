#!/bin/bash

#BSUB -J bedpe2bg
#BSUB -m fat01
#BSUB -q normal
#BSUB -n 10
#BSUB -e error.log
#BSUB -o out.log

bampath="/share/home/ShuiKM/Glc_CUT_Tag/step3_alignments"
sample="/share/home/ShuiKM/Glc_CUT_Tag/list.txt"
bedpath="/share/home/ShuiKM/Glc_CUT_Tag/step4_bedpe"
chrlength="/share/home/ShuiKM/reference/refdata-GRCh38-v38/chrsize.txt"

cat $sample | while read id
do
	cat $bedpath/$id.bedpe | cut -f 1,2,6 | sort -k1,1 -k2,2n -k3,3n > $bedpath/$id.fragment.bed
	bedtools genomecov -bg -i $bedpath/$id.fragment.bed -g $chrlength > $bedpath/$id.fragment.bg
done
