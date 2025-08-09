#!/bin/bash

# Favicon Generation Script for Firman Arya Portfolio
# This script generates favicon files in multiple formats and sizes

set -e

echo "🎨 Favicon Generation Script"
echo "=========================="

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

# Check if ImageMagick is installed
if ! command -v convert >/dev/null 2>&1; then
    print_error "ImageMagick is not installed. Please install it first:"
    echo "  Ubuntu/Debian: sudo apt-get install imagemagick"
    echo "  macOS: brew install imagemagick"
    echo "  Windows: Download from https://imagemagick.org/script/download.php"
    exit 1
fi

# Create favicon directory
mkdir -p website/favicons

print_status "Generating favicon files..."

# Check if a custom logo exists
LOGO_FILE=""
for ext in svg png jpg jpeg; do
    if [ -f "logo.$ext" ] || [ -f "website/logo.$ext" ]; then
        LOGO_FILE=$(find . -name "logo.$ext" | head -1)
        break
    fi
done

if [ -n "$LOGO_FILE" ]; then
    print_status "Using custom logo file: $LOGO_FILE"
    SOURCE_IMAGE="$LOGO_FILE"
else
    print_warning "No custom logo found. Generating a brand-based favicon..."
    
    # Create a temporary SVG logo based on the brand colors
    cat > temp_logo.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
  <defs>
    <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#00d4ff;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0099cc;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Background circle -->
  <circle cx="256" cy="256" r="240" fill="url(#gradient)" stroke="#ffffff" stroke-width="8"/>
  
  <!-- Code symbol (inspired by fa-code icon) -->
  <g fill="#ffffff" transform="translate(256,256)">
    <!-- Left bracket -->
    <path d="M-80,-60 L-120,-20 L-120,20 L-80,60 L-60,40 L-80,20 L-80,-20 L-60,-40 Z"/>
    
    <!-- Right bracket -->
    <path d="M80,-60 L60,-40 L80,-20 L80,20 L60,40 L80,60 L120,20 L120,-20 Z"/>
    
    <!-- Center letters "FA" -->
    <text x="-20" y="15" font-family="Arial, sans-serif" font-size="80" font-weight="bold" text-anchor="middle">FA</text>
  </g>
</svg>
EOF
    SOURCE_IMAGE="temp_logo.svg"
fi

# Generate different sizes and formats
print_status "Generating favicon.ico (multiple sizes)..."
convert "$SOURCE_IMAGE" -resize 16x16 -colors 256 website/favicons/favicon-16.png
convert "$SOURCE_IMAGE" -resize 32x32 -colors 256 website/favicons/favicon-32.png
convert "$SOURCE_IMAGE" -resize 48x48 -colors 256 website/favicons/favicon-48.png
convert website/favicons/favicon-16.png website/favicons/favicon-32.png website/favicons/favicon-48.png website/favicon.ico

print_status "Generating PNG favicons..."
convert "$SOURCE_IMAGE" -resize 192x192 website/favicons/favicon-192.png
convert "$SOURCE_IMAGE" -resize 512x512 website/favicons/favicon-512.png

print_status "Generating Apple Touch Icons..."
convert "$SOURCE_IMAGE" -resize 180x180 website/favicons/apple-touch-icon.png
convert "$SOURCE_IMAGE" -resize 152x152 website/favicons/apple-touch-icon-152.png
convert "$SOURCE_IMAGE" -resize 120x120 website/favicons/apple-touch-icon-120.png
convert "$SOURCE_IMAGE" -resize 76x76 website/favicons/apple-touch-icon-76.png

print_status "Generating Android Chrome Icons..."
convert "$SOURCE_IMAGE" -resize 192x192 website/favicons/android-chrome-192x192.png
convert "$SOURCE_IMAGE" -resize 512x512 website/favicons/android-chrome-512x512.png

print_status "Generating Microsoft Icons..."
convert "$SOURCE_IMAGE" -resize 144x144 website/favicons/mstile-144x144.png
convert "$SOURCE_IMAGE" -resize 150x150 website/favicons/mstile-150x150.png

# Clean up temporary file
if [ -f "temp_logo.svg" ]; then
    rm temp_logo.svg
fi

# Generate Web App Manifest
print_status "Generating web app manifest..."
cat > website/favicons/site.webmanifest << EOF
{
    "name": "Firman Arya - DevOps Engineer",
    "short_name": "Firman Arya",
    "description": "DevOps Engineer specializing in AWS, Kubernetes, CI/CD pipelines, and automation",
    "icons": [
        {
            "src": "/favicons/android-chrome-192x192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "/favicons/android-chrome-512x512.png",
            "sizes": "512x512",
            "type": "image/png"
        }
    ],
    "theme_color": "#00d4ff",
    "background_color": "#1a1a1a",
    "display": "standalone",
    "start_url": "/",
    "scope": "/"
}
EOF

# Generate browserconfig.xml for Microsoft
print_status "Generating browserconfig.xml..."
cat > website/favicons/browserconfig.xml << EOF
<?xml version="1.0" encoding="utf-8"?>
<browserconfig>
    <msapplication>
        <tile>
            <square150x150logo src="/favicons/mstile-150x150.png"/>
            <TileColor>#00d4ff</TileColor>
        </tile>
    </msapplication>
</browserconfig>
EOF

print_success "Favicon generation completed!"
echo ""
print_status "Generated files:"
echo "  • website/favicon.ico (16x16, 32x32, 48x48)"
echo "  • website/favicons/favicon-192.png"
echo "  • website/favicons/favicon-512.png"
echo "  • website/favicons/apple-touch-icon.png (180x180)"
echo "  • website/favicons/android-chrome-*.png"
echo "  • website/favicons/site.webmanifest"
echo "  • website/favicons/browserconfig.xml"
echo ""
print_status "Next steps:"
echo "  1. Run ./update-favicon-links.sh to update HTML files"
echo "  2. Test on different browsers and devices"
echo "  3. Clear browser cache to see changes"
echo ""
print_warning "If you have a custom logo, place it as 'logo.svg' or 'logo.png' and run this script again."