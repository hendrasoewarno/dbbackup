# Backup Database MariaDB
Script untuk melakukan backup Mariadb dengan skenario sebagai berikut:
1. Pada setiap hari minggu akan melakukan full backup keseluruhan database
2. Pada setiap pagi hari pada minggu yang sama akan melakukan differensial backup terhadap hasil full backup hari minggunya
3. Pada setiap jam pada hari yang sama akan melakukan differensial backup terhadap hasil differesnial backup pagi harinya

Hasil backup akan disimpan pada suatu directory minggunan, misalkan script backup.sh dijalankan pada hari Minggu tanggal 22 Mei 2022(00:00),
maka sistem akan menghitung sebagai minggu ke 20 tahun 2022, membuat directory baru dengan nama <b>2022-20</b> yang akan menyimpan
hasil backup mulai Minggu 22 Mei 2022(00:00) s/d Sabtu 28 Mei 2022(23:00).

Menjalankan Backup:
Script backup.sh perlu dijalankan dengan menggunakan skedule seperti CRON, per-jam, sehingga didapatkan backup data sampai
pada jam terdekat.

```
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                                   7 is also Sunday on some systems)
# │ │ │ │ │
# │ │ │ │ │
  1 * * * * /path/to/backup.sh
```

Strategi restore:
1. Prepare restore ke full backup pada awal minggu
2. Prepare restore ke differensial backup pada tanggal terkait
3. Prepare restore ke differensial backup pada jam terkait
4. Jalankan restore
