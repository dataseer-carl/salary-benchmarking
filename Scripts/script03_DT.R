# Script header ################################################

library(googledrive)
drive_auth()

library(readr)
library(dplyr)
library(tidyr)
library(magrittr)
library(ggplot2)
library(Metrics)
library(tree)#library(rpart)

source("./scripts/template_fxns.R") # RStudio
# source("./template_fxns.R") # Jupyter

## data://
datapath.id <- as_id("1PCSugzs0MUHa6sEpa8GM0UiPwTaImvUy")

## proxy data://
proxydata.path <- file.path(".", "Data") # For RStudio
# proxydata.path <- file.path("..", "Data") # For Jupyter

#************************************************************************#

# Data #####

data.id <- as_id("1Zs5YOEdOCemlcMMrwdDKl8qkHTfSZRL_")
data.file <- "dl01_split data.rds"
data.filepath <- file.path(proxydata.path, data.file)
drive_download(data.id, path = data.filepath, overwrite = TRUE)

load(data.filepath)

# Train ####

str(current.df)

current.df %<>%
	mutate(
		Dummy = TRUE,
		Dept.col = paste("isDept", abbreviate(Department, 3), sep  = ".")
	) %>%
	spread(Dept.col, Dummy, fill = FALSE)

tree.lm0 <- tree(
	MonthlyIncome ~ priorYearsOfWork + Tenure,# + Department + JobLevel,
	data = current.df
)
plot(tree.lm0); text(tree.lm0)

tree.lm0
summary(tree.lm0)

## Prune

# rsq.rpart(tree.lm0)
# pruned.lm0 <- prune(tree.lm0, 0.05)
# plot(pruned.lm0); text(pruned.lm0)

tree.lm0.prune <- cv.tree(tree.lm0)
plot(tree.lm0.prune) # size = 4 or 6
pruned.lm0 <- prune.tree(tree.lm0, best = 6)
plot(pruned.lm0); text(pruned.lm0)

model.file <- "model00u_DT-pilot.rds"
model.filepath <- file.path(proxydata.path, model.file)
saveRDS(pruned.lm0, model.filepath)
drive_upload(model.filepath, datapath.id, model.file)
drive_sub_id(datapath.id, model.file) # 1MLB4kDTVm8pj9S-l7_mLgQYlD60d88_i
# model00_DT-pilot.rds # 1lMs9W51wJisGkIGc2HXmtvwk7xEASFr6

# Score ####

tree.id <- as_id("1MLB4kDTVm8pj9S-l7_mLgQYlD60d88_i")
tree.file <- "dl02u_DT-pilot.rds"
tree.filepath <- file.path(proxydata.path, tree.file)
drive_download(tree.id, path = tree.filepath, overwrite = TRUE)
tree.lm0 <- readRDS(tree.filepath)

## _Train ####

current.df %<>%
	mutate(
		MonthlyIncome.estimated = predict(tree.lm0, .) %>% unname()
	)

current.df %>% 
	summarise(
		RMSE = rmse(MonthlyIncome, MonthlyIncome.estimated) # 3092
	)

## _Test ####

test.df <- new.ls$DoNotShow

test.df %<>%
	mutate(
		MonthlyIncome.estimated = predict(tree.lm0, .) %>% unname()
	)

tree.rmse <- test.df %>% 
	summarise(
		RMSE = rmse(MonthlyIncome, MonthlyIncome.estimated) # 2527
	)
