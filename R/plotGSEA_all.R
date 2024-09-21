#' Generate a Dot Plot of GSEA Results
#'
#' This function generates a dot plot to visualize GSEA results for all samples, with a customizable color gradient.
#'
#' @param gsea_final A data frame containing the GSEA results for all samples.
#' @param colors A vector of three colors to use in the plot. Default is `c("lightskyblue", "grey", "firebrick2")`.
#' @return A ggplot object that can be plotted or saved.
#' @examples
#' pdf("GSEA_dotplot.pdf")
#' print(plotGSEA_all(gsea_final))
#' dev.off()
#' @export
plotGSEA_all <- function(gsea_final, colors = c("lightskyblue", "grey", "firebrick2")) {
  pathway_order <- c('MP1_Antigen processing and presentation',
                     'MP3_Cellular response to salt stress',
                     'MP6_Interferon response',
                     'MP8_Amide metabolism',
                     'MP10_Tissue regeneration',
                     'MP12_APC differentiation',
                     'MP2_Cell division',
                     'MP4_Post-transcription',
                     'MP5_DNA replication',
                     'MP7_Glycolysis and pyruvate metabolism',
                     'MP9_RNA metabolism',
                     'MP11_Translation')
  # Ensure the results are cleaned and ordered
  gsea_final <- gsea_final %>%
    mutate(ID = factor(ID, levels = pathway_order),
           log_padj_sign = -log10(p.adjust) * sign(NES))

  # Generate the dot plot
  p2 <- ggplot(gsea_final, aes(x = sample, y = ID)) +
    geom_point(aes(size = abs(NES), color = log_padj_sign)) +
    scale_size_continuous(range = c(2, 8)) +
    scale_color_gradient2(low = colors[1], mid = colors[2], high = colors[3], midpoint = 0) +
    theme_bw() +
    labs(x = NULL, y = NULL, size = "Enrichment\nScore Size", color = "-log10 adj_p-val * sign(NES)") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
          axis.text.y = element_text(size = 12))

  return(p2)
}

