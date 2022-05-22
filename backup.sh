#shell scrip ini bertujuan untuk melakukan:
#1. full backup secara weekly
#2. differential backup secara daily terhadap full backup weekly
#3. differential backup secara hourly terhadap differential backup daily
#
#hasil backup akan disimpan pada masing-masing folder weekofyear
#misalkan folder 2022-20 (tahun 2020 minggu ke 20)
#
#penamaan folder:
#1. full backup weekly Ymd-full (20220522-full)
#2. diff backup daily  Ymd-diff (20220523-diff)
#3. diff backup hourly YmdHH-diff (2022052312-diff)
#
#cara restore:
#misalkan kita ingin melakukan restore database
#untuk tanggal 25-mei-2022, jam 18:00
#maka perlu dilakukan persiapan sebagai berikut
#1. mulai dari weekly-full-backup (20220522-full)
#2. kemudian diikuti daily-diff-backup (20220525-diff)
#3. diakhir dengan hourly-diff-backup (2022052518-diff)
#
#contoh:
#
#mariabackup --prepare --target-dir=/home/osboxes/backup/2022-20/20220522-full
#mariabackup --prepare --target-dir=/home/osboxes/backup/full --incremental-dir=/home/osboxes/backup/2022-20/20220525-diff
#mariabackup --prepare --target-dir=/home/osboxes/backup/20220525-diff --incremental-dir=/home/osboxes/backup/2022-20/2022052518-diff
#service mariadb stop
#rm /var/lib/mysql -rf
#mariabackup --copy-back --target-dir=/home/osboxes/backup/2022-20/20220522-full
#chown -R mysql:mysql /var/lib/mysql
#service mariadb start

#!/bin/sh

user="backup"
password="mypassword"

weekofyear="$(date +'%Y-%W')"

ymd="$(date +'%Y%m%d')"

dayofweek="$(date +'%w')"

hour="$(date +'%H')"

sunday="0"

firsthour="00"

#weekly directory
level0dir="/home/osboxes/backup/$weekofyear"
fullbackup="/home/osboxes/backup/$weekofyear/$ymd-full"

#daily directory
level1dir="/home/osboxes/backup/$weekofyear/$ymd$firsthour-diff"

#current directory
level2dir="/home/osboxes/backup/$weekofyear/$ymd$hour-diff"

#echo $level0dir
#echo $level1dir
#echo $level2dir

if [ -d $level0dir ]; then
	echo "sudah ada directory minggu $weekofyear"

else
	echo "buat directory minggu $weekofyear"

	mkdir $level0dir

fi

if [ -d $fullbackup ]; then
	echo "sudah ada fullbackup mingguan"

	if [ -d $level1dir ]; then
		echo "sudah ada differensial backup mingguan->harian"
		echo "lakukan differensial backup harian->jam"

		mariabackup --backup --target-dir=$level2dir --incremental-basedir=$level1dir --user=$user --password=$password

	else
		echo "lakukan differensial backup mingguan->harian"

		mariabackup --backup --target-dir=$level1dir --incremental-basedir=$fullbackup --user=$user --password=$password

	fi

else
	echo "lakukan fullbackup  mingguan"

	mariabackup --backup --target-dir=$fullbackup --user=$user --password=$password

fi
