#!/bin/bash

#BSUB -J align
#BSUB -m fat01
#BSUB -q normal
#BSUB -n 10
#BSUB -e error.log
#BSUB -o out.log

ref="/share/home/ShuiKM/reference/refdata-GRCh38-v38/bowtie2_index/hg38"
readpath="/share/home/ShuiKM/Glc_CUT_Tag/step2_filter_reads"
bampath="/share/home/ShuiKM/Glc_CUT_Tag/step3_alignments_ete"
sample="/share/home/ShuiKM/Glc_CUT_Tag/list.txt"

cat $sample | while read id
do
	bowtie2 -x $ref \
		-1 $readpath/$id\_R1\_val\_1.fq.gz \
		-2 $readpath/$id\_R2\_val\_2.fq.gz \
		--end-to-end \
		-I 10 \
		-X 700 \
		--no-mixed \
		--no-discordant \
		-p 10 \
		-S $bampath/tmp.sam &> $bampath/$id.align.txt

	samtools view -b -@ 10 -o $bampath/$id.bam $bampath/tmp.sam
	samtools view -b -@ 10 -q 20 -o $bampath/tmp.bam $bampath/$id.bam
	samtools sort -O BAM -@ 10 -o $bampath/$id.highquality.bam $bampath/tmp.bam

	rm $bampath/tmp.sam $bampath/tmp.bam

	picard MarkDuplicates I=$bampath/$id.highquality.bam \
		O=$bampath/$id.rmdup.bam \
		M=$bampath/$id.markdup.metrics.txt \
		REMOVE_DUPLICATES=true

done
