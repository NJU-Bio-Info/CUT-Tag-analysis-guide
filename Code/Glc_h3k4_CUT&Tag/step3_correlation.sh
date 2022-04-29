#!/bin/bash

#BSUB -J correlation
#BSUB -m fat01
#BSUB -q normal
#BSUB -n 10
#BSUB -e error.log
#BSUB -o out.log

bampath="/share/home/ShuiKM/Glc_CUT_Tag/step3_alignments"

#multiBigwigSummary bins -b $bampath/S20220404113.rmdup.bw $bampath/S20220404114.rmdup.bw $bampath/S20220404115.rmdup.bw \
#	-o $bampath/correlation/h3k4.npz \
#	--labels S20220404113 S20220404114 S20220404115 \
#	-bs 500 \
#	-p 10

plotCorrelation --corData $bampath/correlation/h3k4.npz \
	--corMethod pearson \
	--whatToPlot heatmap \
	--plotFile $bampath/correlation/h3k4.correlation.heatmap.pdf \
	--labels S20220404113 S20220404114 S20220404115 \
	--plotNumbers

plotCorrelation --corData $bampath/correlation/h3k4.npz \
	--corMethod pearson \
	--whatToPlot scatterplot \
	--plotFile $bampath/correlation/h3k4.correlation.scatterplot.pdf \
	--labels S20220404113 S20220404114 S20220404115 \
	--log1p
