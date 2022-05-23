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

## Kompressi Hasil Backup
Perintah mariabackup akan menyimpan data dalam masing-masing folder sesuai dengan --target-dir yang ditentukan, sehingga perlu
dikompressi untuk menghemat media backup(tar.gz), dan menghapus folder tersebut. Tetapi tidak semua folder setelah dikompressi
dapat dihapus, seperti file full backup dan differensial backup harian yang masih menjadi acuan pada proses backup lanjutan
sebagaimana yang ditentukan pada --incremental-dir. Sedangkan Untuk folder backup setiap jam dapat langsung dihapus sesaat setelah
kompressi selesai dilakukan sistem.

## Menghapus folder Differensial Backup Kemarin
Folder hasil differensial Backup satu hari sebelumnya sudah dapat dihapus karena tidak akan menjadi acuan lagi pada --incremental-dir hari ini
untuk menghapus file differensial Backup satu hari sebelumnya.

## Menghapus folder Differensial Backup Minggu Lalu
Folder hasil differensial Backup satu minggu sebelumnya sudah dapat dihapus karena tidak akan menjadi acuan lagi pada --incremental-dir minggu ii
untuk menghapus file differensial Backup satu hari sebelumnya dapat menjalankan script backupclean1.sh

## Menghapus folder hasil backup 4 Minggu Lalu
Untuk menghapus hasil backup 4 minggu lalu dapat menjalankan backupclean4.sh


