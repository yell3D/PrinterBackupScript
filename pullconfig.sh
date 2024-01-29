#!/bin/bash


### Changes
# Jan 29, 2024 
#   created
###


config_folder=~/printer_data/config/printerconfig
branch=main


cd $config_folder
git pull origin $branch --no-rebase

