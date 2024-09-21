#' Run GSEA on Individual Samples
#'
#' This function performs Gene Set Enrichment Analysis (GSEA) for each individual sample provided in the `DEG` data frame.
#' It returns a list of GSEA plots, one for each sample.
#'
#' @param DEG A data frame of differentially expressed genes (DEGs), with columns such as `sample`, `symbol`, `log2FC`, and a significance column.
#' @param org A character string indicating the organism, e.g., `"mouse"` or `"human"`. This will determine which gene sets are used for enrichment.
#' @param signif A character string representing the column name in the `DEG` data that contains the significance values (e.g., `"p_val"`,`"p_val_adj"`,`"non-selection"`).
#' @return A list of GSEA plots, one for each sample.
#' @examples
#' DEG <- read.csv('test-degdata.csv')
#' gsea_results <- runGSEA_individual(DEG, "mouse", "p_val_adj")
#' @export
runGSEA_individual <- function(DEG, org, signif) {
  # Determine the correct GMT file based on the organism
  gmt_file <- switch(org,
                     "mouse" = system.file("extdata", "mouseMP_all.gmt", package = "resTMe"),
                     "human" = system.file("extdata", "humanMP_all.gmt", package = "resTMe"))

  # Load gene sets based on the organism
  gene_sets <- read.gmt(gmt_file)

  # Initialize results list
  gsea_results_list <- list()

  samples <- unique(DEG$sample)

  if (length(samples) == 0) {
    print("No samples found in DEG data.")
    return(gsea_results_list)  # Return empty list if no samples
  }

  for (s in samples) {
    print(paste("Processing sample:", s))  # Print the sample name

    DEG1 <- DEG[DEG$sample == s,]
    DEG1 <- DEG1[!duplicated(DEG1$symbol),]

    # Check if DEG1 has data
    if (nrow(DEG1) == 0) {
      print(paste("No DEG data for sample:", s))
      next
    }

    if (signif == "p_val" || signif == "p_val_adj") {
      DEG1 = DEG1[DEG1[[signif]] < 0.05, ]
    } else if (signif == "non-selection") {
      # Do not filter based on significance
    }

    # Check if DEG1 has significant genes
    if (nrow(DEG1) == 0) {
      print(paste("No significant genes for sample:", s))
      next  # Skip this sample if no significant genes are found
    }

    DEG1 <- DEG1[order(DEG1$log2FC, decreasing = TRUE),]
    GSEAgeneList <- DEG1$log2FC
    names(GSEAgeneList) <- as.character(DEG1$symbol)

    # Check the gene list before running GSEA
    print(paste("Number of genes for GSEA in sample", s, ":", length(GSEAgeneList)))

    if (length(GSEAgeneList) == 0) {
      print(paste("No genes for GSEA in sample:", s))
      next
    }

    # Run GSEA
    gsea_results <- tryCatch({
      GSEA(geneList = GSEAgeneList, TERM2GENE = gene_sets)
    }, error = function(e) {
      print(paste("GSEA failed for sample:", s, "with error:", e))
      return(NULL)
    })

    # If GSEA failed, skip this sample
    if (is.null(gsea_results) || nrow(gsea_results@result) == 0) {
      print(paste("No GSEA results for sample:", s))
      next
    }

    # Generate the plot
    p1 <- gseaplot2(gsea_results, row.names(gsea_results@result), subplots = 1:2, base_size = 10)
    p1[[1]] <- p1[[1]] + ggtitle(s) + theme(plot.title = element_text(size = 10), legend.position = "top", legend.direction = "vertical")

    # Store both the GSEA results and the plot in the results list
    gsea_results_list[[s]] <- list(
      gsea_results = gsea_results,
      plot = p1
    )
  }

  return(gsea_results_list)  # Return the list of GSEA results and plots
}


