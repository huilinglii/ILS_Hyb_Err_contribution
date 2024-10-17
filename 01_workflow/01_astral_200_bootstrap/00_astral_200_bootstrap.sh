# astral5.7.1


# 给每个基因在raxml中建立ML基因树的时候，设置bootstrap为200
# 那么每个基因会生成一个包含200个树的bootstrap文件
# 将所有基因对应的bootstrap文件的绝对路径+文件全称写到一个文件里（我的这个文件名叫bs-files）
# 在astral5.7.1中推断boostrap物种树
# -r bootstrap的值
# -i 在raxml中用ML推断的best gene tree
# -b 包含所有基因对应的bootstrap文件的绝对路径+文件全称的bs-files
# -o 输出的bootstrap species tree的文件名
java -jar /data/software/astral/ASTRAL-5.7.1/astral.5.7.1.jar -r 200 -i modified_1113gene.tre -b bs-files -o modified_1113gene.astral.tre
# output中，前200个是bootstrap


# 使用pxrr 0.1 给物种树定根
# -g 外类群的名字 
pxrr -t modified_1113gene.astral.tre -g Vitis_vinifera -o root_modified_1113gene.astral.tre


# astral5.7.1 的说明
"
The argument after -i (here song_mammals.424.gene.tre) contains all the maximum likelihood gene trees (just like the case where bootstrapping was not used).
The -b option tells ASTRAL that bootstrapping needs to be performed. Following -b is the name of a file (here bs-files) that contains the file path of gene tree bootstrap files, one line per gene. Thus, the input file is not a file full of trees. It's a file full of paths of files full of trees.
For example, the first line is 424genes/100/raxmlboot.gtrgamma/RAxML_bootstrap.allbs, which tells ASTRAL that the gene tree bootstrap replicates of the first gene can be found in a file called 424genes/100/raxmlboot.gtrgamma/RAxML_bootstrap.allbs. In this case, bs-files has 424 lines (the number of genes) and each file named in bs-files has 100 trees (the number of bootstrap replicates).
if you have -r 150, each file listed in bs-files should contain at least 150 bootstrap replicates

The output file (here, song_mammals.bootstrapped.astral.tre) includes:

100 bootstrapped replicate trees; each tree is the result of running ASTRAL on a set of bootstrap gene trees (one per gene).
A greedy consensus of the 100 bootstrapped replicate trees; this tree has support values drawn on branches based on the bootstrap replicate trees. Support values show the percentage of bootstrap replicates that contain a branch.
The “main” ASTRAL tree; this is the results of running ASTRAL on the best_ml input gene trees. This main tree also includes support values, which are again drawn based on the 100 bootstrap replicate trees.
Note: Support values are shown as percentages, as opposed to local posterior probabilities that are shown as a number between 0 and 1. When you perform bootstrapping, local posterior probabilities are not computed. If you want those as well, use the output of bootstrapping as input to astral with -q to annotate branches with posterior probabilities (see branch annotations).

As ASTRAL performs bootstrapping, it continually outputs the bootstrapped ASTRAL tree for each replicate. So, if the number of replicates is set to 100, it first outputs 100 trees. Then, it outputs a greedy consensus of all the 100 bootstrapped trees (with support drawn on branches). Finally, it performs the main analysis (i.e., on trees provided using -i option) and draws branch support on this main tree using the bootstrap replicates. Therefore, in this example, the output file will include 102 trees.

What to use: The most important tree is the tree outputted at the end; this is the ASTRAL tree on main input trees, with support values drawn based on bootstrap replicates. Our analyses have shown this tree to be better than the consensus tree in most cases.
"
