library(plyr)

library(ggplot2)

ddd <- read.csv("double-1nodecn128.mem", header=F, sep="\t")
sss <- read.csv("single-1nodecn128.mem", header=F,sep="\t")
#qs <- read.csv("qsingle-64node.mem", header=F,sep="\t")

names(ddd) <- c("memtotal", "memfree", "memavail")
names(sss) <- c("memtotal", "memfree", "memavail")
#names(qs) <- c("memtotal", "memfree", "memavail")

head(ddd)

ddd$Variant <- "double"
sss$Variant <- "single"
#qs$Variant <- "Q single"

ddd$mem<-  ddd$memtotal-ddd$memavail
sss$mem<-  sss$memtotal-sss$memavail
#qs$mem<-  qs$memtotal-qs$memavail

ddd$time <- seq(0.5, nrow(ddd)/2, by=0.5)
sss$time <- seq(0.5, nrow(sss)/2, by=0.5)
#qs$time <- seq(0.5, nrow(qs)/2, by=0.5)

#memdf <- rbind(ddd[64:6400,], sss[64:400,], qs[4:400,])
#memdf <- rbind(ddd, sss, qs)
memdf <- rbind(ddd, sss)


memplot <- ggplot(data=memdf,aes(x=time, y = mem, color=Variant))+
geom_line()+
#geom_smooth()+
#geom_line(data=df1, aes(y=dbl, color="double"))+
#geom_line(data=df2, aes(y=single, color="single"))+
ggtitle("Memory use single-67249 and double-33024 for 1 node")+
ylab("memory (kB)")+
xlab("time(sec)")

ggsave("memplot-budget-s67249-d33024.pdf", memplot)

a <- max(ddd$mem)
b<- max(sss$mem)
#c<-  max(qs$mem)
aggmem<- aggregate(mem~Variant, memdf, max)

barmem <- ggplot(data=memdf,aes(x=Variant, y=mem, fill=Variant))+
geom_bar(stat="summary", fun.y="max")+
#geom_line()+
#geom_smooth()+
#geom_line(data=df1, aes(y=dbl, color="double"))+
#geom_line(data=df2, aes(y=single, color="single"))+
ggtitle("Memory use single-67249 and double-33024 for 1 node")+
ylab("Maximum main memory use(kB)")#+xlab("time(sec)")

ggsave("barmemplot-budget-s67249-d33024.pdf", barmem)

print("ddd")
print(a)
print("sss")
print(b)
#print("qs")
#print(c)




