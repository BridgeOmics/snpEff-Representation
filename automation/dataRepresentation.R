rm(list = ls())
suppressMessages({
  library(ggplot2)
  library(ComplexHeatmap)
})

## Dnyamic output dir and snpEff folder
#list_of_data_dir = c("/path/to/output/folder/snpEff_output/output_dir/sample1", "/path/to/output/folder/snpEff_output/output_dir/sample2")
list_of_data_dir = c("test/")
# Colors for the plot
cols = "#572685" ##42738f

for (data_dir in list_of_data_dir) {
	for(f_name in list.files(path = data_dir, pattern = ".csv")) {
	  o_name = gsub(pattern = ".csv", "", f_name)
	  df = read.csv(paste0(data_dir, f_name), check.names = F)
	  
	  if(f_name %in% c("Count_by_effects.csv", "Count_by_genomic_region.csv", "Effects_by_functional_class.csv", "Effects_by_impact.csv", "Variantss_by_type.csv")) {
	    g1 <- ggplot(df, aes(y=features, x=values)) + geom_bar(stat="identity", fill=cols, width = 0.8) + labs(title="", x="Count", y="") + theme_bw() + theme(panel.grid = element_blank(), text = element_text(size = 14))
	    ggsave(filename = paste0(data_dir, "/", o_name, ".png"), g1, width = 6.5, height = 4)
	    ggsave(filename = paste0(data_dir, "/", o_name, ".pdf"), g1, width = 6.5, height = 4)
	  }
	  else if(f_name == "Ts_Tv_summary.csv") {
	    g1 <- ggplot(df, aes(y=features, x=values)) + geom_bar(stat="identity", fill=cols, width = 0.8) + coord_flip() + labs(title="", x="", y="Count") + theme_bw() + theme(panel.grid = element_blank(), text = element_text(size = 14))
	    ggsave(filename = paste0(data_dir, "/", o_name, ".png"), g1, width = 4, height = 4)
	    ggsave(filename = paste0(data_dir, "/", o_name, ".pdf"), g1, width = 4, height = 4)
	    
	    ## Ratio
	    titv_ratio <- df$values[df$features == "Transitions"] / df$values[df$features == "Transversions"]
	    ## SampleName will be dynamic
	    ratio_df = data.frame("sampleName", titv_ratio)
	    colnames(ratio_df) = c("feature", "value")
	    
	    g1 <- ggplot(ratio_df, aes(y=value, x=feature)) + geom_bar(stat="identity", fill=cols, width = 0.8) + coord_flip() + labs(title="", x="", y="Transition/Transversion Ratio") + theme_bw() + theme(panel.grid = element_blank(), text = element_text(size = 14))
	    ggsave(filename = paste0(data_dir, "/", o_name, ".png"), g1, width = 6, height = 4)
	    ggsave(filename = paste0(data_dir, "/", o_name, ".pdf"), g1, width = 6, height = 4)
	  } else if(f_name == "Amino_acid_change_table.csv") {
	    rownames(df) = df[,1]
	    df[,1] = NULL
	    
	    heatmap_input = as.matrix(df)
	    heatmap_input[heatmap_input == 0] = NA

	    h1 <- Heatmap(heatmap_input,name = "count", cluster_rows = F, cluster_columns = F, column_names_rot = 90, column_names_side = "top", na_col = "white", border_gp = gpar(col = "black"), rect_gp = gpar(col = "gray80", lwd = 1))
	    pdf(paste0(data_dir, "/", o_name, ".pdf"), width = 6, height = 6)
	    print(h1)
	    dev.off()
	    png(paste0(data_dir, "/", o_name, ".png"), width = 600, height = 600)
	    print(h1)
	    dev.off()
	  } else if(f_name == "Base_changes.csv") {
	    rownames(df) = df[,1]
	    df[,1] = NULL
	    
	    heatmap_input = as.matrix(df)
	    
	    h1 <- Heatmap(heatmap_input, name = "count", cluster_rows = F, cluster_columns = F, column_names_rot = 0, column_names_side = "top", na_col = "white", border_gp = gpar(col = "black"), rect_gp = gpar(col = "gray90", lwd = 2))
	    pdf(paste0(data_dir, "/", o_name, ".pdf"), width = 4, height = 3.8)
	    print(h1)
	    dev.off()
	    png(paste0(data_dir, "/", o_name, ".png"), width = 200, height = 180)
	    print(h1)
	    dev.off()
	  } else if(f_name == "Codon_change_table.csv"){
	    rownames(df) = df[,1]
	    df[,1] = NULL
	    
	    heatmap_input = as.matrix(df)
	    heatmap_input[heatmap_input == 0] = NA
	    
	    h1 <- Heatmap(heatmap_input,name = "count", cluster_rows = F, cluster_columns = F, column_names_rot = 90, column_names_side = "top", na_col = "white", border_gp = gpar(col = "black"), rect_gp = gpar(col = "gray80", lwd = 1))
	    pdf(paste0(data_dir, "/", o_name, ".pdf"), width = 8, height = 8)
	    print(h1)
	    dev.off()
	    png(paste0(data_dir, "/", o_name, ".png"), width = 800, height = 800)
	    print(h1)
	    dev.off()
	  } else if(f_name == "Change_rate_by_chromosome.csv"){
	    if(nrow(df) > 25){
		 df = head(df, 25)
	    }
	    g1 <- ggplot(df, aes(y=features, x=values)) + geom_bar(stat="identity", fill=cols, width = 0.8) + labs(title="", x="Count", y="") + theme_bw() + theme(panel.grid = element_blank(), text = element_text(size = 14))
	    ggsave(filename = paste0(data_dir, "/", o_name, ".png"), g1, width = 4.5, height = 6)
	    ggsave(filename = paste0(data_dir, "/", o_name, ".pdf"), g1, width = 4.5, height = 6)
	  } else if(f_name == "InDel_lengths.csv"){
	    g1 <- ggplot(df, aes(x=features, y=values)) + geom_line(colour = cols, linewidth = 2) + labs(title="", x="Insertions & Deletions Length", y="") + theme_bw() + theme(panel.grid = element_blank(), text = element_text(size = 14))
	    ggsave(filename = paste0(data_dir, "/", o_name, ".png"), g1, width = 5, height = 4)
	    ggsave(filename = paste0(data_dir, "/", o_name, ".pdf"), g1, width = 5, height = 4)
	  }
	}
}
