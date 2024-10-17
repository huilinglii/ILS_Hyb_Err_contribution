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
# packageVersion("ape")
# [1] ‘5.8’
# packageVersion("ggtree")
# [1] ‘3.12.0’


setwd("D:\\Desktop\\test")


# Read the tree
tree_01 <- read.tree(file = "01_root_astral_consensus.tre")
tree_02 <- read.tree(file = "02_root_RAxML_bestTree.raxml_constrain.tre")
tree_04 <- read.tree(file = "04_unbalanced_triples_perc_reticulation_index.tre")
tree_05 <- read.tree(file = "05_RAxML_bipartitions.ERROR")

# reordered_node_data_06 <- fortify(reordered_tree_06)
# cant extract gCF node label
# use python

# Reorder the tree so that its node order matches the constrain tree
reorder_tree <- function(constrain_tree, tree_for_reorder, output_file = NULL) {
  if (is.null(constrain_tree) || is.null(tree_for_reorder)) {
    stop("Input trees cannot be NULL.")
  }
  
  constrain_tips <- constrain_tree$tip.label
  
  tip_children <- constrain_tree$edge[constrain_tree$edge[, 2] <= length(constrain_tips), 2]
  
  child_labels <- constrain_tips[tip_children]
  
  reordered_tips <- match(child_labels, tree_for_reorder$tip.label)
  
  if (any(is.na(reordered_tips))) {
    warning("Some tip labels from constrain_tree are not present in tree_for_reorder.")
  }
  
  reordered_tips <- reordered_tips[!is.na(reordered_tips)]
  
  if (length(reordered_tips) == 0) {
    stop("No matching tip labels found in tree_for_reorder.")
  }
  
  reordered_tree <- tree_for_reorder
  
  reordered_tree$tip.label <- tree_for_reorder$tip.label[reordered_tips]
  
  reordered_tree <- reorder(reordered_tree, "postorder")
  
  if (!is.null(output_file)) {
    write.tree(reordered_tree, file = output_file)
  }
  
  return(reordered_tree)
}
# We choose tree_01 as the constrain tree
reordered_tree_02 <- reorder_tree(tree_01, tree_02)
reordered_tree_04 <- reorder_tree(tree_01, tree_04)
reordered_tree_05 <- reorder_tree(tree_01, tree_05)



# convert phylogenetic trees into a data frame 
# should use fortify in library(ggtree) rather than library(ggplot2)
node_data_01 <- fortify(tree_01)
reordered_node_data_02 <- fortify(reordered_tree_02)
# write.csv(node_data_01, file = "node_data_01_output.csv", row.names = FALSE)
# write.csv(reordered_node_data_02, file = "reordered_node_data_02_output.csv", row.names = FALSE)

# generate theta for ILS
# node_data_03
node_data_03 <- node_data_01
node_data_03$branch_length2 <- reordered_node_data_02$branch.length
node_data_03$theta <- NA

node_data_03$theta[node_data_03$isTip == FALSE & node_data_03$branch.length > 0.000000010] <- 
  node_data_03$branch_length2[node_data_03$isTip == FALSE & node_data_03$branch.length > 0.000000010] / 
  node_data_03$branch.length[node_data_03$isTip == FALSE & node_data_03$branch.length > 0.000000010]

node_data_03$branch_length2 <- NULL
node_data_03$label[node_data_03$isTip == FALSE] <- node_data_03$theta[node_data_03$isTip == FALSE]
node_data_03$theta <- NULL

# write.csv(node_data_03, file = "node_data_03_output.csv", row.names = FALSE)

####


reordered_node_data_04 <- fortify(reordered_tree_04)
reordered_node_data_05 <- fortify(reordered_tree_05)
# write.csv(node_data_04, file = "node_data_04_output.csv", row.names = FALSE)
# write.csv(node_data_05, file = "node_data_05_output.csv", row.names = FALSE)

# generate csv with nodeid X2_Err	X3_Hyb	X1_ILS
num_non_tips <- sum(node_data_03$isTip == FALSE)
relaimpo_raw <- data.frame(nodeid = numeric(num_non_tips),
                           X1_ILS = character(num_non_tips),
                           X2_Err = character(num_non_tips),
                           X3_Hyb = character(num_non_tips),
						   branch_length = character(num_non_tips),
                           stringsAsFactors = FALSE)
relaimpo_raw$nodeid <- node_data_03$node[node_data_03$isTip == FALSE]
relaimpo_raw$X1_ILS <- node_data_03$label[node_data_03$isTip == FALSE]
relaimpo_raw$X2_Err <- reordered_node_data_05$label[reordered_node_data_05$isTip == FALSE]
relaimpo_raw$X3_Hyb <- reordered_node_data_04$label[reordered_node_data_04$isTip == FALSE]
relaimpo_raw$branch_length <- reordered_node_data_02$branch.length[reordered_node_data_02$isTip == FALSE]
write.csv(relaimpo_raw, file = "relaimpo_raw.csv", row.names = FALSE)

