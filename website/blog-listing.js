// Blog listing functionality
document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('blogSearch');
    const filterTags = document.querySelectorAll('.filter-tag');
    const blogGrid = document.getElementById('blogGrid');
    const blogCards = document.querySelectorAll('.blog-card');
    const noResults = document.getElementById('noResults');

    let currentFilter = 'all';
    let currentSearch = '';

    // Search functionality
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            currentSearch = e.target.value.toLowerCase();
            filterBlogs();
        });
    }

    // Filter functionality
    filterTags.forEach(tag => {
        tag.addEventListener('click', () => {
            // Remove active class from all tags
            filterTags.forEach(t => t.classList.remove('active'));
            // Add active class to clicked tag
            tag.classList.add('active');
            
            currentFilter = tag.getAttribute('data-filter');
            filterBlogs();
        });
    });

    function filterBlogs() {
        let visibleCount = 0;

        blogCards.forEach(card => {
            const cardTags = card.getAttribute('data-tags').toLowerCase();
            const cardTitle = card.querySelector('h3').textContent.toLowerCase();
            const cardExcerpt = card.querySelector('.blog-excerpt').textContent.toLowerCase();
            
            // Check if card matches current filter
            const matchesFilter = currentFilter === 'all' || cardTags.includes(currentFilter);
            
            // Check if card matches current search
            const matchesSearch = currentSearch === '' || 
                cardTitle.includes(currentSearch) || 
                cardExcerpt.includes(currentSearch) ||
                cardTags.includes(currentSearch);

            if (matchesFilter && matchesSearch) {
                card.style.display = 'block';
                card.style.animation = 'fadeInUp 0.5s ease-out';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        // Show/hide no results message
        if (visibleCount === 0) {
            noResults.style.display = 'block';
            noResults.style.animation = 'fadeInUp 0.5s ease-out';
        } else {
            noResults.style.display = 'none';
        }
    }

    // Add smooth scroll to top functionality for blog listing
    const scrollBtn = document.querySelector('.scroll-to-top');
    if (scrollBtn) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 300) {
                scrollBtn.classList.add('visible');
            } else {
                scrollBtn.classList.remove('visible');
            }
        });
        
        scrollBtn.addEventListener('click', () => {
            window.scrollTo({ 
                top: 0, 
                behavior: 'smooth' 
            });
        });
    }

    // Enhanced blog card interactions
    const blogCardsForAnimation = document.querySelectorAll('.blog-card');
    blogCardsForAnimation.forEach(card => {
        card.addEventListener('mouseenter', () => {
            card.style.transform = 'translateY(-10px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', () => {
            card.style.transform = '';
        });
    });

    // Animate cards on page load
    setTimeout(() => {
        blogCards.forEach((card, index) => {
            setTimeout(() => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
    }, 200);

    console.log('🔍 Blog listing functionality loaded!');
});