library(data.table)
library(dplyr)
library(xlsx)
rm(list = ls())
df <- data.table(read.csv("BREmpData_0107.csv", header = TRUE))

df_reg_ind <- df[, sum(Employment), by = list(GeogID, IndID, YEAR)]
df_reg_total <- df[, sum(Employment), by = list(GeogID, YEAR)]
df_prov_ind <- df[, sum(Employment), by = list(IndID, YEAR)]
df_prov_total <- df[, sum(Employment), by = YEAR]
setnames(df_reg_ind, 'V1', 'e_i')
setnames(df_reg_total, 'V1', 'e_t')
setnames(df_prov_ind, 'V1', 'E_i')
setnames(df_prov_total, 'V1', 'E_t')
df1 <- full_join(x = df_reg_ind, y = df_reg_total)
df1$reg_ratio <- (df1$e_i/df1$e_t)
df2 <- full_join(x = df_prov_ind, y = df_prov_total)
df2$prov_ration <- (df2$E_i/df2$E_t)
df3 <- full_join(df1, df2)
df3$LQ <- (df3$reg_ratio/df3$prov_ration)
write.table(df3, "LQ.csv",  row.names = F, sep = ",")

lq_2001 <- subset(df3, df3[,3] == 2001)
lq_2007 <- subset(df3, df3[,3] == 2007)

x <- lq_2001[, c(1,2,10)]
y <- lq_2007[, c(1,2,10)]
setnames(x, 'LQ', 'LQ_2001')
setnames(y, 'LQ', 'LQ_2007')
lq_changed <- inner_join(x,y)
lq_changed$ratio <- (lq_changed$LQ_2007 - lq_changed$LQ_2001)/lq_changed$LQ_2001


geo_code <- distinct(df[, c(1, 4)])
lq_changed <- inner_join(lq_changed, geo_code)

ind_code <- distinct(df[, c(2, 5)])
lq_changed <- inner_join(lq_changed, ind_code)
write.table(lq_changed, "LQ_Changed.csv",  row.names = F, sep = ",")
