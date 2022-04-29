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

mkdir -p $bedpath/peakcall/SEACR

cat $sample | while read id
do
	SEACR_1.3.sh $bedpath/$id.fragment.bg 0.01 non stringent $bedpath/peakcall/SEACR/$id
done
