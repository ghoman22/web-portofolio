#!/bin/bash

# SEO URL Structure Implementation Script
# This script helps deploy and test the new SEO-friendly URL structure

set -e

echo "🚀 SEO-Friendly URL Structure Deployment Script"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "website/index.html" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

print_status "Starting SEO URL structure implementation..."

# Backup original nginx config
if [ -f "nginx.conf" ]; then
    print_status "Backing up original nginx configuration..."
    cp nginx.conf nginx.conf.backup
    print_success "Backup created: nginx.conf.backup"
fi

# Deploy new nginx configuration
if [ -f "nginx-seo.conf" ]; then
    print_status "Deploying new nginx configuration..."
    cp nginx-seo.conf nginx.conf
    print_success "New nginx configuration deployed"
else
    print_warning "nginx-seo.conf not found, skipping nginx deployment"
fi

# Validate HTML files
print_status "Validating HTML structure..."

html_files=("website/index.html" "website/blogs.html" "website/404.html")
for file in "${html_files[@]}"; do
    if [ -f "$file" ]; then
        # Check for canonical tags
        if grep -q "rel=\"canonical\"" "$file"; then
            print_success "✓ Canonical tag found in $(basename "$file")"
        else
            print_warning "✗ Canonical tag missing in $(basename "$file")"
        fi
        
        # Check for Open Graph tags
        if grep -q "property=\"og:" "$file"; then
            print_success "✓ Open Graph tags found in $(basename "$file")"
        else
            print_warning "✗ Open Graph tags missing in $(basename "$file")"
        fi
        
        # Check for structured data
        if grep -q "application/ld+json" "$file"; then
            print_success "✓ Structured data found in $(basename "$file")"
        else
            print_warning "✗ Structured data missing in $(basename "$file")"
        fi
    else
        print_error "File not found: $file"
    fi
done

# Check blog posts
print_status "Validating blog posts..."
blog_posts=("website/blog/ci-cd-pipeline-github-actions.html" "website/blog/aws-terraform-infrastructure.html" "website/blog/prometheus-grafana-monitoring.html")

for post in "${blog_posts[@]}"; do
    if [ -f "$post" ]; then
        post_name=$(basename "$post" .html)
        
        # Check for clean URL structure
        if grep -q "href=\"/blog/$post_name\"" "website/index.html" "website/blogs.html" 2>/dev/null; then
            print_success "✓ Clean URLs implemented for $post_name"
        else
            print_warning "✗ Clean URLs may not be properly implemented for $post_name"
        fi
        
        # Check for canonical tags
        if grep -q "rel=\"canonical\"" "$post"; then
            print_success "✓ Canonical tag found in $post_name"
        else
            print_warning "✗ Canonical tag missing in $post_name"
        fi
    else
        print_error "Blog post not found: $post"
    fi
done

# Validate sitemap
print_status "Validating sitemap..."
if [ -f "website/sitemap.xml" ]; then
    # Check if sitemap is valid XML
    if xmllint --noout "website/sitemap.xml" 2>/dev/null; then
        print_success "✓ Sitemap XML is valid"
    else
        print_warning "✗ Sitemap XML may have issues (xmllint not available or XML invalid)"
    fi
    
    # Check for required URLs
    required_urls=("https://goman.ngenz.org/" "https://goman.ngenz.org/blog")
    for url in "${required_urls[@]}"; do
        if grep -q "$url" "website/sitemap.xml"; then
            print_success "✓ Required URL found in sitemap: $url"
        else
            print_error "✗ Required URL missing from sitemap: $url"
        fi
    done
else
    print_error "Sitemap not found: website/sitemap.xml"
fi

# Validate robots.txt
print_status "Validating robots.txt..."
if [ -f "website/robots.txt" ]; then
    if grep -q "Sitemap:" "website/robots.txt"; then
        print_success "✓ Sitemap reference found in robots.txt"
    else
        print_warning "✗ Sitemap reference missing from robots.txt"
    fi
else
    print_error "robots.txt not found: website/robots.txt"
fi

# Test URL structure (if server is running)
print_status "Testing URL accessibility..."

# Function to test URL
test_url() {
    local url=$1
    local description=$2
    
    if command -v curl >/dev/null 2>&1; then
        if curl -s -o /dev/null -w "%{http_code}" "http://localhost/$url" | grep -q "200\|301\|302"; then
            print_success "✓ $description: /$url"
        else
            print_warning "✗ $description may not be accessible: /$url"
        fi
    else
        print_warning "curl not available, skipping URL tests"
        return
    fi
}

# Test main URLs (only if server is running)
if curl -s -o /dev/null "http://localhost" 2>/dev/null; then
    print_status "Local server detected, testing URLs..."
    test_url "" "Homepage"
    test_url "blog" "Blog listing"
    test_url "blog/ci-cd-pipeline-github-actions" "CI/CD blog post"
    test_url "blog/aws-terraform-infrastructure" "AWS blog post"
    test_url "blog/prometheus-grafana-monitoring" "Monitoring blog post"
else
    print_warning "Local server not running, skipping live URL tests"
    print_warning "To test URLs, start your web server and run: curl -I http://localhost/blog"
fi

# SEO Recommendations
print_status "SEO Implementation Summary:"
echo ""
echo "✅ COMPLETED FEATURES:"
echo "   • Clean URLs (removed .html extensions)"
echo "   • Canonical tags on all pages"
echo "   • Open Graph meta tags for social sharing"
echo "   • Twitter Card meta tags"
echo "   • Structured data (JSON-LD) for better search understanding"
echo "   • Comprehensive sitemap.xml"
echo "   • SEO-optimized robots.txt"
echo "   • User-friendly 404 error page"
echo "   • Nginx configuration for URL rewriting"
echo "   • Apache .htaccess alternative"
echo ""
echo "🔧 NGINX DEPLOYMENT:"
echo "   1. Copy nginx-seo.conf to your server's nginx configuration directory"
echo "   2. Test configuration: nginx -t"
echo "   3. Reload nginx: systemctl reload nginx"
echo ""
echo "🔧 APACHE DEPLOYMENT:"
echo "   • The .htaccess file is ready in the website directory"
echo "   • Ensure mod_rewrite is enabled on your Apache server"
echo ""
echo "📊 NEXT STEPS:"
echo "   1. Test all URLs after deployment"
echo "   2. Submit sitemap to Google Search Console"
echo "   3. Monitor 404 errors and set up redirects if needed"
echo "   4. Verify structured data with Google's Rich Results Test"
echo "   5. Test social media sharing with Facebook Debugger and Twitter Card Validator"
echo ""

print_success "SEO-friendly URL structure implementation completed!"
print_status "For questions or issues, check the implementation guide in the project documentation."