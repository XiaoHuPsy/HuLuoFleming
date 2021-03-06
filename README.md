# HuLuoFleming
This repository contains data and code supporting the following paper:

Hu, X., Luo, L., & Fleming, S. M. (2019). A role for metamemory in cognitive offloading. Cognition, 193, 104012. doi: 10.1016/j.cognition.2019.104012

Script and data files are included in the repository to enable replication of data analyses and generation of the figures in the paper.

The folder **tasks** contains the Psychtoolbox scripts for tasks in Experiments 1 and 2a. Run *offloadMem.m* to start the experiment.

The folder **rawData** contains anonymised raw data files for each of the four experiments of the paper, and the scripts *genSummaryStats_Exp1/2/3.m* to generate summary statistics in the **summaryStats** folder.

The folder **summaryStats** contains summary statistics in SPSS format for each experiment, and the script *partialEtaSq.m* to compute effect size (partial eta squared) for linear mixed effect model.

The folder **modeling** contains the JAGS model files, data for modeling, model fitting results and scripts for model fitting and generation of model predictions and figures.

Please read the .md files in the folders for further explanation of the data.
