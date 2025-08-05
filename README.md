# Firman Arya - Portfolio & Blog

A modern, responsive portfolio website with a fully functional blog system showcasing DevOps expertise and technical insights.

## Features

### 🏠 Homepage
- Modern dark theme with animated particles background
- Hero section with terminal animation
- Skills showcase with interactive cards
- Featured blog posts (3 latest posts)
- Contact section with social links

### 📝 Blog System
- **Blog Listing Page** (`/blogs.html`)
  - Search functionality across blog titles and content
  - Filter by technology tags (DevOps, AWS, Kubernetes, etc.)
  - Responsive grid layout
  - Publication dates and reading time estimates

- **Individual Blog Posts** (`/blog/*.html`)
  - Full-featured blog post layout
  - Code syntax highlighting
  - Reading time estimates
  - Social sharing buttons
  - "Back to Blogs" navigation
  - Author information

### 🎨 Design Features
- Consistent dark theme across all pages
- Responsive design (mobile-friendly)
- Smooth animations and hover effects
- Professional typography with Poppins and Fira Code fonts
- Glassmorphism effects and backdrop blur
- Custom favicon and branded page titles

## Blog Posts

### Featured Posts
1. **How I Built a CI/CD Pipeline Using GitHub Actions**
   - Complete GitHub Actions workflow
   - Docker containerization
   - Kubernetes deployment
   - Testing and security integration

2. **Deploying Infrastructure on AWS with Terraform**
   - Infrastructure as Code principles
   - AWS provider configuration
   - Security best practices
   - State management

3. **Monitoring 50+ Services with Prometheus & Grafana**
   - Prometheus configuration and metrics
   - Grafana dashboard design
   - AlertManager setup
   - Kubernetes monitoring

## Technical Stack

- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Styling**: Custom CSS with CSS Grid and Flexbox
- **Icons**: Font Awesome 6.0
- **Fonts**: Google Fonts (Poppins, Fira Code)
- **Architecture**: Static website (no build process required)

## File Structure

```
website/
├── index.html              # Homepage
├── blogs.html              # Blog listing page
├── blog/                   # Individual blog posts
│   ├── ci-cd-pipeline-github-actions.html
│   ├── aws-terraform-infrastructure.html
│   └── prometheus-grafana-monitoring.html
├── styles.css              # Main stylesheet
├── script.js               # Homepage JavaScript
├── blog-listing.js         # Blog search/filter functionality
└── favicon.ico             # Site favicon
```

## Navigation Flow

```
Homepage (index.html)
├── Featured Blogs Section
│   ├── Read More → Individual Blog Post
│   └── See All Blogs → Blog Listing (blogs.html)
├── Blog Listing (blogs.html)
│   ├── Search & Filter functionality
│   └── Blog Cards → Individual Blog Posts
└── Individual Blog Posts
    └── Back to All Blogs → Blog Listing
```

## Features Implementation

### ✅ Functional "Read More" Buttons
- Each blog card links to its respective detailed blog post
- Smooth hover animations with arrow movement
- Consistent styling across all pages

### ✅ Functional "See All Blogs" Button
- Links to comprehensive blog listing page
- Includes search and filter functionality
- Shows all available blog posts in grid format

### ✅ Custom Branding
- Custom favicon (placeholder for logo-firman-arya.png)
- Updated page titles: "Firman Arya | Portfolio & Blog"
- Consistent branding across all pages

### ✅ Responsive Design
- Mobile-first approach
- Flexible grid layouts
- Optimized typography scaling
- Touch-friendly navigation

### ✅ Interactive Elements
- Search functionality with real-time filtering
- Technology tag filters
- Smooth scroll animations
- Hover effects and micro-interactions

## Browser Compatibility

- Modern browsers (Chrome, Firefox, Safari, Edge)
- Mobile browsers (iOS Safari, Chrome Mobile)
- Progressive enhancement approach
- Graceful fallbacks for older browsers

## Performance

- Optimized images and assets
- Minimal JavaScript footprint
- CSS-based animations
- Fast loading times
- No external dependencies (except fonts and icons)

## SEO Features

- Semantic HTML structure
- Meta descriptions for each blog post
- Proper heading hierarchy
- Alt text for images
- Clean URL structure

---

**Author**: Firman Arya  
**Contact**: firmanap22@gmail.com  
**LinkedIn**: [linkedin.com/in/firmanaryapradhana](https://www.linkedin.com/in/firmanaryapradhana/)  
**GitHub**: [github.com/ghoman22](https://github.com/ghoman22)