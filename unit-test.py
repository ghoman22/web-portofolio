#!/usr/bin/env python3
"""
🧪 Comprehensive Test Suite for DevOps Portfolio
Enhanced with modern testing practices and detailed validation
"""

import os
import sys
import json
import time
import requests
from pathlib import Path
from bs4 import BeautifulSoup
import pytest
from unittest.mock import patch, MagicMock

# Test configuration
WEBSITE_DIR = "website"
REQUIRED_FILES = ["index.html", "styles.css", "script.js"]
EXPECTED_TITLE = "DevOps Portfolio - Firman Arya"
EXPECTED_SECTIONS = ["hero", "about", "skills", "projects", "contact"]

class TestWebsiteStructure:
    """Test the basic structure and files of the website"""
    
    def test_website_directory_exists(self):
        """Verify that the website directory exists"""
        assert os.path.isdir(WEBSITE_DIR), f"Website directory '{WEBSITE_DIR}' not found!"
    
    def test_required_files_exist(self):
        """Verify that all required files exist"""
        for file_name in REQUIRED_FILES:
            file_path = os.path.join(WEBSITE_DIR, file_name)
            assert os.path.isfile(file_path), f"Required file '{file_name}' not found!"
    
    def test_files_not_empty(self):
        """Verify that required files are not empty"""
        for file_name in REQUIRED_FILES:
            file_path = os.path.join(WEBSITE_DIR, file_name)
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read().strip()
                assert len(content) > 0, f"File '{file_name}' is empty!"

class TestHTMLStructure:
    """Test the HTML structure and content"""
    
    @pytest.fixture
    def soup(self):
        """Load and parse the HTML file"""
        html_path = os.path.join(WEBSITE_DIR, "index.html")
        with open(html_path, 'r', encoding='utf-8') as f:
            return BeautifulSoup(f.read(), 'html.parser')
    
    def test_html_title(self, soup):
        """Verify the page title is correct"""
        title = soup.title
        assert title is not None, "HTML title tag not found!"
        assert title.string == EXPECTED_TITLE, f"Title should be '{EXPECTED_TITLE}', got '{title.string}'"
    
    def test_html_structure(self, soup):
        """Verify basic HTML structure"""
        assert soup.html is not None, "HTML tag not found!"
        assert soup.head is not None, "HEAD tag not found!"
        assert soup.body is not None, "BODY tag not found!"
    
    def test_meta_tags(self, soup):
        """Verify essential meta tags are present"""
        charset_meta = soup.find('meta', {'charset': True})
        assert charset_meta is not None, "Charset meta tag not found!"
        
        viewport_meta = soup.find('meta', {'name': 'viewport'})
        assert viewport_meta is not None, "Viewport meta tag not found!"
    
    def test_required_sections(self, soup):
        """Verify all required sections are present"""
        for section_id in EXPECTED_SECTIONS:
            section = soup.find(id=section_id)
            assert section is not None, f"Section with id '{section_id}' not found!"
    
    def test_navigation_links(self, soup):
        """Verify navigation links are present and valid"""
        nav_links = soup.find_all('a', href=True)
        nav_hrefs = [link['href'] for link in nav_links if link['href'].startswith('#')]
        
        for section_id in EXPECTED_SECTIONS:
            expected_href = f"#{section_id}"
            assert expected_href in nav_hrefs, f"Navigation link to '{expected_href}' not found!"
    
    def test_external_resources(self, soup):
        """Verify external resources are properly linked"""
        # Check for CSS files
        css_links = soup.find_all('link', {'rel': 'stylesheet'})
        assert len(css_links) > 0, "No CSS files linked!"
        
        # Check for JavaScript files
        js_scripts = soup.find_all('script', src=True)
        local_js = [script for script in js_scripts if not script['src'].startswith('http')]
        assert len(local_js) > 0, "No local JavaScript files found!"

class TestCSSValidation:
    """Test CSS file validation"""
    
    @pytest.fixture
    def css_content(self):
        """Load CSS file content"""
        css_path = os.path.join(WEBSITE_DIR, "styles.css")
        with open(css_path, 'r', encoding='utf-8') as f:
            return f.read()
    
    def test_css_syntax(self, css_content):
        """Basic CSS syntax validation"""
        # Check for balanced braces
        open_braces = css_content.count('{')
        close_braces = css_content.count('}')
        assert open_braces == close_braces, "Unbalanced CSS braces detected!"
    
    def test_modern_css_features(self, css_content):
        """Verify modern CSS features are used"""
        modern_features = [
            'grid',
            'flex',
            'transition',
            'transform',
            'animation',
            '@keyframes',
            'backdrop-filter'
        ]
        
        for feature in modern_features:
            assert feature in css_content, f"Modern CSS feature '{feature}' not found!"
    
    def test_responsive_design(self, css_content):
        """Verify responsive design media queries"""
        assert '@media' in css_content, "No media queries found for responsive design!"
        assert 'max-width' in css_content, "No max-width rules found for responsive design!"

class TestJavaScriptValidation:
    """Test JavaScript file validation"""
    
    @pytest.fixture
    def js_content(self):
        """Load JavaScript file content"""
        js_path = os.path.join(WEBSITE_DIR, "script.js")
        with open(js_path, 'r', encoding='utf-8') as f:
            return f.read()
    
    def test_javascript_syntax(self, js_content):
        """Basic JavaScript syntax validation"""
        # Check for basic syntax elements
        assert 'document.addEventListener' in js_content, "No event listeners found!"
        assert 'function' in js_content or '=>' in js_content, "No functions found!"
    
    def test_modern_javascript_features(self, js_content):
        """Verify modern JavaScript features are used"""
        modern_features = [
            'const ',
            'let ',
            'addEventListener',
            'querySelector',
            'classList'
        ]
        
        for feature in modern_features:
            assert feature in js_content, f"Modern JavaScript feature '{feature}' not found!"
    
    def test_interactive_features(self, js_content):
        """Verify interactive features are implemented"""
        interactive_features = [
            'scroll',
            'click',
            'hover' in js_content or 'mouseenter' in js_content,
            'animation' in js_content or 'transition' in js_content
        ]
        
        found_features = sum(1 for feature in interactive_features if 
                           (feature if isinstance(feature, bool) else feature in js_content))
        assert found_features >= 2, "Not enough interactive features implemented!"

class TestAccessibility:
    """Test accessibility features"""
    
    @pytest.fixture
    def soup(self):
        """Load and parse the HTML file"""
        html_path = os.path.join(WEBSITE_DIR, "index.html")
        with open(html_path, 'r', encoding='utf-8') as f:
            return BeautifulSoup(f.read(), 'html.parser')
    
    def test_alt_attributes(self, soup):
        """Verify images have alt attributes"""
        images = soup.find_all('img')
        for img in images:
            assert img.get('alt') is not None, f"Image missing alt attribute: {img}"
    
    def test_aria_labels(self, soup):
        """Verify ARIA labels are used where appropriate"""
        interactive_elements = soup.find_all(['button', 'a', 'input'])
        aria_labeled_count = sum(1 for elem in interactive_elements 
                               if elem.get('aria-label') or elem.get('aria-labelledby'))
        
        # At least some interactive elements should have ARIA labels
        assert aria_labeled_count > 0, "No ARIA labels found on interactive elements!"
    
    def test_semantic_html(self, soup):
        """Verify semantic HTML elements are used"""
        semantic_elements = ['header', 'nav', 'main', 'section', 'footer']
        found_elements = [elem for elem in semantic_elements if soup.find(elem)]
        
        assert len(found_elements) >= 3, f"Not enough semantic elements found. Found: {found_elements}"

class TestPerformance:
    """Test performance-related aspects"""
    
    def test_file_sizes(self):
        """Verify file sizes are reasonable"""
        size_limits = {
            'index.html': 50 * 1024,  # 50KB
            'styles.css': 100 * 1024,  # 100KB
            'script.js': 50 * 1024     # 50KB
        }
        
        for file_name, limit in size_limits.items():
            file_path = os.path.join(WEBSITE_DIR, file_name)
            file_size = os.path.getsize(file_path)
            assert file_size <= limit, f"File '{file_name}' is too large: {file_size} bytes (limit: {limit} bytes)"
    
    def test_css_optimization(self):
        """Check for CSS optimization indicators"""
        css_path = os.path.join(WEBSITE_DIR, "styles.css")
        with open(css_path, 'r', encoding='utf-8') as f:
            css_content = f.read()
        
        # Check for efficient selectors and properties
        optimization_indicators = [
            'transform',  # Hardware acceleration
            'will-change',  # Performance hints
            'contain',  # CSS containment
        ]
        
        found_optimizations = sum(1 for indicator in optimization_indicators 
                                if indicator in css_content)
        
        # At least one optimization should be present
        assert found_optimizations > 0, "No performance optimizations found in CSS!"

class TestSecurity:
    """Test security-related aspects"""
    
    @pytest.fixture
    def soup(self):
        """Load and parse the HTML file"""
        html_path = os.path.join(WEBSITE_DIR, "index.html")
        with open(html_path, 'r', encoding='utf-8') as f:
            return BeautifulSoup(f.read(), 'html.parser')
    
    def test_external_links_security(self, soup):
        """Verify external links have proper security attributes"""
        external_links = soup.find_all('a', href=True)
        external_links = [link for link in external_links 
                         if link['href'].startswith('http') and 'target="_blank"' in str(link)]
        
        for link in external_links:
            # External links should have rel="noopener" or rel="noreferrer"
            rel_attr = link.get('rel', [])
            if isinstance(rel_attr, str):
                rel_attr = rel_attr.split()
            
            has_security = any(attr in rel_attr for attr in ['noopener', 'noreferrer'])
            assert has_security, f"External link missing security attributes: {link}"
    
    def test_no_inline_scripts(self, soup):
        """Verify no inline JavaScript is used (security best practice)"""
        inline_scripts = soup.find_all('script', src=False)
        inline_scripts = [script for script in inline_scripts if script.string and script.string.strip()]
        
        # Allow some inline scripts but warn if too many
        assert len(inline_scripts) <= 2, f"Too many inline scripts found: {len(inline_scripts)}"

def run_comprehensive_tests():
    """Run all tests and generate a detailed report"""
    print("🧪 Starting Comprehensive Test Suite for DevOps Portfolio")
    print("=" * 60)
    
    # Run pytest with detailed output
    test_args = [
        __file__,
        '-v',
        '--tb=short',
        '--color=yes',
        '--durations=10'
    ]
    
    exit_code = pytest.main(test_args)
    
    if exit_code == 0:
        print("\n" + "=" * 60)
        print("🎉 All tests passed! Your DevOps Portfolio is ready for deployment!")
        print("✅ HTML structure is valid")
        print("✅ CSS is modern and responsive")
        print("✅ JavaScript is interactive and modern")
        print("✅ Accessibility features are present")
        print("✅ Performance optimizations detected")
        print("✅ Security best practices followed")
    else:
        print("\n" + "=" * 60)
        print("❌ Some tests failed. Please review the output above.")
        sys.exit(1)

if __name__ == "__main__":
    run_comprehensive_tests()