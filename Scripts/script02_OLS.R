# Script header ################################################

library(googledrive)
drive_auth()

library(readr)
library(dplyr)
library(magrittr)
library(ggplot2)
library(Metrics)

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
		Education = Education %>% relevel(ref = "College")
	)

ols.lm0 <- lm(
	MonthlyIncome ~ priorYearsOfWork + Tenure + Department:JobLevel,
	data = current.df
)
summary(ols.lm0)

model.file <- "model00_OLS-pilot.rds"
model.filepath <- file.path(proxydata.path, model.file)
saveRDS(ols.lm0, model.filepath)
drive_upload(model.filepath, datapath.id, model.file)
drive_sub_id(datapath.id, model.file) # 1i5K67XPmtY1fYX2LG_gFjBU18VgELf2y

# Score ####

ols.id <- as_id("1i5K67XPmtY1fYX2LG_gFjBU18VgELf2y")
ols.file <- "dl02_OLS-pilot.rds"
ols.filepath <- file.path(proxydata.path, ols.file)
drive_download(ols.id, path = ols.filepath, overwrite = TRUE)
ols.lm0 <- readRDS(ols.filepath)

## _Train ####

current.df %<>%
	mutate(
		MonthlyIncome.estimated = predict(ols.lm0, .) %>% unname()
	)

current.df %>% 
	summarise(
		RMSE = rmse(MonthlyIncome, MonthlyIncome.estimated) # 1448
	)

## _Test ####

test.df <- new.ls$DoNotShow

test.df %<>%
	mutate(
		MonthlyIncome.estimated = predict(ols.lm0, .) %>% unname()
	)

ols.rmse <- test.df %>% 
	summarise(
		RMSE = rmse(MonthlyIncome, MonthlyIncome.estimated) # 1039
	)
