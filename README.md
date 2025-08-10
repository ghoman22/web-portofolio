# Firman Arya - Portfolio & Blog

A modern, responsive portfolio website for a DevOps Engineer featuring clean URLs, automated CI/CD content, and comprehensive blog functionality.

## 🌟 Features

- **Clean URL Structure**: SEO-friendly URLs without .html extensions
- **Responsive Design**: Optimized for all devices and screen sizes
- **Modern Favicon Support**: SVG favicon with PNG fallbacks
- **Blog System**: Dedicated blog listing and individual post pages
- **Automated Redirects**: Seamless migration from old hash-based URLs
- **Performance Optimized**: Fast loading with modern web standards

## 🔗 URL Structure

### Clean URLs (New)
- **Home**: `/`
- **About**: `/about`
- **Skills**: `/skills`
- **Blogs**: `/blogs`
- **Contact**: `/contact`
- **Blog Posts**: `/blog/{slug}`

### Legacy URL Redirects
The following old URLs automatically redirect to new clean URLs:
- `index.html#about` → `/about`
- `index.html#skills` → `/skills`
- `index.html#contact` → `/contact`
- `index.html#projects` → `/blogs`
- `blogs.html` → `/blogs`
- `blog/*.html` → `/blog/*`

## 🚀 Deployment

### Prerequisites
- Nginx web server
- Modern web browser support

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd web-portofolio

# Copy files to web server
sudo cp -r website/* /var/www/portfolio/

# Update nginx configuration
sudo cp nginx.conf /etc/nginx/sites-available/portfolio
sudo ln -sf /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

### Manual Installation (Alternative)
```bash
chmod +x install.sh
./install.sh
```

## 📱 Favicon Support

The site includes modern favicon support:
- `favicon.svg` - Modern vector favicon
- `favicon-32x32.png` - 32×32 PNG fallback
- `apple-touch-icon.png` - 180×180 Apple touch icon

## 🛠 Technology Stack

- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Icons**: Font Awesome 6
- **Fonts**: Google Fonts (Poppins, Fira Code)
- **Server**: Nginx with clean URL routing
- **Animations**: CSS animations with Intersection Observer API

## 📂 Project Structure

```
website/
├── index.html              # Homepage
├── about.html              # About page
├── skills.html             # Skills page
├── contact.html            # Contact page
├── blogs.html              # Blog listing page
├── blog/                   # Individual blog posts
│   ├── ci-cd-pipeline-github-actions.html
│   ├── aws-terraform-infrastructure.html
│   └── prometheus-grafana-monitoring.html
├── styles.css              # Main stylesheet
├── script.js               # Main JavaScript
├── blog-listing.js         # Blog listing functionality
├── favicon.svg             # Modern SVG favicon
├── favicon-32x32.png       # PNG favicon fallback
└── apple-touch-icon.png    # Apple touch icon
```

## 🔧 Configuration

### Nginx Configuration
The included `nginx.conf` provides:
- Clean URL routing
- Automatic redirects from legacy URLs
- Security headers
- Favicon handling
- 404 error handling

### Navigation Active States
The JavaScript automatically handles active navigation states for:
- Clean URL pages
- Blog post pages (highlights "Blogs" nav)
- Hash-based navigation (for single-page sections)

## 🎨 Customization

### Adding New Pages
1. Create a new HTML file (e.g., `services.html`)
2. Add navigation link in all header sections
3. Update nginx configuration with new route:
   ```nginx
   location = /services {
       try_files /services.html /services.html;
   }
   ```
4. Add redirect for old URL if needed

### Adding New Blog Posts
1. Create HTML file in `/blog/` directory
2. Follow naming convention: `slug-name.html`
3. Add to blog listing in `blogs.html`
4. URLs will automatically work as `/blog/slug-name`

## 📊 SEO Features

- Clean, descriptive URLs
- Proper meta tags and descriptions
- Semantic HTML structure
- Fast loading times
- Mobile-responsive design
- Accessibility features

## 🔍 Testing

Test the URL structure:
```bash
# Test clean URLs
curl -I http://localhost/about
curl -I http://localhost/blogs
curl -I http://localhost/blog/ci-cd-pipeline-github-actions

# Test redirects
curl -I http://localhost/about.html
curl -I http://localhost/blogs.html
```

## 📝 License

© 2025 Firman Arya. All rights reserved.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

---

Built with ❤️ by Firman Arya - DevOps Engineer