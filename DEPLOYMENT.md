# EC2 Deployment Setup Guide

This guide will help you deploy your portfolio website to AWS EC2 with automatic CI/CD using GitHub Actions and SSL certificate setup.

## Prerequisites

1. **AWS EC2 Instance**: Ubuntu 20.04 or later
2. **Domain Name**: Pointing to your EC2 instance IP
3. **GitHub Repository**: With your portfolio code
4. **SSH Access**: To your EC2 instance

## Quick Setup

### 1. Prepare Your EC2 Instance

Make sure your EC2 instance has:
- Ubuntu 20.04+ installed
- SSH access configured
- Security groups allowing HTTP (80), HTTPS (443), and SSH (22)

### 2. Configure GitHub Secrets

In your GitHub repository, go to `Settings > Secrets and variables > Actions` and add:

```
EC2_HOST = your-ec2-ip-address-or-domain
EC2_USER = ubuntu (or your EC2 username)
EC2_SSH_KEY = your-private-ssh-key-content
```

**To get your SSH key:**
```bash
# If you don't have an SSH key pair, generate one:
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

# Copy your private key content:
cat ~/.ssh/id_rsa
# Copy the ENTIRE content including -----BEGIN and -----END lines
```

**Add your public key to EC2:**
```bash
# Copy your public key to EC2
ssh-copy-id ubuntu@your-ec2-ip
# OR manually add to ~/.ssh/authorized_keys on EC2
```

### 3. Update Configuration

**Important**: Edit the following files before deploying:

1. **install.sh** (line 72): Update email address for SSL certificate:
   ```bash
   --email your-actual-email@example.com
   ```

2. **nginx-ssl.conf** (line 3): Update domain names if different:
   ```nginx
   server_name your-domain.com www.your-domain.com;
   ```

### 4. Deploy

1. **Initial Manual Deployment** (recommended first time):
   ```bash
   # SSH to your EC2 instance
   ssh ubuntu@your-ec2-ip
   
   # Clone your repository
   git clone https://github.com/yourusername/web-portofolio.git
   cd web-portofolio
   
   # Make install script executable and run
   chmod +x install.sh
   sudo ./install.sh
   ```

2. **Automatic Deployment**: Push to main/master branch
   ```bash
   git add .
   git commit -m "Deploy to EC2"
   git push origin main
   ```

## Files Created/Modified

### `.github/workflows/deploy.yml`
- GitHub Actions workflow for automatic deployment
- Triggers on push to main/master branch
- Handles SSH connection and deployment execution

### `install.sh` (Enhanced)
- Complete server setup script
- Installs nginx, certbot, configures firewall
- Sets up SSL certificate automatically
- Configures automatic SSL renewal

### `nginx-ssl.conf`
- SSL-ready nginx configuration
- Includes security headers and optimizations
- Handles clean URLs and redirects
- Enables gzip compression

## SSL Certificate

The script automatically:
1. Installs Let's Encrypt certbot
2. Requests SSL certificate for your domain
3. Configures automatic renewal
4. Sets up HTTPS redirect

**Manual SSL setup** (if needed):
```bash
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

## Firewall Configuration

The script configures UFW firewall to allow:
- SSH (22)
- HTTP (80)
- HTTPS (443)
- Nginx Full profile

## Monitoring & Maintenance

### Check SSL Certificate Status
```bash
sudo certbot certificates
```

### Check Nginx Status
```bash
sudo systemctl status nginx
sudo nginx -t  # Test configuration
```

### View Logs
```bash
# Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Certbot logs
sudo tail -f /var/log/letsencrypt/letsencrypt.log
```

### Manual SSL Renewal Test
```bash
sudo certbot renew --dry-run
```

## Troubleshooting

### Common Issues

1. **SSL Certificate Failed**:
   - Ensure domain DNS points to your EC2 IP
   - Check if ports 80 and 443 are open
   - Verify domain is accessible via HTTP first

2. **GitHub Actions Deployment Failed**:
   - Check GitHub secrets are set correctly
   - Verify SSH key has proper permissions
   - Ensure EC2 user has sudo privileges

3. **Website Not Accessible**:
   - Check nginx status: `sudo systemctl status nginx`
   - Verify firewall: `sudo ufw status`
   - Check nginx configuration: `sudo nginx -t`

### Security Notes

- SSH keys are used for secure deployment
- Firewall is configured to allow only necessary ports
- SSL certificates are automatically renewed
- Security headers are added to nginx configuration

## Domain Setup

Make sure your domain's DNS records point to your EC2 instance:
```
A record: yourdomain.com → your-ec2-ip
CNAME: www.yourdomain.com → yourdomain.com
```

## Cost Optimization

- Consider using AWS Application Load Balancer for SSL termination
- Use CloudFront CDN for better performance
- Set up monitoring with CloudWatch

---

**Need Help?** Check the GitHub Actions logs for deployment details and error messages.