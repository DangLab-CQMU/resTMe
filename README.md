
# resTMe

`resTMe` is an R package for performing Gene Set Enrichment Analysis (GSEA) and calculating MP scores with built-in mouse and human gene set files. It provides a streamlined workflow for processing differentially expressed genes (DEGs), running GSEA, and visualizing results.

## Installation

To install the package from a local source:

```r
# Install devtools if you haven't already
install.packages("devtools")

# Install the resTMe package
devtools::install_github("DangLab-CQMU/resTMe")
```

To ensure all dependencies are installed, including those from Bioconductor:

```r
# Install BiocManager if you haven't already
install.packages("BiocManager")

# Use BiocManager to install clusterProfiler, enrichplot, and ggplot2
BiocManager::install(c("clusterProfiler", "enrichplot", "ggplot2"))
```

## Built-in Data

The package includes built-in gene set files for mouse and human:
- `mouseMP_all.gmt`: Mouse gene sets
- `humanMP_all.gmt`: Human gene sets

These files are located in the `inst/extdata/` directory and can be accessed through the package.

## Functions

### 1. `runGSEA_individual`

Runs GSEA for each sample in the DEG data and generates a list of enrichment plots.

#### Usage:

```r
# Example data
DEG <- read.csv('test-degdata.csv')

# Run GSEA for each sample in the DEG data
gsea_results_list <- runGSEA_individual(DEG, org = "mouse", signif = "p_val_adj")
```

#### Parameters:
- `DEG`: A data frame of differentially expressed genes (DEGs).The input file must contain the following columns: `symbol` (representing gene symbols for human or mouse), `p_val` (p-value), `log2FC` (log2 fold change), `p_val_adj` (adjusted p-value), and `sample` (which can have multiple entries). Please note that the column names are fixed, and any discrepancies will result in an error. 
- `org`: Organism name, either `"mouse"` or `"human"`.
- `signif`: Column name indicating the significance values (e.g., `"p_val"`,`"p_val_adj"`,`"non-selection"`).

#### Return:
- A list of GSEA plots, one for each sample.

### 2. `combine_gsea_results`

Combines the GSEA results from individual samples into a single data frame.

#### Usage:

```r
# Combine GSEA results into a single data frame
gsea_final <- combine_gsea_results(gsea_results_list)
```

#### Parameters:
- `gsea_results_list`: A list where each element is a GSEA result for a sample.

#### Return:
- A data frame containing GSEA results for all samples.

### 3. `plotGSEA_all`

Generates a dot plot for visualizing GSEA results across multiple samples.

#### Usage:

```r
# Generate a dot plot for GSEA results
pdf("GSEA_dotplot.pdf")
print(plotGSEA_all(gsea_final))
dev.off()
```

#### Parameters:
- `gsea_final`: A data frame containing the combined GSEA results for all samples.
- `colors`: A vector of three colors for the plot gradient (default: `c("lightskyblue", "grey", "firebrick2")`).

#### Return:
- A `ggplot` object for the dot plot.

### 4. `mp_score_data`

Processes GSEA results to calculate MP scores for each sample.

#### Usage:

```r
# Calculate MP scores from GSEA results
mp_score_results <- mp_score_data(gsea_final)
gsea_res_clean <- mp_score_results$gsea_res_clean
score_sum_by_cluster <- mp_score_results$score_sum_by_cluster

# Save results to a CSV file
write.csv(gsea_res_clean, "gseaFinal_mpScore.csv", row.names = FALSE)
```

#### Parameters:
- `gsea_final`: A data frame containing the combined GSEA results for all samples.

#### Return:
- A list with two elements:
  - `gsea_res_clean`: Cleaned GSEA results with MP scores.
  - `score_sum_by_cluster`: Summarized MP scores by sample.

### 5. `mp_score_plot`

Generates a bar plot to visualize MP scores for each sample.

#### Usage:

```r
# Generate a bar plot for MP scores
pdf("mp_score.pdf")
print(mp_score_plot(score_sum_by_cluster))
dev.off()
```

#### Parameters:
- `score_sum_by_cluster`: A data frame summarizing MP scores for each sample.

#### Return:
- A `ggplot` object for the MP score bar plot.

## License

This package is licensed under the MIT License.

## Contact

For questions or issues, please contact [Ziruoyu Wang](ziruoyu.wang@gmail.com).
