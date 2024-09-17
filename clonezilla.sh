#!/bin/bash

# SSHFS'nin yüklü olup olmadığını kontrol et
if ! command -v sshfs &> /dev/null
then
    echo "SSHFS yüklü değil. Kurulum yapılıyor..."
    sudo apt-get update
    sudo apt-get install sshfs -y
else
    echo "SSHFS zaten kurulu."
fi

# SSHFS ile sunucuya bağlan ve /clonezilla'yı mount et
USERNAME="u160583"
PASSWORD="o6zTdrQwiwrk045N"
REMOTE_HOST="u160583.your-storagebox.de"
REMOTE_DIR="/clonezilla"
LOCAL_MOUNT="/home/partimag"

echo "SSHFS ile $USERNAME@$REMOTE_HOST sunucusuna bağlanılıyor ve $REMOTE_DIR mount ediliyor..."
echo "$PASSWORD" | sshfs -o password_stdin -p 22 -o reconnect,ServerAliveInterval=15 $USERNAME@$REMOTE_HOST:$REMOTE_DIR $LOCAL_MOUNT

# Mount işleminin başarılı olup olmadığını kontrol et
if mount | grep "$LOCAL_MOUNT" > /dev/null; then
    echo "$LOCAL_MOUNT başarıyla mount edildi."
else
    echo "Mount işlemi başarısız. İşlem sonlandırılıyor."
    exit 1
fi

# Restore işlemini başlat
echo "Mount başarılı, restore işlemi başlatılıyor..."
sudo /usr/sbin/ocs-sr -g auto -e1 auto -e2 -r -j2 -p true restoredisk LL-Windows11 sda

# Restore işlemi tamamlanınca mesaj yaz
echo "Restore işlemi tamamlandı."

# 10 saniye bekleyip yeniden başlatma işlemi yap
echo "Sistem 10 saniye içinde yeniden başlatılacak..."
sleep 10
sudo reboot
