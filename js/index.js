(function() {
        // This script makes all footer links show a friendly info message (for demo purposes)
        // When integrating into actual website, replace the href="#"" with proper links.
        const allFooterLinks = document.querySelectorAll('.alison-footer a');
        allFooterLinks.forEach(link => {
            // if href is "#" or empty, add a demo alert. Otherwise keep original behaviour.
            if (link.getAttribute('href') === '#' || link.getAttribute('href') === '' || link.getAttribute('href').startsWith('#')) {
                link.addEventListener('click', (e) => {
                    e.preventDefault();
                    const text = link.innerText.trim();
                    
                });
            } else {
                // if href has a real url, just let it navigate, but we also add a small attribute for external?
                // but for demo we keep it as is (all links are demo-friendly)
                if (!link.getAttribute('href') || link.getAttribute('href') === '#') {
                    link.addEventListener('click', (e) => {
                        e.preventDefault();
                        alert(`🚀 Explore "${text}" — part of our learning ecosystem. Visit our courses section to get started.`);
                    });
                }
            }
        });
    })();

(function() {
        // Stable search functionality (filters video link buttons)
        const searchInput = document.getElementById('searchInput');
        const searchBtn = document.getElementById('searchBtn');
        const videoLinkButtons = document.querySelectorAll('.video-link-button');
        const mainVideoCard = document.getElementById('videoLessonsMainLink');

        function filterVideoLinks() {
            const query = searchInput.value.trim().toLowerCase();
            if (!query) {
                videoLinkButtons.forEach(btn => {
                    btn.style.display = 'inline-flex';
                });
                return;
            }
            videoLinkButtons.forEach(btn => {
                const btnText = btn.innerText.toLowerCase();
                const matches = btnText.includes(query);
                btn.style.display = matches ? 'inline-flex' : 'none';
            });
        }

        searchBtn.addEventListener('click', filterVideoLinks);
        searchInput.addEventListener('keyup', (e) => {
            if (e.key === 'Enter') filterVideoLinks();
        });

        function handleVideoLinkClick(event, linkElement, videoTitle) {
            event.preventDefault();
            alert(`🎬 "${videoTitle}"\n📺 Full video library is coming soon. Ubumenyi Hub offers downloadable lessons, interactive quizzes, and blockchain-verified certificates. Stay tuned for immersive video content in Kinyarwanda & English.`);
        }

        videoLinkButtons.forEach(btn => {
            btn.addEventListener('click', (e) => {
                const title = btn.innerText.replace(/[▶️🛡️⚙️🔗📘🌍]/g, '').trim();
                handleVideoLinkClick(e, btn, title);
            });
        });

        if (mainVideoCard) {
            mainVideoCard.addEventListener('click', (e) => {
                window.location.href= "videos.html"
            });

            
        const otherCards = document.querySelectorAll('.ecosystem-card:not(#videoLessonsMainLink)');
        otherCards.forEach(card => {
            card.addEventListener('click', (e) => {
                e.preventDefault();
                const cardTitle = card.querySelector('.card-title')?.innerText || 'Resource';
                alert(`✨ Explore ${cardTitle}. Interactive content, progress tracking, and verifiable micro-credentials available inside Ubumenyi Hub.`);
            });
        });

        const resetVisibility = () => {
            if (searchInput.value.trim() === '') {
                videoLinkButtons.forEach(btn => btn.style.display = 'inline-flex');
            }
        };
        searchInput.addEventListener('input', function() {
            if (this.value === '') resetVisibility();
        });
    };
})