# PRJ2170
Build EXIF db for preprocessing operation of the PRJ2170 project

# General information
* File or Package Name: HAVFI1_build_db_PRJ2170.R
* Title: Build EXIF db for preprocessing operation
* Description: Program to build a database with the EXIF images of ./data of the PRJ2170
            project in order to set the quality control and input of additional
            information required in preprocessing.
* Version: 1.0.0
* Author: Patrice Tardif
* Maintainer: Patrice Tardif
* License: MIT
* Date: 2019-11-12

# Intallation for Exif library
After installing a copy of the ExifTool library or executable into the exiftoolr package's directory tree, where calls to functions in the exiftoolr package will automatically find it, run install_exiftool() at the console command:

exiftoolr::install_exiftool()

NOTE: loading library(exiftoolr); install_exiftool() seem not working use rather the command line above which is fine.
