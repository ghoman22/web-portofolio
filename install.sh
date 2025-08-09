#!/bin/bash
set -e

echo "🚀 Deploying Firman Arya Portfolio Website"
echo "========================================="

# Update dan install Nginx
echo "📦 Installing Nginx..."
sudo apt update
sudo apt install -y nginx

# Buat folder website dan salin file
echo "📁 Copying website files..."
sudo mkdir -p /var/www/portfolio
sudo cp -r website/* /var/www/portfolio/

# Ubah kepemilikan
sudo chown -R www-data:www-data /var/www/portfolio

# Salin konfigurasi nginx (prioritas: nginx-seo.conf, fallback: nginx.conf)
echo "⚙️ Configuring Nginx..."
if [ -f nginx-seo.conf ]; then
    echo "✅ Using SEO-optimized nginx configuration..."
    sudo cp nginx-seo.conf /etc/nginx/sites-available/portfolio
elif [ -f nginx.conf ]; then
    echo "📝 Using standard nginx configuration..."
    sudo cp nginx.conf /etc/nginx/sites-available/portfolio
else
    echo "❌ Error: No nginx configuration file found!"
    exit 1
fi

# Enable site
if [ ! -L /etc/nginx/sites-enabled/portfolio ]; then
    sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
    echo "🔗 Enabled portfolio site"
else
    echo "✅ Portfolio site already enabled"
fi

# Hapus default jika ada
sudo rm -f /etc/nginx/sites-enabled/default

# Test nginx config
echo "🧪 Testing Nginx configuration..."
sudo nginx -t

# Restart nginx
echo "🔄 Restarting Nginx..."
sudo systemctl restart nginx

echo ""
echo "✅ Deployment completed successfully!"
echo "🌐 Website should be accessible at: http://$(hostname -I | awk '{print $1}')"
echo "📊 SEO features enabled: Clean URLs, Favicon, Structured Data"
echo ""
