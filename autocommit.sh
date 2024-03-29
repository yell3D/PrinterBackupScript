#!/bin/bash


### Changes
# Feb 12, 2024
#   added auto banch name
# Sep 10, 2023 
#  removed legacy token notes
#  marked script with filemod +x
#  renamed default branch
# Jul 24, 2023 Initial Version from https://github.com/EricZimmerman/VoronTools/blob/main/autocommit.sh
###

#######################################################################
## NOTE: This script originates from here but I tweaked the pull     ##
## command, changed default location for backup, and added a comment ##
## for reference later.                                              ##
#######################################################################

#####################################################################
### Please set the paths accordingly. In case you don't have all  ###
### the listed folders, just keep that line commented out.        ###
#####################################################################
### Path to your config folder you want to backup
config_folder=~/printer_data/config/printerconfig

# NOTE: The above should work for just about everyone, but a somewhat
# recent update to moonraker changed paths, etc. You can run the 
# provided moonraker script 'data-path-fix.sh' to fix/update
# older installs

### Path to your Klipper folder, by default that is '~/klipper'
klipper_folder=~/klipper

### Path to your Moonraker folder, by default that is '~/moonraker'
moonraker_folder=~/moonraker

### Path to your Mainsail folder, by default that is '~/mainsail'
mainsail_folder=~/mainsail

### Path to your Fluidd folder, by default that is '~/fluidd'
#fluidd_folder=~/fluidd

### The branch of the repository that you want to save your config
### By default that is 'master'
branch=$(git branch -vv | grep -Po  "^[\s\*]*\K[^\s]*(?=.*$(git branch -rl '*/HEAD' | grep -o '[^ ]\+$'))")

#####################################################################
#####################################################################


#####################################################################
################ !!! DO NOT EDIT BELOW THIS LINE !!! ################
#####################################################################
grab_version(){
  if [ ! -z "$klipper_folder" ]; then
    cd "$klipper_folder"
    klipper_commit=$(git rev-parse --short=7 HEAD)
    m1="Klipper on commit: $klipper_commit"
    cd ..
  fi
  if [ ! -z "$moonraker_folder" ]; then
    cd "$moonraker_folder"
    moonraker_commit=$(git rev-parse --short=7 HEAD)
    m2="Moonraker on commit: $moonraker_commit"
    cd ..
  fi
  if [ ! -z "$mainsail_folder" ]; then
    mainsail_ver=$(head -n 1 $mainsail_folder/.version)
    m3="Mainsail version: $mainsail_ver"
  fi
  if [ ! -z "$fluidd_folder" ]; then
    fluidd_ver=$(head -n 1 $fluidd_folder/.version)
    m4="Fluidd version: $fluidd_ver"
  fi
}

push_config(){
  cd $config_folder
  git pull origin $branch --no-rebase
  git add .
  current_date=$(date +"%Y-%m-%d %T")
  git commit -m "Autocommit from $current_date" -m "$m1" -m "$m2" -m "$m3" -m "$m4"
  git push origin $branch
}

grab_version
push_config
