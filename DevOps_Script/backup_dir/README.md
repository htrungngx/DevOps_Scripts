
By default, backup_dir.sh will backup file and directories:
- Backup file list specified by backup_dir.rc
- Compress backup set
- Delete backupset older than 10 days for date retention.
- Log any error messsages to /var/log/backup_dir.log

How To Use
==========
1. copy backup_dir.rc.sample to backup_dir.rc
2. Customize backup_dir.rc, especially BACKUP_DIR parameter
3. sudo ./backup_dir.sh ./backup_dir.rc
```
