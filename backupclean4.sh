#script ini bertujuan menghapus folder backup 4 minggu yang lalu

#!/bin/sh

weekofyear="$(date --date='-4 weeks' +'%Y-%W')"

#weekly directory
level0dir="/home/osboxes/backup/$weekofyear"

if [ -d $level0dir ]; then
	echo "sudah ada directory $weekofyear"
	rm -rf $level0dir
fi
