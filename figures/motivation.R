## ggrepel provides geoms for ggplot2 to repel overlapping text labels.
library(ggrepel)

############################################################################
## Different CNN
############################################################################

## Data source https://github.com/jcjohnson/cnn-benchmarks
lines <- "
network layers top1 top5 time reference
AlexNet 8 42.90 19.80 4.31 1
Inception-V1 22 - 10.07 11.50 2
VGG-16 16 27.00 8.80 41.23 3
VGG-19 19 27.30 9.00 48.09 3
ResNet-18 18 30.43 10.76 10.14 4
ResNet-34 34 26.73 8.74 16.71 4
ResNet-50 50 24.01 7.02 34.14 4
ResNet-101 101 22.44 6.21 52.18 4
ResNet-152 152 22.16 6.16 73.52 4"

con <- textConnection(lines)
data <- read.table(con, header=T)
close(con)

data$acc <- 100 - data$top5

ref.labels <- c("Krizhevsky12", "Szegedy15", "Simonyan15", "He2016", "He2016B")
p <- ggplot(data) +
  geom_point(aes(time, acc), size = 3, color = '#868686') +
#  academic_paper_theme() +
  theme(legend.position="none") +
  ylab("Top-5 Accuracy (%)") +
  xlab("Processing Time (ms)") +
  ylim(79, 95) +
  xlim(0, 80) +
  geom_label_repel(
      aes(time, acc, label = network),
      size = 3,
      segment.color = 'grey50')
p

pdf("motiv-functions.pdf", width=4, height=3.5)
p
dev.off()


############################################################################
## Different Params
############################################################################
lines <- "
resolution,time,acc,scale,label
720p,364.0456433,0.6545963491,1.02,720p 1.02
270p,36.50677894,0.01239889572,1.02,270p
360p,77.19406306,0.09118989443,1.02,360p
540p,196.5878121,0.5572562933,1.02,540p
720p,364.0456433,0.6545963491,1.02,
900p,581.5045329,0.6593763597,1.02,900p,
1080p,847.0200994,0.6443425163,1.02,1080p
720p,555.5440736,0.6269021816,1.01,1.01
720p,269.6397796,0.656913314,1.03,1.03
720p,203.9213308,0.6377737226,1.04,1.04
720p,149.0320685,0.5852403335,1.06,1.06
720p,116.4818367,0.5346053525,1.08,1.08
720p,100.9725877,0.5116194758,1.1,1.1"

con <- textConnection(lines)
data <- read.csv(con, header=T)
close(con)

data$Parameter <- "change resolution, scale=1.02"
data[data$resolution == "720p",]$Parameter <- "change scale, resolution=720p"
data[1,]$Parameter <- "change resolution, scale=1.02"  # change back one of them

p <- ggplot(data) +
  geom_line(aes(time, acc, color=Parameter),
            linetype="dashed", size=1.2) +
  geom_point(aes(time, acc), size = 3, color = '#868686') +
  geom_label_repel(
      aes(time, acc, label = label), size = 3, nudge_y = 0.01) +
  academic_paper_theme +
  scale_color_jco() +
  theme(legend.position=c(0.6, 0.15)) +
  ylab("F1 Score") +
  xlab("Processing Time (ms)") +
  theme(legend.title=element_text(size=10)) +
  theme(legend.text=element_text(size=10)) +
  ylim(0, 0.75)
p

pdf("motiv-params.pdf", width=4, height=3.5)
p
dev.off()

############################################################################
## Different Platforms
############################################################################
lines <- "
resolution time acc scale Platform
720p 291 0.6439355588 1.02 P1
720p 364 0.6545963491 1.02 P2
720p 844 0.6544772342 1.02 P3
1080p 698 0.6403466809 1.02 P1
1080p 847 0.6443425163 1.02 P2
1080p 1858 0.6413597096 1.02 P3
720p 175 0.6351016684 1.04 P1
720p 204 0.6377737226 1.04 P2
720p 392 0.6388164755 1.04 P3"

con <- textConnection(lines)
data <- read.table(con, header=T)
close(con)

data$x <- factor(paste(data$resolution, data$scale, sep=', '),
                 levels=c("720p, 1.04", "720p, 1.02", "1080p, 1.02"))

p <- ggplot(data, aes(x=x, y=time, fill=Platform)) +
    geom_bar(stat="identity", position=position_dodge(width = 0.7), width = 0.6) +
    geom_text(aes(label = time),
              position = position_dodge(width = 0.7), vjust=-0.5, size = 3) +
    academic_paper_theme() +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 2100)) +
    theme(legend.position=c(0.37,0.92), legend.direction="horizontal") +
    scale_fill_jco() +
    xlab("Parameters") +
    ylab("Processing Times (ms)")
p

pdf("motiv-platforms.pdf", width=4, height=3.5)
p
dev.off()
