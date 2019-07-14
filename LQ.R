library(data.table)
library(dplyr)
df <- data.table(read.csv("BREmpData_0107.csv", header = TRUE))
#GeogIDs <- unique(df[, 1])
#IndIDs <- unique(df[, 2])
#Years <- unique(df[, 6])
#Employs <- df[, 7]


#setkey(df, GeogID, IndID, YEAR)



#df_sub = df[.(3, 3, 2001)]
#aa = sum(df_sub$Employment)

  

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
