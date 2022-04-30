library(ChIPseeker)
library(clusterProfiler)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(EnsDb.Hsapiens.v86)
library(dplyr)
library(ggplot2)

txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
edb <- EnsDb.Hsapiens.v86
seqlevelsStyle(edb) <- "UCSC"

peakpath = './peak'
samples = c('glcH2B', 'H2B', 'H2BS112', 'S20220404113', 'S20220404114', 'S20220404115')
peaks = c(paste0(samples, '.gopeaks.bed'),
          paste0(samples, '.seacrpeak.bed'),
          paste0(samples, '.macs2broadpeak.bed'),
          paste0(samples, '.macs2narrowpeak.bed'))

peakslist <- lapply(X = file.path(peakpath, peaks), FUN = function(peak){
  peakfile <- readPeakFile(peakfile = peak)
  return(peakfile)
})
names(peakslist) <- c(paste0(samples, '_gopeaks'),
                      paste0(samples, '_seacr'),
                      paste0(samples, '_macs2broadpeak'),
                      paste0(samples, '_macs2narrowpeak'))
invisible(gc())

#TSS region
promoter <- getPromoters(TxDb=txdb, upstream=3000, downstream=3000)
h3k4index <- which(grepl(names(peakslist), pattern = '^S2022'))
tagMatrixs <- lapply(X = h3k4index, FUN = function(index){
  tagMatrix <- getTagMatrix(peakslist[[index]], windows=promoter)
})
names(tagMatrixs) <- names(peakslist)[h3k4index]

##figure3
pdf(file = 'Figure/Figure3.pdf')
tagHeatmap(tagMatrix = tagMatrixs[[1]], 
           xlim = c(-3000, 3000),
           xlab = 'The distance from TSS/bp',
           title = 'The peak signal of S20220404113 around TSS (generate by GoPeak)')
dev.off()
##figure4
pdf(file = 'Figure/Figure4.pdf', height = 6, width = 10)
plotAvgProf(tagMatrix = tagMatrixs, xlim = c(-3000, 3000)) + 
  theme_bw() +
  guides(color=guide_legend(title = "Sample and Peak caller"))
dev.off()


##figure5
peaksanno <- lapply(peakslist[h3k4index], 
                    annotatePeak,
                    TxDb = edb)
names(peaksanno) <- factor(names(peaksanno),
                           levels = c(paste0('S20220404113', 
                                             c('_gopeaks', '_seacr', '_macs2broadpeak', '_macs2narrowpeak')),
                                      paste0('S20220404114', 
                                             c('_gopeaks', '_seacr', '_macs2broadpeak', '_macs2narrowpeak')),
                                      paste0('S20220404115', 
                                             c('_gopeaks', '_seacr', '_macs2broadpeak', '_macs2narrowpeak'))))
plotAnnoBar(peaksanno)
ggsave(filename = 'Figure/Figure5.pdf', width = 7, height = 5)

##figure6
plotDistToTSS(peaksanno,
              title = "Distribution of H3K4me3-binding loci relative to TSS")
ggsave(filename = 'Figure/Figure6.pdf', width = 7, height = 5)
