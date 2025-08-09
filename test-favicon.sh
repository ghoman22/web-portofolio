#!/bin/bash

# Favicon Testing and Validation Script
# Tests favicon implementation across different browsers and scenarios

set -e

echo "🧪 Favicon Testing and Validation"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if files exist
print_status "Checking favicon files..."

required_files=(
    "website/favicon.ico"
    "website/favicons/favicon-192.png"
    "website/favicons/favicon-512.png"
    "website/favicons/apple-touch-icon.png"
    "website/favicons/android-chrome-192x192.png"
    "website/favicons/android-chrome-512x512.png"
    "website/favicons/site.webmanifest"
    "website/favicons/browserconfig.xml"
)

missing_files=()
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        print_success "✓ Found: $file"
    else
        print_error "✗ Missing: $file"
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    print_warning "Some favicon files are missing. Run ./generate-favicon.sh first."
fi

# Validate HTML files
print_status "Validating HTML favicon implementation..."

html_files=(
    "website/index.html"
    "website/blogs.html" 
    "website/404.html"
    "website/blog/ci-cd-pipeline-github-actions.html"
    "website/blog/aws-terraform-infrastructure.html"
    "website/blog/prometheus-grafana-monitoring.html"
)

for file in "${html_files[@]}"; do
    if [ -f "$file" ]; then
        print_status "Checking $file..."
        
        # Check for basic favicon
        if grep -q 'rel="icon"' "$file"; then
            print_success "  ✓ Basic favicon link found"
        else
            print_error "  ✗ Basic favicon link missing"
        fi
        
        # Check for Apple touch icon
        if grep -q 'rel="apple-touch-icon"' "$file"; then
            print_success "  ✓ Apple touch icon found"
        else
            print_error "  ✗ Apple touch icon missing"
        fi
        
        # Check for web manifest
        if grep -q 'rel="manifest"' "$file"; then
            print_success "  ✓ Web manifest link found"
        else
            print_error "  ✗ Web manifest link missing"
        fi
        
        # Check for theme color
        if grep -q 'name="theme-color"' "$file"; then
            print_success "  ✓ Theme color meta tag found"
        else
            print_error "  ✗ Theme color meta tag missing"
        fi
        
    else
        print_warning "File not found: $file"
    fi
    echo ""
done

# File size optimization check
print_status "Checking file sizes for optimization..."

check_file_size() {
    local file=$1
    local max_size=$2
    
    if [ -f "$file" ]; then
        local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
        local size_kb=$((size / 1024))
        
        if [ $size_kb -le $max_size ]; then
            print_success "✓ $file: ${size_kb}KB (optimal)"
        elif [ $size_kb -le $((max_size * 2)) ]; then
            print_warning "⚠ $file: ${size_kb}KB (could be optimized)"
        else
            print_error "✗ $file: ${size_kb}KB (too large, should be ≤${max_size}KB)"
        fi
    fi
}

# Check sizes (recommendations: ico ≤10KB, small PNGs ≤5KB, large PNGs ≤20KB)
check_file_size "website/favicon.ico" 10
check_file_size "website/favicons/favicon-192.png" 5
check_file_size "website/favicons/favicon-512.png" 20
check_file_size "website/favicons/apple-touch-icon.png" 10

# Validate web manifest
print_status "Validating web manifest..."
if [ -f "website/favicons/site.webmanifest" ]; then
    if python3 -m json.tool "website/favicons/site.webmanifest" > /dev/null 2>&1; then
        print_success "✓ Web manifest JSON is valid"
    else
        print_error "✗ Web manifest JSON is invalid"
    fi
else
    print_error "✗ Web manifest file missing"
fi

# Browser compatibility guide
echo ""
print_status "Browser Compatibility Guide:"
echo ""
echo "📱 MOBILE TESTING:"
echo "  • iOS Safari: Look for apple-touch-icon on home screen"
echo "  • Android Chrome: Check favicon in tabs and home screen shortcuts"
echo "  • Mobile Firefox: Verify favicon appears in address bar"
echo ""
echo "🖥️  DESKTOP TESTING:"
echo "  • Chrome: Check favicon in tabs, bookmarks, and history"
echo "  • Firefox: Verify favicon in tabs and bookmarks"
echo "  • Safari: Check favicon in tabs and Top Sites"
echo "  • Edge: Verify favicon in tabs and favorites"
echo ""
echo "🎨 THEME COMPATIBILITY:"
echo "  • Test in browser dark mode"
echo "  • Test in browser light mode"
echo "  • Verify favicon visibility on different tab states"
echo ""

# Cache clearing instructions
print_status "Cache Clearing Instructions:"
echo ""
echo "🔄 BROWSER CACHE:"
echo "  • Chrome: F12 → Network tab → Disable cache, then Ctrl+Shift+R"
echo "  • Firefox: F12 → Network tab → Settings ⚙️ → Disable cache, then Ctrl+F5"
echo "  • Safari: Develop menu → Empty Caches, then Cmd+Shift+R"
echo "  • Edge: F12 → Network tab → Clear browser cache, then Ctrl+Shift+R"
echo ""
echo "🌐 CDN/SERVER CACHE:"
echo "  • CloudFlare: Purge cache for favicon files specifically"
echo "  • Nginx: Clear proxy cache if applicable"
echo "  • Apache: Clear mod_cache if enabled"
echo ""

# Performance optimization tips
print_status "Performance Optimization Tips:"
echo ""
echo "📈 OPTIMIZATION:"
echo "  • Use SVG for scalable favicons when possible"
echo "  • Compress PNG files with tools like ImageOptim or TinyPNG"
echo "  • Test loading speed with browser dev tools"
echo "  • Consider using a single SVG favicon for modern browsers"
echo ""

# Testing URLs
if command -v curl >/dev/null 2>&1; then
    print_status "Testing favicon accessibility..."
    
    test_urls=(
        "favicon.ico"
        "favicons/favicon-192.png"
        "favicons/apple-touch-icon.png"
        "favicons/site.webmanifest"
    )
    
    for url in "${test_urls[@]}"; do
        if curl -s -o /dev/null -w "%{http_code}" "http://localhost/$url" 2>/dev/null | grep -q "200"; then
            print_success "✓ $url is accessible"
        else
            print_warning "⚠ $url may not be accessible (check if server is running)"
        fi
    done
else
    print_warning "curl not available, skipping accessibility tests"
fi

echo ""
print_success "Favicon testing completed!"
print_status "Remember to test on actual devices and browsers for the best validation."