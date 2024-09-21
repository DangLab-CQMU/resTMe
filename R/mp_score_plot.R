#' Generate an MP Score Bar Plot
#'
#' This function generates a bar plot to visualize the MP scores calculated for each sample.
#'
#' @param score_sum_by_cluster A data frame summarizing the MP scores for each sample.
#' @return A ggplot object that can be plotted or saved.
#' @examples
#' pdf("mp_score.pdf")
#' print(mp_score_plot(score_sum_by_cluster))
#' dev.off()
#' @export
mp_score_plot <- function(score_sum_by_cluster) {

  # Generate the MP score bar plot
  if (length(unique(score_sum_by_cluster$sample)) > 1) {
    total_scores <- score_sum_by_cluster$total_score

    # 判断所有的 total_score 是否都大于 0
    if (all(total_scores > 0)) {
      y_limits <- c(0, max(total_scores) + 0.5)
      # 判断所有的 total_score 是否都小于 0
    } else if (all(total_scores < 0)) {
      y_limits <- c(min(total_scores) - 0.5, 0)
      # 其他情况
    } else {
      y_limits <- c(min(total_scores) - 0.5, max(total_scores) + 0.5)
    }

    custom_colors <- c("lightskyblue", "white", "firebrick2")

    custom_values <- c(min(total_scores), median(total_scores), max(total_scores))

    p3 <- ggplot(score_sum_by_cluster, aes(x = sample, y = total_score, fill = total_score)) +
      geom_bar(stat = "identity") +
      scale_fill_gradientn(colors = custom_colors, values = scales::rescale(custom_values, to = c(0, 1))) +
      theme_test() +
      labs(title = "MP score",
           x = "",
           y = "MP Score") +
      geom_text(aes(label = round(total_score, 2)),
                vjust = ifelse(total_scores >= 0, -0.3, 1.3),  # 调整文本位置
                size = 3,
                color = "black") +
      scale_y_continuous(limits = y_limits)
  } else {
    # 单样本的逻辑可以保持原样
    total_score <- score_sum_by_cluster$total_score
    custom_color <- ifelse(total_score > 0, "firebrick2", "lightskyblue")

    p3 <- ggplot(score_sum_by_cluster, aes(x = sample, y = total_score)) +
      geom_bar(stat = "identity", fill = custom_color) +  # 使用固定颜色
      theme_test() +
      labs(title = "MP score",
           x = "",
           y = "MP Score") +
      geom_text(aes(label = round(total_score, 2)),
                vjust = ifelse(total_score >= 0, -0.3, 1.3),  # 调整文本位置
                size = 3,
                color = "black") +
      scale_y_continuous(limits = y_limits)
  }

  return(p3)
}
