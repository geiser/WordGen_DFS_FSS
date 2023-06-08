## ----setup, include=FALSE-------------------------------------------------------------------------------------------------------------------------
## Install and Load Packages
if (!'remotes' %in% rownames(installed.packages())) install.packages('remotes')
if (!"rshinystatistics" %in% rownames(installed.packages())) {
  remotes::install_github("geiser/rshinystatistics")
} else if (packageVersion("rshinystatistics") < "0.0.0.9800") {
  remotes::install_github("geiser/rshinystatistics")
}

wants <- c('ggplot2','ggpubr','rshinystatistics','utils')
has <- wants %in% rownames(installed.packages())
if (any(!has)) install.packages(wants[!has])

library(utils)
library(ggpubr)
library(ggplot2)
library(rshinystatistics)




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
dat <- readxl::read_excel("../data/Atv_Debates.xlsx", sheet = "data")
dat$grupo <- factor(dat$grupo, levels = c("Experimental","Controle"))
dat$zona <- factor(dat$zona, levels = c("Urbana","Rural"))

sdat <- dat[!is.na(dat$zona),]


## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(df <- get.descriptives(dat, "fss", c("grupo","genero","zona"), include.global = F, symmetry.test = F))




## ---- echo=FALSE, dpi=300, fig.width=12, fig.height=8---------------------------------------------------------------------------------------------
car::Boxplot(`fss` ~ `grupo`*`genero`*`zona`, data = dat, id = list(n = Inf))


## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(df <- get.descriptives(dat, "fss", c("grupo","genero"), include.global = F, symmetry.test = T))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(df <- get.descriptives(dat, "fss", c("grupo","zona"), include.global = F, symmetry.test = T))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(df <- rstatix::identify_outliers(group_by(dat[,c("id_estudante","grupo","genero","zona","fss","dfs")],grupo,genero,zona),"fss"))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(df <- normality.test.by.residual(dat, "fss", c("grupo","genero","zona"), c(), "dfs"))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(df <- get.descriptives(dat, "fss", c("grupo","genero","zona"), include.global = F, normality.test = T))




## ---- dpi=300, fig.width=12-----------------------------------------------------------------------------------------------------------------------
ggscatter(dat, x="dfs", y="fss", facet.by=c("grupo","genero"), short.panel.labs = F) + stat_smooth(method = "lm", span = 0.9)


## ---- dpi=300, fig.width=12-----------------------------------------------------------------------------------------------------------------------
ggscatter(dat, x="dfs", y="fss", facet.by=c("grupo","zona"), short.panel.labs = F) + stat_smooth(method = "lm", span = 0.9)


## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(df <- homogeneity.test(sdat, "fss", c("grupo","genero","zona"), c(), "dfs"))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(df <- homogeneity.test(dat, "fss", c("grupo","genero"), c(), "dfs"))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
aov1 <- ancova.test(dat, "fss", c("grupo","genero"), "dfs", 2, "ges")$fss
(df1 <- round.pval(aov1))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
aov2 <- ancova.test(sdat, "fss", c("grupo","genero","zona"), "dfs", 2, "ges")$fss
(df2 <- round.pval(aov2))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
pwc.grupo <- ancova.pwc(dat, "fss", "grupo", "dfs", p.adjust.method = "bonferroni")
(pdf.grupo <- get.ancova.pwc.table(pwc.grupo, only.sig = F))




## ---- dpi=300, fig.width=7, fig.height=7----------------------------------------------------------------------------------------------------------
oneWayAncovaPlots(dat, "fss", "grupo", aov1, pwc.grupo$fss, addParam = c("jitter"), font.label.size=14, step.increase=0.25, p.label="p.adj", subtitle = 2)$grupo + ggplot2::scale_color_manual(values=c("#00AA00","#FFBA00"))


## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
pwc.genero <- ancova.pwc(dat, "fss", c("genero"), "dfs", p.adjust.method = "bonferroni")
(pdf.genero <- get.ancova.pwc.table(pwc.genero, only.sig = F))




## ---- dpi=300, fig.width=7, fig.height=7----------------------------------------------------------------------------------------------------------
oneWayAncovaPlots(dat, "fss", "genero", aov1, pwc.genero$fss, addParam = c("jitter"), font.label.size=14, step.increase=0.25, p.label="p.adj", subtitle = 3)$genero + ggplot2::scale_color_manual(labels=c("female","male"), values=c("#FF007F","#4D4DFF")) + scale_x_discrete("gender")


## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
pwc.zona <- ancova.pwc(sdat, "fss", c("zona"), "dfs", p.adjust.method = "bonferroni")
(pdf.zona <- get.ancova.pwc.table(pwc.zona, only.sig = F))




## ---- dpi=300, fig.width=7, fig.height=7----------------------------------------------------------------------------------------------------------
oneWayAncovaPlots(sdat, "fss", "zona", aov2, pwc.zona$fss, addParam = c("jitter"), font.label.size=14, step.increase=0.25, p.label="p.adj", subtitle = 4)$zona +  ggplot2::scale_color_manual(values=c("#AA00FF","#00CCCC"))


## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
pwc.grupo_genero <- ancova.pwc(dat, "fss", c("grupo","genero"), "dfs", p.adjust.method = "bonferroni")
(pdf.grupo_genero <- get.ancova.pwc.table(pwc.grupo_genero, only.sig = F))




## -------------------------------------------------------------------------------------------------------------------------------------------------
plots <- twoWayAncovaPlots(dat, "fss", c("grupo","genero"), aov1, pwc.grupo_genero$fss, addParam = c("jitter"), font.label.size=14, step.increase=0.25, p.label="p.adj", subtitle = 4)


## ---- dpi=300, fig.width=7, fig.height=7----------------------------------------------------------------------------------------------------------
plots$grupo + ggplot2::scale_color_manual(labels=c("female","male"), values=c("#FF007F","#4D4DFF")) + scale_x_discrete("gender")


## ---- dpi=300, fig.width=7, fig.height=7----------------------------------------------------------------------------------------------------------
plots$genero + ggplot2::scale_color_manual(values=c("#00AA00","#FFBA00"))


## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
pwc.grupo_zona <- ancova.pwc(sdat, "fss", c("grupo","zona"), "dfs", p.adjust.method = "bonferroni")
(pdf.grupo_zona <- get.ancova.pwc.table(pwc.grupo_zona, only.sig = F))




## -------------------------------------------------------------------------------------------------------------------------------------------------
plots <- twoWayAncovaPlots(sdat, "fss", c("grupo","zona"), aov2, pwc.grupo_zona$fss, addParam = c("jitter"), font.label.size=14, step.increase=0.25, p.label="p.adj", subtitle = 6)


## ---- dpi=300, fig.width=7, fig.height=7----------------------------------------------------------------------------------------------------------
plots$grupo + ggplot2::scale_color_manual(values=c("#AA00FF","#00CCCC"))


## ---- dpi=300, fig.width=7, fig.height=7----------------------------------------------------------------------------------------------------------
plots$zona + ggplot2::scale_color_manual(values=c("#00AA00","#FFBA00"))


## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
pwc.genero_zona <- ancova.pwc(sdat, "fss", c("genero","zona"), "dfs", p.adjust.method = "bonferroni")
(pdf.genero_zona <- get.ancova.pwc.table(pwc.genero_zona, only.sig = F))




## -------------------------------------------------------------------------------------------------------------------------------------------------
plots <- twoWayAncovaPlots(sdat, "fss", c("genero","zona"), aov2, pwc.genero_zona$fss, addParam = c("jitter"), font.label.size=14, step.increase=0.25, p.label="p.adj", subtitle = 7)


## ---- dpi=300, fig.width=7, fig.height=7----------------------------------------------------------------------------------------------------------
plots$genero + ggplot2::scale_color_manual(values=c("#AA00FF","#00CCCC"))


## ---- dpi=300, fig.width=7, fig.height=7----------------------------------------------------------------------------------------------------------
plots$zona + ggplot2::scale_color_manual(labels=c("female","male"), values=c("#FF007F","#4D4DFF")) + scale_x_discrete("gender")


## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(apa <- get.ancova.emmeans.with.ds(pwc.grupo, dat, "fss", "grupo", "apa-format", covar = "dfs"))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(apa <- get.ancova.emmeans.with.ds(pwc.genero, dat, "fss", "genero", "apa-format", covar = "dfs"))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(apa <- get.ancova.emmeans.with.ds(pwc.grupo_genero, dat, "fss", c("grupo","genero"), "apa-format", covar = "dfs"))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(apa <- get.ancova.emmeans.with.ds(pwc.zona, sdat, "fss", "zona", "apa-format", covar = "dfs"))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(apa <- get.ancova.emmeans.with.ds(pwc.grupo_zona, sdat, "fss", c("grupo","zona"), "apa-format", covar = "dfs"))




## ---- include=FALSE-------------------------------------------------------------------------------------------------------------------------------
(apa <- get.ancova.emmeans.with.ds(pwc.genero_zona, sdat, "fss", c("genero","zona"), "apa-format", covar = "dfs"))

