#!/bin/bash

#BSUB -J fastqc
#BSUB -n 5
#BSUB -q normal
#BSUB -e error.log
#BSUB -o out.log
#BSUB -m fat01

raw="/share/home/ShuiKM/Glc_CUT_Tag/RawData/Data"
dir="/share/home/ShuiKM/Glc_CUT_Tag/step1_fastqc"

ls $raw | while read id
do
	fastqc $raw/$id/* -o $dir
done
