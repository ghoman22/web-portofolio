document.addEventListener('DOMContentLoaded', () => {
    // Enhanced Hamburger Menu Logic with better click handling and responsiveness
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');
    if (hamburger && navMenu) {
        // Improved click handling with debouncing
        let isMenuToggling = false;
        
        hamburger.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            
            if (isMenuToggling) return;
            isMenuToggling = true;
            
            hamburger.classList.toggle('active');
            navMenu.classList.toggle('active');
            hamburger.setAttribute('aria-expanded', navMenu.classList.contains('active'));
            
            // Add body scroll lock when menu is open
            document.body.style.overflow = navMenu.classList.contains('active') ? 'hidden' : '';
            
            // Reset debounce after animation
            setTimeout(() => {
                isMenuToggling = false;
            }, 350);
        });
        
        // Enhanced touch support for mobile
        hamburger.addEventListener('touchstart', (e) => {
            e.preventDefault();
        }, { passive: false });
        
        // Close menu when clicking on links with improved handling
        document.querySelectorAll('.nav-menu a').forEach(link => {
            link.addEventListener('click', (e) => {
                // Close mobile menu
                hamburger.classList.remove('active');
                navMenu.classList.remove('active');
                hamburger.setAttribute('aria-expanded', 'false');
                document.body.style.overflow = '';
                
                // For anchor links, let the enhanced smooth scroll handler take over
                const href = link.getAttribute('href');
                if (!href.startsWith('#')) {
                    // For external navigation, allow normal behavior
                    return true;
                }
            });
        });
        
        // Close menu when clicking outside with better event handling
        document.addEventListener('click', (e) => {
            if (!hamburger.contains(e.target) && !navMenu.contains(e.target) && navMenu.classList.contains('active')) {
                hamburger.classList.remove('active');
                navMenu.classList.remove('active');
                hamburger.setAttribute('aria-expanded', 'false');
                document.body.style.overflow = '';
            }
        });
        
        // Improved touch support for closing menu
        document.addEventListener('touchstart', (e) => {
            if (!hamburger.contains(e.target) && !navMenu.contains(e.target) && navMenu.classList.contains('active')) {
                hamburger.classList.remove('active');
                navMenu.classList.remove('active');
                hamburger.setAttribute('aria-expanded', 'false');
                document.body.style.overflow = '';
            }
        });
    }

    // Enhanced Navbar with dynamic styling
    const navbar = document.querySelector('.navbar');
    let lastScrollY = window.scrollY;
    
    window.addEventListener('scroll', () => {
        const currentScrollY = window.scrollY;
        
        // Add scrolled class for styling
        if (currentScrollY > 50) {
            navbar && navbar.classList.add('scrolled');
        } else {
            navbar && navbar.classList.remove('scrolled');
        }
        
        // Hide/show navbar on scroll direction (optional enhancement)
        if (currentScrollY > lastScrollY && currentScrollY > 100) {
            navbar && navbar.style.setProperty('transform', 'translateY(-100%)');
        } else {
            navbar && navbar.style.setProperty('transform', 'translateY(0)');
        }
        
        lastScrollY = currentScrollY;
    });

    // Enhanced Scroll to Top Button with smooth behavior
    const scrollBtn = document.querySelector('.scroll-to-top');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 300) {
            scrollBtn && scrollBtn.classList.add('visible');
        } else {
            scrollBtn && scrollBtn.classList.remove('visible');
        }
    });
    
    if (scrollBtn) {
        scrollBtn.addEventListener('click', () => {
            window.scrollTo({ 
                top: 0, 
                behavior: 'smooth' 
            });
        });
    }

    // Enhanced Section Fade-in Animation with Intersection Observer
    const sections = document.querySelectorAll('main section');
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const sectionObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
            }
        });
    }, observerOptions);
    
    sections.forEach(section => {
        sectionObserver.observe(section);
    });

    // Active navigation highlighting for clean URLs
    const updateActiveNavigation = () => {
        const currentPath = window.location.pathname;
        const navLinks = document.querySelectorAll('.nav-menu a');
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            const linkHref = link.getAttribute('href');
            
            // Handle exact matches for clean URLs
            if (linkHref === currentPath) {
                link.classList.add('active');
            }
            // Handle root path
            else if (currentPath === '/' && linkHref === '/') {
                link.classList.add('active');
            }
            // Handle blog listing page
            else if (currentPath === '/blogs' && linkHref === '/blogs') {
                link.classList.add('active');
            }
            // Handle individual blog posts (should highlight blogs nav)
            else if (currentPath.startsWith('/blog/') && linkHref === '/blogs') {
                link.classList.add('active');
            }
        });
    };

    // Call on page load
    updateActiveNavigation();

    // Active navigation highlighting for anchor-based navigation (for single page sections)
    const navLinks = document.querySelectorAll('.nav-menu a[href^="#"]');
    const updateActiveNav = () => {
        const scrollPosition = window.scrollY + 100;
        
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const sectionHeight = section.offsetHeight;
            const sectionId = section.getAttribute('id');
            
            if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
                navLinks.forEach(link => {
                    link.classList.remove('active');
                    if (link.getAttribute('href') === `#${sectionId}`) {
                        link.classList.add('active');
                    }
                });
            }
        });
    };
    
    window.addEventListener('scroll', updateActiveNav);
    updateActiveNav(); // Initial call

    // Enhanced Dynamic Terminal Logic with better animations
    const terminalContent = document.getElementById('terminal-content');
    if (!terminalContent) {
        console.error("Terminal content element not found!");
        return;
    }
    
    const terminalScenarios = [
        { 
            lines: [ 
                { type: 'prompt', text: 'kubectl apply -f deployment.yaml' }, 
                { type: 'output', text: 'deployment.apps/web-app created'}, 
                { type: 'output', text: 'service/web-app-service created'}, 
                { type: 'success', text: '✅ Deployment successful!' } 
            ] 
        },
        { 
            lines: [ 
                { type: 'prompt', text: 'terraform plan -out=tfplan' }, 
                { type: 'output', text: 'Refreshing state... Reading configuration...'}, 
                { type: 'output', text: 'Plan: 3 to add, 1 to change, 0 to destroy.'}, 
                { type: 'success', text: '📋 Plan saved to tfplan.' } 
            ] 
        },
        { 
            lines: [ 
                { type: 'prompt', text: 'docker build -t myapp:v2.1 .' }, 
                { type: 'output', text: 'Sending build context to Docker daemon...'}, 
                { type: 'output', text: 'Step 1/8 : FROM node:18-alpine'}, 
                { type: 'output', text: 'Step 8/8 : CMD ["npm", "start"]'}, 
                { type: 'success', text: '🐳 Successfully built myapp:v2.1'} 
            ] 
        },
        { 
            lines: [ 
                { type: 'prompt', text: 'git push origin feature/ci-cd' }, 
                { type: 'output', text: 'Enumerating objects: 12, done.'}, 
                { type: 'output', text: 'remote: Running CI/CD pipeline...'}, 
                { type: 'output', text: 'remote: ✅ Tests passed'}, 
                { type: 'success', text: '🚀 Pipeline completed successfully!'} 
            ] 
        },
        { 
            lines: [ 
                { type: 'prompt', text: 'aws s3 sync ./dist s3://my-bucket' }, 
                { type: 'output', text: 'upload: dist/index.html to s3://my-bucket/index.html'}, 
                { type: 'output', text: 'upload: dist/assets/main.js to s3://my-bucket/assets/main.js'}, 
                { type: 'success', text: '☁️ Deployment to S3 complete!' } 
            ] 
        }
    ];
    
    let scenarioIndex = 0;
    const typingSpeed = 40;
    const lineDelay = 400;
    const scenarioDelay = 6000;
    
    function typeText(element, text) {
        return new Promise(resolve => {
            let i = 0;
            const interval = setInterval(() => {
                if (i < text.length) {
                    element.textContent += text.charAt(i);
                    i++;
                } else {
                    clearInterval(interval);
                    resolve();
                }
            }, typingSpeed);
        });
    }
    
    async function runScenarios() {
        while (true) {
            const scenario = terminalScenarios[scenarioIndex];
            
            for (const lineData of scenario.lines) {
                const lineElement = document.createElement('div');
                lineElement.className = `line line-${lineData.type}`;
                terminalContent.appendChild(lineElement);
                
                if (lineData.type === 'prompt') {
                    const promptSign = document.createElement('span');
                    promptSign.textContent = '$ ';
                    const commandText = document.createElement('span');
                    lineElement.appendChild(promptSign);
                    lineElement.appendChild(commandText);
                    await typeText(commandText, lineData.text);
                } else {
                    await typeText(lineElement, lineData.text);
                }
                
                // Auto-scroll to bottom
                terminalContent.scrollTop = terminalContent.scrollHeight;
                await new Promise(resolve => setTimeout(resolve, lineDelay));
            }
            
            await new Promise(resolve => setTimeout(resolve, scenarioDelay));
            scenarioIndex = (scenarioIndex + 1) % terminalScenarios.length;
            
            // Clear terminal with fade effect
            terminalContent.style.opacity = '0.5';
            await new Promise(resolve => setTimeout(resolve, 300));
            terminalContent.innerHTML = '';
            terminalContent.style.opacity = '1';
        }
    }
    
    runScenarios();

    // Enhanced Particle Animation System
    const particlesContainer = document.querySelector('.particles-bg');
    if (particlesContainer) {
        // Create additional dynamic particles
        for (let i = 0; i < 15; i++) {
            const particle = document.createElement('div');
            particle.className = 'particle';
            particle.style.width = Math.random() * 4 + 2 + 'px';
            particle.style.height = particle.style.width;
            particle.style.left = Math.random() * 100 + '%';
            particle.style.top = Math.random() * 100 + '%';
            particle.style.animationDelay = Math.random() * 6 + 's';
            particle.style.animationDuration = (Math.random() * 4 + 4) + 's';
            particlesContainer.appendChild(particle);
        }
    }

    // Enhanced Smooth scrolling for anchor links with better error handling
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const target = document.getElementById(targetId);
            if (target) {
                const offsetTop = target.offsetTop - 80; // Account for fixed navbar
                window.scrollTo({
                    top: offsetTop,
                    behavior: 'smooth'
                });
                
                // Update URL without causing page reload
                history.pushState(null, '', `#${targetId}`);
            }
        });
    });

    // Enhanced navigation for external links - ensure they navigate properly
    document.querySelectorAll('.nav-menu a:not([href^="#"])').forEach(link => {
        link.addEventListener('click', function(e) {
            // Allow normal navigation for external links
            const href = this.getAttribute('href');
            if (href && href !== '#') {
                // For clean navigation, let the browser handle it normally
                window.location.href = href;
            }
        });
    });

    // Enhanced skill card interactions
    const skillCards = document.querySelectorAll('.skill-card');
    skillCards.forEach(card => {
        card.addEventListener('mouseenter', () => {
            // Add subtle rotation effect
            const randomRotation = (Math.random() - 0.5) * 6; // Random rotation between -3 and 3 degrees
            card.style.transform = `translateY(-10px) scale(1.05) rotate(${randomRotation}deg)`;
        });
        
        card.addEventListener('mouseleave', () => {
            card.style.transform = '';
        });
    });

    // Project card enhanced interactions
    const projectCards = document.querySelectorAll('.project-card');
    projectCards.forEach(card => {
        card.addEventListener('mouseenter', () => {
            // Add subtle tilt effect
            const rect = card.getBoundingClientRect();
            const centerX = rect.left + rect.width / 2;
            const centerY = rect.top + rect.height / 2;
            
            card.addEventListener('mousemove', handleMouseMove);
            
            function handleMouseMove(e) {
                const mouseX = e.clientX - centerX;
                const mouseY = e.clientY - centerY;
                const rotateX = (mouseY / rect.height) * 10;
                const rotateY = (mouseX / rect.width) * -10;
                
                card.style.transform = `translateY(-15px) scale(1.02) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
            }
        });
        
        card.addEventListener('mouseleave', () => {
            card.style.transform = '';
            card.removeEventListener('mousemove', card.handleMouseMove);
        });
    });

    // Keyboard navigation enhancement
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && navMenu && navMenu.classList.contains('active')) {
            hamburger.classList.remove('active');
            navMenu.classList.remove('active');
            hamburger.setAttribute('aria-expanded', 'false');
            document.body.style.overflow = '';
        }
    });

    // Performance optimization: Throttle scroll events
    let ticking = false;
    function throttleScroll(func) {
        if (!ticking) {
            requestAnimationFrame(() => {
                func();
                ticking = false;
            });
            ticking = true;
        }
    }

    // Color scheme detection and adaptation
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
        document.body.classList.add('dark');
    }

    // Add loading animation completion
    window.addEventListener('load', () => {
        document.body.classList.add('loaded');
        
        // Trigger initial animations
        const heroElements = document.querySelectorAll('.hero-text h1, .hero-subtitle, .hero-buttons');
        heroElements.forEach((element, index) => {
            setTimeout(() => {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, index * 200);
        });
    });

    // Enhanced button interactions with ripple effect
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
        button.addEventListener('click', function(e) {
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;
            
            ripple.style.width = ripple.style.height = size + 'px';
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            ripple.classList.add('ripple');
            
            this.appendChild(ripple);
            
            setTimeout(() => {
                ripple.remove();
            }, 600);
        });
    });

    console.log('🚀 Enhanced website loaded successfully!');
});