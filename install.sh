#!/bin/bash
set -e

echo "🚀 Starting portfolio deployment with SSL..."

# Update system packages
echo "📦 Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install required packages
echo "🔧 Installing required packages..."
sudo apt install -y nginx certbot python3-certbot-nginx ufw

# Configure firewall
echo "🔥 Configuring firewall..."
sudo ufw --force enable
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443

# Create website directory and copy files
echo "📁 Setting up website files..."
sudo mkdir -p /var/www/portfolio
sudo cp -r website/* /var/www/portfolio/

# Set proper permissions
sudo chown -R www-data:www-data /var/www/portfolio
sudo chmod -R 755 /var/www/portfolio

# Backup existing nginx config if exists
if [ -f /etc/nginx/sites-available/portfolio ]; then
    echo "💾 Backing up existing nginx config..."
    sudo cp /etc/nginx/sites-available/portfolio /etc/nginx/sites-available/portfolio.backup.$(date +%Y%m%d_%H%M%S)
fi

# Copy nginx configuration
echo "⚙️ Setting up nginx configuration..."
sudo cp nginx-ssl.conf /etc/nginx/sites-available/portfolio

# Enable site
if [ ! -L /etc/nginx/sites-enabled/portfolio ]; then
    sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
else
    echo "📝 Portfolio site already enabled"
fi

# Remove default nginx site
sudo rm -f /etc/nginx/sites-enabled/default

# Test nginx configuration
echo "🧪 Testing nginx configuration..."
sudo nginx -t

# Restart nginx
echo "🔄 Restarting nginx..."
sudo systemctl restart nginx
sudo systemctl enable nginx

# Setup SSL with Let's Encrypt
echo "🔒 Setting up SSL certificate..."

# Check if SSL is already configured
if sudo certbot certificates 2>/dev/null | grep -q "goman.ngenz.org"; then
    echo "📜 SSL certificate already exists, renewing if necessary..."
    sudo certbot renew --quiet
else
    echo "🆕 Creating new SSL certificate..."
    # Request SSL certificate
    sudo certbot --nginx -d goman.ngenz.org -d www.goman.ngenz.org --non-interactive --agree-tos --email firmanap22@gmail.com --redirect
fi

# Setup automatic renewal
echo "⏰ Setting up automatic SSL renewal..."
sudo systemctl status certbot.timer >/dev/null 2>&1 || sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer

# Create SSL renewal test
(crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | sudo crontab -

# Final nginx restart to ensure SSL is working
sudo systemctl reload nginx

# Display status
echo ""
echo "✅ Deployment completed successfully!"
echo "🌐 Your website should be accessible at:"
echo "   • http://goman.ngenz.org (redirects to HTTPS)"
echo "   • https://goman.ngenz.org"
echo "   • https://www.goman.ngenz.org"
echo ""
echo "🔒 SSL certificate status:"
sudo certbot certificates 2>/dev/null || echo "❌ No certificates found"
echo ""
echo "📊 Nginx status:"
sudo systemctl status nginx --no-pager -l
echo ""
echo "🔥 Firewall status:"
sudo ufw status
echo ""
echo "⚠️  Important reminders:"
echo "   1. Update the email in certbot command (line 54) to your actual email"
echo "   2. Ensure your domain DNS points to this server's IP"
echo "   3. SSL certificate will auto-renew every 12 hours"
echo ""