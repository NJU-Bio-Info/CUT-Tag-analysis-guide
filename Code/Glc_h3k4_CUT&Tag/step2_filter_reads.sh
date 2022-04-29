#!/bin/bash

#BSUB -J trim_galore
#BSUB -n 4
#BSUB -q normal
#BSUB -e error.log
#BSUB -o out.log
#BSUB -m fat01

raw="/share/home/ShuiKM/Glc_CUT_Tag/RawData/Data"
cd step2\_filter\_reads
mkdir fastqc
cd ..

ls $raw | while read id
do
	trim_galore --paired $raw/$id/$id\_R1.fq.gz $raw/$id/$id\_R2.fq.gz \
		--fastqc \
		--fastqc_args "-o ./step2\_filter\_reads/fastqc" \
		--nextera \
		--gzip \
		--clip_R1 15 \
		--clip_R2 15 \
		--output_dir step2\_filter\_reads \
		-j 4
done
