library('resTMe')
library(clusterProfiler)
library(enrichplot)
library(ggplot2)
setwd('~/code_ava/6-resTMe_Rpackage/resTMe/tests/')
DEG <- read.csv('./test-degdata.csv')


#1-runGSEA_individual
gsea_results_list <- runGSEA_individual(DEG, "mouse", "p_val_adj")

pdf("p1.pdf", width = 5, height = 6)
# 使用 grid.arrange 来分页显示 plot
for (i in seq_along(gsea_results_list)) {
  print(gsea_results_list[[i]]$plot)  # print each plot
}
dev.off()


#2-combine_gsea_results
gsea_final<- combine_gsea_results(gsea_results_list)
write.csv(gsea_all,'gsea_final.csv',row.names = F)


#3-plotGSEA_all
pdf("GSEA_dotplot.pdf")
print(plotGSEA_all(gsea_final))
dev.off()

#4-mp_score_data
mp_score_results <- mp_score_data(gsea_final)
gsea_res_clean <- mp_score_results$gsea_res_clean
score_sum_by_cluster <- mp_score_results$score_sum_by_cluster
print(score_sum_by_cluster)


#5-mp_score_plot
pdf("mp_score.pdf",width = 3,height = 2.5)
print(mp_score_plot(score_sum_by_cluster))
dev.off()

