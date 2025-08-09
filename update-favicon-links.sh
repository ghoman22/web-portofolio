#!/bin/bash

# Update Favicon Links Script
# Updates all HTML files with comprehensive favicon implementation

set -e

echo "🔗 Updating Favicon Links in HTML Files"
echo "======================================"

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

# Define the comprehensive favicon HTML block
FAVICON_BLOCK='    <!-- Favicon and Icons -->
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32.png">
    <link rel="icon" type="image/png" sizes="192x192" href="/favicons/favicon-192.png">
    <link rel="icon" type="image/png" sizes="512x512" href="/favicons/favicon-512.png">
    
    <!-- Apple Touch Icons -->
    <link rel="apple-touch-icon" href="/favicons/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="152x152" href="/favicons/apple-touch-icon-152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon.png">
    
    <!-- Web App Manifest -->
    <link rel="manifest" href="/favicons/site.webmanifest">
    
    <!-- Microsoft Tiles -->
    <meta name="msapplication-TileColor" content="#00d4ff">
    <meta name="msapplication-config" content="/favicons/browserconfig.xml">
    
    <!-- Theme Color -->
    <meta name="theme-color" content="#00d4ff">'

# Function to update favicon links in a file
update_favicon_links() {
    local file=$1
    local backup_file="${file}.backup"
    
    print_status "Updating $file..."
    
    # Create backup
    cp "$file" "$backup_file"
    
    # Remove existing favicon/icon lines
    sed -i.tmp '
        /<!-- Favicon and Icons -->/,/<!-- Theme Color -->/d
        /<link rel="icon"/d
        /<link rel="apple-touch-icon"/d
        /<link rel="manifest"/d
        /<meta name="msapplication"/d
        /<meta name="theme-color"/d
    ' "$file"
    
    # Find the position to insert favicon block (after meta charset/viewport)
    local insert_line=$(grep -n "<meta name=\"viewport\"" "$file" | cut -d: -f1)
    if [ -n "$insert_line" ]; then
        # Insert after viewport meta tag
        insert_line=$((insert_line + 1))
        
        # Create a temporary file with the favicon block inserted
        head -n "$insert_line" "$file" > temp_file
        echo "" >> temp_file
        echo "$FAVICON_BLOCK" >> temp_file
        echo "" >> temp_file
        tail -n +$((insert_line + 1)) "$file" >> temp_file
        
        mv temp_file "$file"
        print_success "✓ Updated favicon links in $file"
    else
        print_warning "Could not find viewport meta tag in $file"
        # Restore from backup
        mv "$backup_file" "$file"
    fi
    
    # Clean up
    rm -f "${file}.tmp"
}

# Update main HTML files
html_files=(
    "website/index.html"
    "website/blogs.html"
    "website/404.html"
)

for file in "${html_files[@]}"; do
    if [ -f "$file" ]; then
        update_favicon_links "$file"
    else
        print_warning "File not found: $file"
    fi
done

# Update blog posts
blog_posts=(
    "website/blog/ci-cd-pipeline-github-actions.html"
    "website/blog/aws-terraform-infrastructure.html"
    "website/blog/prometheus-grafana-monitoring.html"
)

for post in "${blog_posts[@]}"; do
    if [ -f "$post" ]; then
        # For blog posts, we need to adjust the paths to be relative
        local blog_favicon_block="${FAVICON_BLOCK//\/favicons\//..\/favicons\/}"
        blog_favicon_block="${blog_favicon_block//\/favicon.ico/..\/favicon.ico}"
        
        print_status "Updating $post with relative paths..."
        
        # Create backup
        cp "$post" "${post}.backup"
        
        # Remove existing favicon/icon lines
        sed -i.tmp '
            /<!-- Favicon and Icons -->/,/<!-- Theme Color -->/d
            /<link rel="icon"/d
            /<link rel="apple-touch-icon"/d
            /<link rel="manifest"/d
            /<meta name="msapplication"/d
            /<meta name="theme-color"/d
        ' "$post"
        
        # Find insertion point
        local insert_line=$(grep -n "<meta name=\"viewport\"" "$post" | cut -d: -f1)
        if [ -n "$insert_line" ]; then
            insert_line=$((insert_line + 1))
            
            head -n "$insert_line" "$post" > temp_file
            echo "" >> temp_file
            echo "$blog_favicon_block" >> temp_file
            echo "" >> temp_file
            tail -n +$((insert_line + 1)) "$post" >> temp_file
            
            mv temp_file "$post"
            print_success "✓ Updated favicon links in $post"
        else
            print_warning "Could not find viewport meta tag in $post"
            mv "${post}.backup" "$post"
        fi
        
        rm -f "${post}.tmp"
    else
        print_warning "Blog post not found: $post"
    fi
done

print_success "Favicon links updated in all HTML files!"
echo ""
print_status "Updated files:"
for file in "${html_files[@]}" "${blog_posts[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    fi
done

echo ""
print_status "Cache clearing recommendations:"
echo "  • Chrome: Ctrl+Shift+R (hard refresh)"
echo "  • Firefox: Ctrl+F5"
echo "  • Safari: Cmd+Shift+R"
echo "  • Clear browser data for complete cache reset"
echo ""
print_status "Testing checklist:"
echo "  • Test on Chrome, Firefox, Edge, Safari"
echo "  • Test on mobile devices"
echo "  • Check dark/light mode compatibility"
echo "  • Verify favicon appears in bookmarks"
echo "  • Test PWA install prompt (if applicable)"