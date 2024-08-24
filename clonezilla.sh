#!/bin/bash

# SSH bağlantı bilgileri
SSH_USER="u160583"
SSH_HOST="u160583.your-storagebox.de"
SSH_PORT=22
SSH_PASSWORD="o6zTdrQwiwrk045N"

# Yedekleme dizini ve hedef disk
REMOTE_DIR="/clonezilla"
LOCAL_MOUNT_POINT="/home/partimag"
IMAGE_NAME="LL-Windows11" # veya kullanmak istediğiniz imajın adı
TARGET_DISK="sda"

# SSHFS ile uzak yedekleme dizinini mount et
echo "SSH ile uzak sunucuya bağlanılıyor ve yedekleme dizini mount ediliyor..."
sshfs -o password_stdin -p $SSH_PORT $SSH_USER@$SSH_HOST:$REMOTE_DIR $LOCAL_MOUNT_POINT <<< $SSH_PASSWORD

# Clonezilla'yı başlat ve restore işlemini otomatik olarak başlat
echo "Clonezilla ile restore işlemi başlatılıyor..."
sudo ocs-sr -g auto -e1 auto -e2 -r -j2 -p true restoredisk $IMAGE_NAME $TARGET_DISK

# SSHFS mount'u kaldır
echo "SSHFS mount'u kaldırılıyor..."
fusermount -u $LOCAL_MOUNT_POINT

echo "Restore işlemi tamamlandı."
