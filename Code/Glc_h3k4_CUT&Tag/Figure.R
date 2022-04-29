rm(list = ls())
library(ggplot2)
library(UpSetR)
library(ggsci)
library(scales)
library(patchwork)
library(dplyr)

if(!dir.exists(paths = 'Figure')){
  dir.create('Figure')
}

path = "/share/home/ShuiKM/Glc_CUT_Tag/step3_alignments/"
samples = c('glcH2B', 'H2B', 'H2BS112', 'S20220404113', 'S20220404114', 'S20220404115')
alignresult <- data.frame()

#sequence depth and alignment rate (high quality)
for(sample in samples){
  samplepath = paste0(path, sample, ".align.txt")
  
  align <- read.table(file = samplepath, header = F, fill = T)
  alignrate <- substr(align$V1[6], 1, nchar(as.character(align$V1[6]))-1)
  
  alignresult <- data.frame(sample = sample,
                            sequencedepth = align$V1[1] %>% as.character() %>% as.numeric(),
                            alignrate = alignrate %>% as.numeric()) %>% rbind(alignresult, .)
}
alignresult$sample = factor(alignresult$sample, levels = samples)
str(alignresult)

hq_map <- read.table(file = '/share/home/ShuiKM/Glc_CUT_Tag/Glc_His_in_R/highquality_seqdepth.txt',
                     sep = "\t",
                     header = F)
colnames(hq_map) <- c('sample', 'hq_depth')
alignresult <- left_join(alignresult, hq_map, by = 'sample')
alignresult$hq_pro <- alignresult$hq_depth/(2*alignresult$sequencedepth)

#duplicate rate
dupresult <- data.frame()
for(sample in samples){
  samplepath = paste0(path, sample, ".markdup.metrics.txt")
  
  dup <- read.table(file = samplepath, header = F, fill = T)
  duprate <- dup$V10[2] %>% as.numeric()
  
  dupresult <- data.frame(sample = sample,
                          duprate = duprate) %>% rbind(dupresult, .)
}

#figure1 sequence depth and align rate
colors = pal_npg()(6)
names(colors) = samples
(Figure1a <- ggplot(data = alignresult, mapping = aes(x = sample, y = sequencedepth*2)) + 
    geom_bar(fill = colors, stat = 'identity') + 
    scale_y_continuous(breaks = c(1e7, 4e7, 6e7, 8e7, 1e8), 
                       labels = c(1, 4, 6, 8, 10), 
                       expand = c(0, 0),
                       limits = c(0, 1.2e8)) +
    xlab(label = "") + 
    ylab(label = "Sequencing Depth(reads)/M") + 
    theme(axis.title = element_text(size = 12),
          axis.text.x = element_text(size = 10, hjust = 1, angle = 45, colour = 'black'),
          axis.text.y = element_text(size = 10, colour = 'black'),
          legend.position = 'none',
          panel.background = element_rect(fill = NA),
          panel.border = element_rect(fill = NA, colour = 'black', size = 1),
          axis.ticks.length.x = unit(0, units = 'cm')))
(Figure1b <- ggplot(data = alignresult, mapping = aes(x = sample, y = alignrate)) + 
    geom_bar(fill = colors, stat = 'identity') + 
    scale_y_continuous(breaks = c(25, 50, 75),
                       expand = c(0, 0),
                       limits = c(0, 100)) +
    xlab(label = "") + 
    ylab(label = "% Alignment Rate") + 
    theme(axis.title = element_text(size = 12),
          axis.text.x = element_text(size = 10, hjust = 1, angle = 45, colour = 'black'),
          axis.text.y = element_text(size = 10, colour = 'black'),
          legend.position = 'none',
          panel.background = element_rect(fill = NA),
          panel.border = element_rect(fill = NA, colour = 'black', size = 1),
          axis.ticks.length.x = unit(0, units = 'cm')))

(Figure1c <- ggplot(data = alignresult, mapping = aes(x = sample, y = hq_pro)) + 
    geom_bar(fill = colors, stat = 'identity') + 
    scale_y_continuous(breaks = c(.25, .50, .75),
                       expand = c(0, 0),
                       limits = c(0, 1)) +
    xlab(label = "") + 
    ylab(label = "% High Quality Alignment Rate") + 
    theme(axis.title = element_text(size = 12),
          axis.text.x = element_text(size = 10, hjust = 1, angle = 45, colour = 'black'),
          axis.text.y = element_text(size = 10, colour = 'black'),
          legend.position = 'none',
          panel.background = element_rect(fill = NA),
          panel.border = element_rect(fill = NA, colour = 'black', size = 1),
          axis.ticks.length.x = unit(0, units = 'cm')))

(Figure1d <- ggplot(data = dupresult, mapping = aes(x = sample, y = duprate)) + 
    geom_bar(fill = colors, stat = 'identity') + 
    scale_y_continuous(breaks = c(0.25, 0.50, 0.75, 1),
                       expand = c(0, 0),
                       limits = c(0, 1.1),
                       labels = c(25, 50, 75, 100)) +
    xlab(label = "") + 
    ylab(label = "% Duplicate Rate") + 
    theme(axis.title = element_text(size = 12),
          axis.text.x = element_text(size = 10, hjust = 1, angle = 45, colour = 'black'),
          axis.text.y = element_text(size = 10, colour = 'black'),
          legend.position = 'none',
          panel.background = element_rect(fill = NA),
          panel.border = element_rect(fill = NA, colour = 'black', size = 1),
          axis.ticks.length.x = unit(0, units = 'cm')))

(Figure1 <- Figure1a + 
    Figure1b + 
    Figure1c +
    Figure1d +
    plot_annotation(title = "Figure1", tag_levels = "A"))

ggsave(filename = 'Figure/Figure1.pdf', height = 6)


#fragment size
fraglens <- data.frame()
for(sample in samples){
  fraglenpath <- paste0(path, sample, '.fragmentsize.txt')
  fraglen <- read.table(file = fraglenpath, header = T, sep = "\t")
  
  fraglens <- data.frame(fragsize = fraglen$len, 
                         freq = fraglen$num,
                         proportion = fraglen$num/sum(fraglen$num), 
                         sample = rep(sample, nrow(fraglen))) %>% rbind(fraglens, .)
}
#figure2 the fragment size
(Figure2a <- ggplot(data = fraglens, aes(x = sample, y = fragsize, weight = proportion)) +
    geom_violin(aes(fill = sample)) + 
    geom_boxplot(fill = 'gray', width = 0.2, size = 0.5, outlier.alpha = 0.5) +
    xlab(label = "") + 
    ylab(label = "Fragment Size/bp") + 
    ggtitle(label = 'Figure2. The fragment size distribution.', ) + 
    theme(axis.title = element_text(size = 12),
          axis.text.x = element_text(size = 10, hjust = 1, angle = 45, colour = 'black'),
          axis.text.y = element_text(size = 10, colour = 'black'),
          legend.position = 'none',
          panel.background = element_rect(fill = NA),
          panel.border = element_rect(fill = NA, colour = 'black', size = 1),
          axis.ticks.length.x = unit(0, units = 'cm')))
ggsave(filename = 'Figure/Figure2.pdf', width = 6)
