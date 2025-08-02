#!/bin/bash
set -e

# Update dan install Nginx
sudo apt update
sudo apt install -y nginx

# Buat folder website dan salin file
sudo mkdir -p /var/www/portfolio
sudo cp -r website/* /var/www/portfolio/

# Ubah kepemilikan
sudo chown -R www-data:www-data /var/www/portfolio

# Salin konfigurasi nginx
if [ ! -f /etc/nginx/sites-available/portfolio ]; then
echo "⚙️ Copying nginx.conf to /etc/nginx/sites-available/portfolio..."
sudo cp nginx.conf /etc/nginx/sites-available/portfolio
else
echo "⚠️ nginx.conf sudah ada di server, tidak di-overwrite."
fi
if [ ! -L /etc/nginx/sites-enabled/portfolio ]; then
    sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
else
    echo "Symlink /etc/nginx/sites-enabled/portfolio already exists, skipping..."
fi


# Hapus default jika ada
sudo rm -f /etc/nginx/sites-enabled/default

# Restart nginx
sudo systemctl restart nginx
