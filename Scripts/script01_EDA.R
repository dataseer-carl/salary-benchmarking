# Script header ################################################

library(googledrive)
drive_auth()

library(readr)
library(dplyr)
library(ggplot2)
library(GGally)

source("./scripts/template_fxns.R") # RStudio
# source("./template_fxns.R") # Jupyter

## data://
datapath.id <- as_id("1PCSugzs0MUHa6sEpa8GM0UiPwTaImvUy")

## proxy data://
proxydata.path <- file.path(".", "Data") # For RStudio
# proxydata.path <- file.path("..", "Data") # For Jupyter

#************************************************************************#

# Raw ingest #####

raw.id <- as_id("1xwIsARVUV_vMBkP_L4uYSsKCOsQyMDeP")
raw.file <- "dl00_raw ingest.rds"
raw.filepath <- file.path(proxydata.path, raw.file)
drive_download(raw.id, path = raw.filepath, overwrite = TRUE)

hr.df <- readRDS(raw.filepath)

## > y := MonthlyIncome
## Demographic factors: Sex, Age, MaritalStatus
## Education and work XP: Education, priorNumCompaniesWorked, priorYearsOfWork
## Career factors: Tenure, Department, JobLevel, JobRole|Department
## Other salary terms: StockOptionLevel

# EDA ####

hr.gg <- hr.df %>% 
	select(-EmployeeNumber, -DistanceFromHome, -EducationField, -JobRole) %>% 
	ggpairs()

hr.gg +
	theme(
		plot.background = element_blank(),
		panel.background = element_rect(fill = NA, colour = "#787c84"),
		panel.grid = element_blank(),
		axis.text = element_blank(),
		axis.ticks = element_blank(),
		strip.background = element_rect(fill = "#787c84", colour = NA),
		strip.text = element_text(colour = "white")
	)

## Age correlated with priorYearsWorked and Tenure

# Split ####

new.df <- hr.df %>% filter(Tenure == 0)

new.WL <- new.df %>% mutate(MonthlyIncome = NA)

new.ls <- list(CanShow = new.WL, DoNotShow = new.df)

current.df <- hr.df %>% filter(Tenure > 0)

cache.file <- "data01_split data.RData"
cache.filepath <- file.path(proxydata.path, cache.file)
save(current.df, new.ls, file = cache.filepath)
drive_upload(cache.filepath, datapath.id, cache.file)
drive_sub_id(datapath.id, cache.file) # 1Zs5YOEdOCemlcMMrwdDKl8qkHTfSZRL_
