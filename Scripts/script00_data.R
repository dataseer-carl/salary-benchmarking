# Script header ################################################

library(googledrive)
drive_auth()

library(readr)
library(dplyr)

source("./scripts/template_fxns.R") # RStudio
# source("./template_fxns.R") # Jupyter

## data://
datapath.id <- as_id("1PCSugzs0MUHa6sEpa8GM0UiPwTaImvUy")

## proxy data://
proxydata.path <- file.path(".", "Data") # For RStudio
# proxydata.path <- file.path("..", "Data") # For Jupyter

#************************************************************************#

# Raw #####

raw.id <- as_id("1sxojpwo5KUzvF4JuR3fUUul27fsxWF1g")
raw.file <- "employee record.csv"
raw.filepath <- file.path(proxydata.path, raw.file)
drive_download(raw.id, path = raw.filepath, overwrite = TRUE)

hr.raw <- read_csv(raw.filepath)
hr.df <- hr.raw %>% 
	mutate(
		MaritalStatus = factor(
			MaritalStatus, levels = c("Single", "Married", "Divorced")
		),
		Education = factor(
	      Education,
	      levels = c("Below College", "College", "Bachelor", "Master", "Doctor")
	  )
	)

cache.file <- "data00_raw ingest.rds"
cache.filepath <- file.path(proxydata.path, cache.file)
saveRDS(hr.df, cache.filepath)
drive_upload(cache.filepath, datapath.id, cache.file)
drive_sub_id(datapath.id, cache.file) # 16xNbhtunbVVZ82MYSoJ387r01ipnMZRO
