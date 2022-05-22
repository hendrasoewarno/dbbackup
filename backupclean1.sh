#script ini bertujuan untuk menghapus folder hasil backup 1 minggu lalu

#!/bin/sh

weekofyear="$(date --date='-1 weeks' +'%Y-%W')"

ymd="$(date --date='-1 weeks' +'%Y%m%d')"

dayofweek="$(date --date='-1 weeks' +'%w')"

hour="$(date --date='-1 weeks' +'%H')"

firsthour="00"

#weekly directory
level0dir="/home/osboxes/backup/$weekofyear"
fullbackup="/home/osboxes/backup/$weekofyear/$ymd-full"

#daily directory
level1dir="/home/osboxes/backup/$weekofyear/$ymd$firsthour-diff"

#current directory
level2dir="/home/osboxes/backup/$weekofyear/$ymd$hour-diff"

if [ -d $fullbackup ]; then
	echo "hapus $fullbackup"
	rm -rf $fullbackup
fi

if [ -d $level1dir ]; then
	echo "hapus $level1dir"
	rm -rf $level1dir
fi

if [ -d $level2dir ]; then
	echo "hapus $level2dir"
	rm -rf $level2dir
fi
