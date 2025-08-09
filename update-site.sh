#!/bin/bash
set -e

echo "🔄 Updating Portfolio Website"
echo "============================"

# Update website files
echo "📁 Updating website files..."
sudo cp -r website/* /var/www/portfolio/
sudo chown -R www-data:www-data /var/www/portfolio

# Update nginx config jika ada perubahan
echo "⚙️ Checking nginx configuration..."
if [ -f nginx-seo.conf ]; then
    if ! sudo diff -q nginx-seo.conf /etc/nginx/sites-available/portfolio >/dev/null 2>&1; then
        echo "🔧 Updating nginx configuration..."
        sudo cp nginx-seo.conf /etc/nginx/sites-available/portfolio
        
        # Test config
        if sudo nginx -t; then
            echo "🔄 Reloading nginx..."
            sudo systemctl reload nginx
            echo "✅ Nginx updated successfully"
        else
            echo "❌ Nginx config test failed!"
            exit 1
        fi
    else
        echo "✅ Nginx config up to date"
    fi
elif [ -f nginx.conf ]; then
    if ! sudo diff -q nginx.conf /etc/nginx/sites-available/portfolio >/dev/null 2>&1; then
        echo "🔧 Updating nginx configuration..."
        sudo cp nginx.conf /etc/nginx/sites-available/portfolio
        sudo nginx -t && sudo systemctl reload nginx
        echo "✅ Nginx updated"
    else
        echo "✅ Nginx config up to date"
    fi
fi

echo ""
echo "✅ Website updated successfully!"
echo "🌐 Changes are live at: http://$(hostname -I | awk '{print $1}')"