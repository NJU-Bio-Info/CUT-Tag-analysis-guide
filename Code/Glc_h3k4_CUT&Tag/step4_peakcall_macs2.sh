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

mkdir -p $bedpath/peakcall/MACS2/narrowpeak
mkdir -p $bedpath/peakcall/MACS2/broadpeak

cat $sample | while read id
do
	macs2 callpeak -t $bampath/$id.rmdup.bam \
		--format BAM \
		--gsize hs \
		--keep-dup all \
		--outdir $bedpath/peakcall/MACS2/broadpeak \
		--name $id \
		--broad \
		--broad-cutoff 0.01
	macs2 callpeak -t $bampath/$id.rmdup.bam \
		--format BAM \
		--gsize hs \
		--keep-dup all \
		--outdir $bedpath/peakcall/MACS2/narrowpeak \
		--name $id \
		-q 0.01
done
