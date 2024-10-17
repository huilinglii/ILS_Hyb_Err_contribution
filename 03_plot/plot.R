# R.version
# _                                
# platform       x86_64-w64-mingw32               
# arch           x86_64                           
# os             mingw32                          
# crt            ucrt                             
# system         x86_64, mingw32                  
# status                                          
# major          4                                
# minor          4.1                              
# year           2024                             
# month          06                               
# day            14                               
# svn rev        86737                            
# language       R                                
# version.string R version 4.4.1 (2024-06-14 ucrt)
# nickname       Race for Your Life 
library(ape)
library(ggtree)
library(ggplot2)
library(dplyr)
# packageVersion("ape")
# [1] ‘5.8’
# packageVersion("ggtree")
# [1] ‘3.12.0’
# packageVersion("ggplot2")
# [1] ‘3.5.1’
# packageVersion("dplyr")
# [1] ‘1.1.4’


setwd("D:/Desktop/03_plot")


tree_01 <- read.tree(file = "01_root_astral_consensus.tre")
node_data_01 <- fortify(tree_01)
node_data <- node_data_01
node_label <- read.csv("relaimpo.csv")
node_data$X1_ILS <- NA
node_data$X2_Err <- NA
node_data$X3_Hyb <- NA
node_data$Y_BSsum <- NA
node_data <- node_data %>%
  left_join(node_label, by = c("node" = "nodeid")) %>%
  mutate(
    X1_ILS = coalesce(X1_ILS.x, X1_ILS.y),
    X2_Err = coalesce(X2_Err.x, X2_Err.y),
    X3_Hyb = coalesce(X3_Hyb.x, X3_Hyb.y),
    Y_BSsum = coalesce(Y_BSsum.x, Y_BSsum.y)
  ) %>%
  select(-ends_with(".x"), -ends_with(".y"))

# ATTENTION!!!!
# Since both X1_ILS and X3_Hyb values are detrimental to phylogenetic establishment as they increase, 
# and X2_Err is detrimental when it decreases, while Y_BSsum indicates poorer phylogenetic relationships with smaller values, 
# we want the label values to reflect a greater impact on phylogenetic relationships. 
# Therefore, we will replace the values of X2_Err with (100 - bipartition_value) and replace Y_BSsum values with (100 - gCF).
node_data <- node_data %>%
  mutate(
    X2_Err = ifelse(!is.na(X2_Err), 100 - X2_Err, X2_Err),
    Y_BSsum = ifelse(!is.na(Y_BSsum), 100 - Y_BSsum, Y_BSsum)
  )

#write.csv(node_data, "node_data1.csv", row.names = FALSE)
print(node_data)


# plot
plot <- function(tree, labell, output_file = NULL){
  ggtree(tree, branch.length = "none") + #ignore branch length
    geom_tree(size = 4) + 
    geom_nodepoint(aes(color = labell), size=28) +
    scale_color_gradient(low="#6D82FF", high="#FB4949", na.value="grey") +
    geom_tiplab(size = 4,          
                vjust = 0.5,       
                nudge_x = 0,    
                nudge_y = 0.1,  
                offset = 0.5,
                fontface = "bold", align = TRUE, hjust = 0) +  
    theme(legend.position = c(0.1, 0.8), legend.key.size = unit(8, "lines"), legend.text = element_text(size = 50))
  
  if (!is.null(output_file)) {
    ggsave(output_file, width = 20, height = 40, units = "in")
  }
}


plot(tree_01, node_data$X1_ILS, output_file = "X1_ILS.png")
plot(tree_01, node_data$X2_Err, output_file = "X2_Err.png")
plot(tree_01, node_data$X3_Hyb, output_file = "X3_Hyb.png")
plot(tree_01, node_data$Y_BSsum, output_file = "Y_BSsum.png")

