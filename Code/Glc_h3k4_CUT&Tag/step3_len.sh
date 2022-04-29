#!/bin/bash

bampath="/share/home/ShuiKM/Glc_CUT_Tag/step3_alignments"
sample="/share/home/ShuiKM/Glc_CUT_Tag/list.txt"

cat $sample | while read id
do
	samtools view $bampath/$id.rmdup.bam | awk -F'\t' 'function abs(x){return ((x < 0.0) ? -x : x)} {print abs($9)}' | sort | uniq -c | sort -k2,2n | awk -v OFS="\t" 'BEGIN{printf"len""\t""num""\n"}{print $2, $1/2}' > $bampath/$id.fragmentsize.txt
done
