% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotGSEA_all.R
\name{plotGSEA_all}
\alias{plotGSEA_all}
\title{Generate a Dot Plot of GSEA Results}
\usage{
plotGSEA_all(gsea_final, colors = c("lightskyblue", "grey", "firebrick2"))
}
\arguments{
\item{gsea_final}{A data frame containing the GSEA results for all samples.}

\item{colors}{A vector of three colors to use in the plot. Default is \code{c("lightskyblue", "grey", "firebrick2")}.}
}
\value{
A ggplot object that can be plotted or saved.
}
\description{
This function generates a dot plot to visualize GSEA results for all samples, with a customizable color gradient.
}
\examples{
pdf("GSEA_dotplot.pdf")
print(plotGSEA_all(gsea_final))
dev.off()
}
