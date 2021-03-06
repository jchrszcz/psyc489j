
## ----setup,echo=FALSE----------------------------------------------------
library(knitr)
library(ggplot2)
library(MASS)
opts_chunk$set(cache=TRUE, fig.align='center')
options(digits = 2)


## ----anscombe,echo=FALSE,message=FALSE,warning=FALSE---------------------
invisible(lapply(c("reshape2", "ggplot2", "psych", "plyr"), require, character.only = TRUE))
data(anscombe)
a <- data.frame(x = melt(anscombe[1:4], value.name = "x")[2], y = melt(anscombe[5:8], value.name = "y")[2], id = factor(rep(1:4, each = nrow(anscombe))))
with(a, tapply(x, id, mean))
with(a, tapply(y, id, mean))
with(a, tapply(x, id, sd))
with(a, tapply(y, id, sd))
daply(a, .(id), function(val) cor(val$x, val$y))


## ----anscombe_plot,echo=FALSE,results='hide',message=FALSE,warning=FALSE,fig.align="center",fig.height=12,fig.width=12----
qplot(x, y, data = a, geom = "smooth", method = "lm", fullrange = TRUE, se = FALSE) + geom_point(size = 4) + facet_wrap(~id) + theme_bw(base_size = 24)


## ----bees,echo=FALSE,fig.width=18,fig.height=10,fig.align="center"-------
year <- c(2008, 2009, 2010, 2011)
bees <- c(20,19,5,4)
sunflower <- c(200, 199, 190, 189)
a <- data.frame(year = rep(year, 2), population = c(bees, sunflower), type = rep(c("bees", "flowers"), each = 4))
qplot(year, population, data = a, geom = "line", group = 1) + geom_point(size = 3) + facet_wrap(~type, scale = "free_y") + ggtitle("Population by year") + theme_bw(base_size = 24)


## ----bees_better,echo=FALSE,fig.height=9,fig.width=10,fig.align="center"----
qplot(year, population, data = a, geom = "line", group = type, color = type) + geom_point(size = 3) + ggtitle("Population by year") + theme_bw(base_size = 20)


## ----bees_better2,echo=FALSE,fig.height=9,fig.width=10,fig.align="center"----
b <- data.frame(year = rep(year, 2), population = c(bees/max(bees), sunflower/max(sunflower)), type = rep(c("bees", "flowers"), each = 4))
qplot(year, population, data = b, geom = "line", group = type, color = type) + geom_point(size = 3) + ggtitle("Percent of initial population by year") + theme_bw(base_size = 20)


## ----gog,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"--------
data(mpg)
qplot(displ, hwy, data = mpg) + theme_classic(base_size = 24) + ylab("") + xlab("")


## ----gog_2,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"------
qplot(displ, hwy, data = mpg, color = factor(cyl)) + theme_gray(base_size = 24)


## ----gog_3,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"------
qplot(displ, hwy, data = mpg, color = cyl) + theme_gray(base_size = 24)


## ----gog_4,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"------
qplot(displ, hwy, data = mpg, color = factor(cyl), geom = "line") + theme_gray(base_size = 24)


## ----gog_5,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"------
qplot(displ, hwy, data = mpg, color = factor(cyl), geom = "bar", position = "dodge", stat = "identity") + theme_gray(base_size = 24)


## ----gog_6,echo=FALSE,fig.height=10,fig.width=10,fig.align="center"------
qplot(displ, hwy, data = mpg, color = factor(cyl), geom = c("point", "smooth"), method = "lm") + theme_bw(base_size = 24)


## ----full_spec-----------------------------------------------------------
p <- ggplot(diamonds, aes(x = carat))
p <- p + layer(
  geom = "bar",
  geom_params = list(fill = "steelblue"),
  stat = "bin",
  stat_params = list(binwidth = .01)
)


## ----full_spec_viz,fig.align="center",fig.height=5,fig.width=8,echo=FALSE----
p


## ----full_spec_full,echo=FALSE,fig.height=10,fig.width=14,fig.align="center"----
p + theme_grey(base_size = 28)


## ----measles_setup,echo=FALSE,include=FALSE------------------------------
load("~/Dropbox/DAM lab/Math/Tasks/Data/mathreboot4/.RData")
library(gdata)
library(scales)
a <- drop.levels(a[!is.na(a$RT) & !is.na(a$Gain),])
a$center <- factor(a$Center)


## ----measles,fig.width=16------------------------------------------------
p <- ggplot(a, aes(center, RT))
p + geom_boxplot(outlier.size = 0) + geom_jitter(color = "firebrick", alpha = .05) +
  theme_bw(base_size = 28) + facet_wrap(~gain) + xlab("center (digits)") + ylab("rt (ms)") + ylim(c(0,6000))


## ----,cont_plot----------------------------------------------------------
p <- ggplot(a[a$Gain == 1,], aes(Center, RT))
p <- p + geom_jitter(alpha = .05) + geom_smooth(formula = y ~ log(x), method = "lm", se = FALSE, aes(group = Subj), color = alpha("blue", .3)) + ylim(c(0, 6000)) + geom_smooth(formula = y ~ log(x), method = "lm", color = "firebrick", se = FALSE, size = 1.2) + theme_bw(base_size = 24)


## ----print_cont,echo=FALSE,fig.height = 8--------------------------------
p


## ------------------------------------------------------------------------
load("~/Dropbox/mathALLthebio/neurons.RData")
qplot(value, data = melt(cells[!names(cells) %in% c("cell", "tree.count")])) + facet_wrap(~variable, scales = "free")


## ----,echo=FALSE---------------------------------------------------------
qplot(value, data = melt(cells[!names(cells) %in% c("cell", "tree.count")])) + facet_wrap(~variable, scales = "free") + theme_bw(base_size = 24)


## ------------------------------------------------------------------------
loc.box <- melt(cell.agg[!names(cell.agg) %in% c("neuron", "stain")], id.vars = "location")
ggplot(loc.box, aes(location, value)) + geom_boxplot() + facet_wrap(~variable, scales = "free_y") + facet_wrap(~variable, scales = "free_y") + theme_classic()


## ----,echo=FALSE,fig.width = 12------------------------------------------
ggplot(loc.box, aes(location, value)) + geom_boxplot() + facet_wrap(~variable, scales = "free_y") + facet_wrap(~variable, scales = "free_y") + theme_classic(base_size = 24)


## ----,echo=FALSE---------------------------------------------------------
sigma <- matrix(c(1,.6,.6,1),2,2)
mu <- c(0,0)
data <- mvrnorm(50000,mu,sigma)
data <- data.frame(X1=data[,1],X2=data[,2])
med <- median(data$X1)
data$is.responder <- factor(ifelse(data$X1>med,1,0))


x <- melt(data)

med <- median(data$X1)
#means
X1 <- mean(data$X1)
X2 <- mean(data$X2)
X1H <- mean(data[data$is.responder==1,]$X1)
X1L <- mean(data[data$is.responder==0,]$X1)
X2H <- mean(data[data$is.responder==1,]$X2)
X2L <- mean(data[data$is.responder==0,]$X2)

means <- data.frame(X1 = X1,
                    X2 = X2,
                    X1H = X1H,
                    X1L = X1L,
                    X2H = X2H,
                    X2L = X2L)
library(ellipse)

set.seed(101)
n <- 10000
x <- rnorm(n, mean=2)
y <- 1.5 + 0.4*x + rnorm(n)
df <- data.frame(x=x, y=y, group="A")
x <- rnorm(n, mean=2)
y <- 1.5*x + 0.4 + rnorm(n)
df <- rbind(df, data.frame(x=x, y=y, group="B"))

#calculating ellipses
df_ell <- data.frame()
for(g in levels(df$group)){
df_ell <- rbind(df_ell, cbind(as.data.frame(with(df[df$group==g,], ellipse(cor(x, y), 
                                         scale=c(sd(x),sd(y)), 
                                         centre=c(mean(x),mean(y))))),group=g))
}

dfell <- data.frame()

for(g in levels(df$group)){
df_ell <- rbind(df_ell, cbind(as.data.frame(with(df[df$group==g,], ellipse(cor(x, y), 
                                         scale=c(sd(x),sd(y)), 
                                         centre=c(mean(x),mean(y))))),group=g))
}


df_ell <- cbind(as.data.frame(with(data, ellipse(cor(X1, X2), 
                                         scale=c(sd(X1),sd(X2)), 
                                         centre=c(mean(X1),mean(X2))))))
df_ell$is.responder <- factor(ifelse(df_ell$x > 0, 1, 0))
library(grid)
p <- ggplot(data=data, aes(x=X1, y=X2)) + geom_polygon(data=df_ell, aes(x=x, y=y, fill=is.responder, alpha=.5), size=1, linetype=1, color="black") +
  theme_bw() + scale_fill_manual(values=c("firebrick","steelblue"), labels=c("Non-Responders","Responders")) + 
  geom_segment(aes(x = means$X1H, y = means$X2H, xend = means$X1H, yend = -2.45), arrow=arrow(length = unit(0.5,"cm")), color="black",guide=FALSE) +
  geom_segment(aes(x = means$X1H, y = means$X2H, xend = -2.45, yend = means$X2H), arrow=arrow(length = unit(0.5,"cm")), color="black",linetype=2,guide=FALSE) +
  geom_segment(aes(x = means$X1L, y = means$X2L, xend = means$X1L, yend = -2.45), arrow=arrow(length = unit(0.5,"cm")), color="black",guide=FALSE) +
  geom_segment(aes(x = means$X1L, y = means$X2L, xend = -2.45, yend = means$X2L), arrow=arrow(length = unit(0.5,"cm")), color="black",linetype=2,guide=FALSE) +
  geom_point(data=data.frame(x=c(means$X1H,means$X1L), y=c(means$X2H,means$X2L)), aes(x=x,y=y), size=5,guide=FALSE) +
  scale_x_continuous(breaks=c(means$X1L, 0, means$X1H), labels=c(expression(mu["Low"]),expression(mu[]),expression(mu["High"]))) +
  scale_y_continuous(breaks=c(means$X2L, 0, means$X2H), labels=c(expression(mu["Low"]),expression(mu[]),expression(mu["High"]))) +
  theme(axis.text.x=element_text(size=24)) +
  theme(axis.text.y=element_text(size=24)) +
  theme(legend.title=element_blank()) +
  #theme(axis.title.x=element_text(),axis.title.y=element_blank()) +
  ylab("Transfer Gains\n") + xlab("\nTraining Gains") + 
  theme(axis.title.x = element_text(size=24)) +
  theme(axis.title.y = element_text(size=24)) +
#  theme(legend.position="none") +
  theme(legend.text = element_text(size = 16)) +
  theme(
    plot.background = element_blank()
   ,panel.grid.major = element_blank()
   ,panel.grid.minor = element_blank()
   ,panel.border = element_blank()
   ,panel.background = element_blank()
  ) +
  theme(axis.line = element_line(color = 'black')) +
  coord_cartesian(xlim=c(-2.5,2.5), ylim=c(-2.5, 2.5))


## ----,echo=FALSE,fig.width=10--------------------------------------------
p

