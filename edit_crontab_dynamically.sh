export DATE_ID=`date +%y%m%d%H%M%S`

crontab -l > crontab.${DATE_ID}

crontab -l > crontab.out

# to edit the file 
vi crontab.out

# Load crontab from the file edited
crontab crontab.out


crontab -l

