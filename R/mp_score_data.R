#' Process GSEA Results and Calculate MP Scores
#'
#' This function processes the GSEA results and calculates MP scores for each sample.
#' It returns both the cleaned GSEA results and the summarized MP scores by sample.
#'
#' @param gsea_final A data frame containing the combined GSEA results for all samples.
#' @return A list with two elements: `gsea_res_clean` (the cleaned GSEA results) and `score_sum_by_cluster` (a summary of MP scores by sample).
#' @examples
#' mp_score_results <- mp_score_data(gsea_final)
#' gsea_res_clean <- mp_score_results$gsea_res_clean
#' score_sum_by_cluster <- mp_score_results$score_sum_by_cluster
#' write.csv(gsea_res_clean, "gseaFinal_mpScore.csv", row.names = FALSE)
#' @export
mp_score_data <- function(gsea_final) {
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
  mpp <- pathway_order[1:6]##MP cluster2 positive
  # Clean up the GSEA results and calculate MP score
  gsea_res_clean <- gsea_final %>%
    mutate(leadingEdge = sapply(leading_edge, toString)) %>%
    mutate(score = ifelse(
      p.adjust < 0.05 & ID %in% mpp,
      NES,
      ifelse(p.adjust < 0.05 & !(ID %in% mpp), -NES * 0.5, 0)
    ))

  # Summarize scores by sample
  score_sum_by_cluster <- gsea_res_clean %>%
    group_by(sample) %>%
    dplyr::summarize(total_score = sum(score, na.rm = TRUE))

  # Return both cleaned GSEA results and summarized scores
  list(gsea_res_clean = gsea_res_clean, score_sum_by_cluster = score_sum_by_cluster)
}

