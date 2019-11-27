# File or Package Name: HAVFI1_build_db_PRJ2170.R
# Title: Build EXIF db for preprocessing operation
# Description: Program to build a database with the EXIF images of ./data of the PRJ2170
#             project in order to set the quality control and input of additional
#             information required in preprocessing.
# Version: 1.0.0
# Author: Patrice Tardif
# Maintainer: Patrice Tardif
# License: MIT
# Date: 2019-11-12



library(tidyverse)
library(exiftoolr)
library(DBI)
library(RSQLite)


# Paramaters for data location and output in the project
PATH_PHOTO <-  "./data"
PATH_OUT <- "./output"
if (!dir.exists(PATH_OUT)) {
  dir.create(PATH_OUT)
}
fName <- "db_exif"


# Find all JPEG files and extract some EXIF tags for built a dataframe
ls_file <- list.files(path=PATH_PHOTO, pattern = "\\.JPG", ignore.case = T, recursive = T, full.names = T)
df_exif <-  exif_read(ls_file, tags = c("SourceFile", "FileName", "Directory", "FileSize", "FileModifyDate",
                                        "FileCreateDate", "ModifyDate", "CreateDate", "DateTimeOriginal")) %>% 
  as.data.frame(.)
df_ext <- cbind(fs::path_ext_remove(basename(ls_file)),
                fs::path_dir(ls_file) %>%
                  lapply(., function(d) {
                    tail(unlist(strsplit(d, "/")), n = 2)}) %>%
                  do.call(rbind, .)) %>% 
  as.data.frame(., stringsAsFactors = F)
names(df_ext) <- c("FileNameWOExt", "ProjectName", "DeepestDIR")


# Merge data and convert file paths to canonical form for the Windows platform export step (Re-windowsified path)
df_fullDATA <- cbind(df_exif, df_ext)
df_fullDATA["SourceFile"] <- lapply(df_fullDATA["SourceFile"], function(d) {normalizePath(d, winslash = "\\")})
df_fullDATA["Directory"] <- lapply(df_fullDATA["Directory"], function(d) {normalizePath(d, winslash = "\\")})


# Export in the universal format SQLite database since more convenient format
mydb <- dbConnect(RSQLite::SQLite(), file.path(PATH_OUT, paste(sep="",fName,".sqlite")))
dbWriteTable(mydb, "exif", df_fullDATA)
dbDisconnect(mydb)

# Export also the dataframe in CSV format
write.csv(df_fullDATA, file.path(PATH_OUT, paste(sep="",fName,".csv")), row.names = F)



