#' Combine GSEA Results for All Samples
#'
#' This function takes the list of GSEA results for individual samples and combines them into a single data frame.
#'
#' @param gsea_results_list A list where each element is a GSEA result for a sample.
#' @return A data frame containing GSEA results for all samples, with an added `sample` column to identify the source of each result.
#' @examples
#' combined_results <- combine_gsea_results(gsea_results_list)
#' @export
combine_gsea_results <- function(gsea_results_list) {
  # Initialize an empty data frame
  gsea_final <- data.frame()

  # Iterate over the list of GSEA results and combine them
  for (sample in names(gsea_results_list)) {
    gsea_result <- gsea_results_list[[sample]]$gsea_results@result
    gsea_result$sample <- sample  # Add a column for the sample name

    gsea_final <- rbind(gsea_final, gsea_result)
  }

  return(gsea_final)
}
