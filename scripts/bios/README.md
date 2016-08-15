# Bios upgrades and settings

There are 3 parts to preping a host for use.  They are

- Upgrade the bios
- Set the bios to standard settings
- Set the RAID configuration for each server

All scripts are designed to take a file of ips as an argument.   

See each script (source) to understand its inputs. 

## Prerequisites

## Packages Needed

These packages are needed

#### hprest

** for centoos **
```shell
<<EOF >> /etc/yum.repos.d/
[hprest]
name=hpe restful interface tool
baseurl=http://downloads.linux.hpe.com/SDR/repo/hprest/RedHat/7/x86_64/current/
enabled=1
gpgcheck=0
EOF

yum install -y hprest
```

#### sshpass
** for centoos **
```shell

yum install -y sshpass
```

## Environment

Many of these tools interact with the ilo and as such need access to the ilo user and password.   
This is done via environment.   Set $ilo_user and $ilo_pass before running any scripts.

```shell
export ilo_user=admin
export ilo_pass=*****
```


## Upgrade 
To upgrade the bios we mount an iso over http that is then booted from that will upgrade the bios to a version imbeded in the iso.   The iso is hosted on the deploy host via http.  This script should run on the same host so the iso location can be validated. 





## Bios standards


You can then run it by writting a file with one ilo ip per host then passing that file to update_bios_settings like this

```shell
./update_bios_settings/update.sh ./my_ilo_ip_list.txt
```

