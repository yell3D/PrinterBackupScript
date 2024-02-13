# PrinterBackupScript
Script to backup MainsailOS (and likely others) to github

# Prep
* Sign into GitHub and create a new repository
* make a Deployment Key  https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#deploy-keys
* Initialize git


# Install
Login to your machine via ssh and run these commands:
```
cd ~
git clone https://github.com/yell3D/PrinterBackupScript.git
chmod +x PrinterBackupScript/autocommit.sh
```

Now, add this section to your moonraker.conf via GUI or CLI (nano ~/printer_data/config/moonraker.conf)

```
[update_manager PrinterBackupScript]
type: git_repo
channel: dev
path: ~/PrinterBackupScript
origin: https://github.com/yell3D/PrinterBackupScript.git
is_system_service: False
```

Note: maybe not trust a stranger on the internet.. you can however fork THIS repo and add your own.
(edit the github path inside the install.sh)

# How to backup

## Manual
 ssh into the pi and `~/PrinterBackupScript/autocommit.sh`

## at a event

Note: if the user has no existing crontab, you may see this message: `no crontab for <username>`

(it still works, even if you see that message.)

on reboot
```
crontab -l | { cat; echo "@reboot /home/pi/PrinterBackupScript/autocommit.sh >/dev/null 2>&1"; } | crontab -
```

every 6 hours
```
crontab -l | { cat; echo "* */6 * * * /home/pi/PrinterBackupScript/autocommit.sh >/dev/null 2>&1"; } | crontab -
```
(use this site to create the cron entry https://crontab-generator.org you can also edit the crontab interactivly via `crontab -e` 

## Gcode
install Klipper gcode extension and restart klipper
```
wget -P ~/klipper/klippy/extras/ https://raw.githubusercontent.com/dw-0/kiauh/master/resources/gcode_shell_command.py
```

then make a new conf and include it, or put in into another one
```
[gcode_shell_command backup_to_github]
command: /usr/bin/bash /home/pi/PrinterBackupScript/autocommit.sh
timeout: 30.0
verbose: True

[gcode_macro BACKUP_CONFIG]
description: Backs up config directory GitHub
gcode:
   RUN_SHELL_COMMAND CMD=backup_to_github

```


# credits
https://docs.vorondesign.com/community/howto/EricZimmerman/BackupConfigToGithub.html
