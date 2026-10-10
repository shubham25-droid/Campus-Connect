/**
 * CampusConnect - Client-Side Interactive Engine
 * Provides fast client-side filtering, form validation, and interactive feedback.
 */

document.addEventListener('DOMContentLoaded', function () {
    initMobileMenu();
    initClientFilter();
    initSaveButtons();
    initFormValidation();
    initShareButtons();
});

/**
 * Mobile Navigation Drawer Toggle & Swipe-To-Dismiss
 */
function initMobileMenu() {
    const toggleBtn = document.getElementById('mobileMenuToggle');
    const drawer = document.getElementById('mobileNavDrawer');
    const overlay = document.getElementById('mobileDrawerOverlay');
    const closeBtn = document.getElementById('mobileDrawerClose');

    if (!drawer) return;

    function openMenu() {
        if (toggleBtn) {
            toggleBtn.classList.add('active');
            toggleBtn.setAttribute('aria-expanded', 'true');
        }
        drawer.classList.add('active');
        if (overlay) overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeMenu() {
        if (toggleBtn) {
            toggleBtn.classList.remove('active');
            toggleBtn.setAttribute('aria-expanded', 'false');
        }
        drawer.classList.remove('active');
        if (overlay) overlay.classList.remove('active');
        document.body.style.overflow = '';
    }

    window.openMobileMenu = openMenu;
    window.closeMobileMenu = closeMenu;
    window.toggleMobileMenu = function() {
        if (drawer.classList.contains('active')) {
            closeMenu();
        } else {
            openMenu();
        }
    };

    if (toggleBtn) {
        toggleBtn.addEventListener('click', function(e) {
            e.preventDefault();
            window.toggleMobileMenu();
        });
    }

    if (closeBtn) {
        closeBtn.addEventListener('click', function(e) {
            e.preventDefault();
            closeMenu();
        });
        closeBtn.addEventListener('touchend', function(e) {
            e.preventDefault();
            closeMenu();
        });
    }

    if (overlay) {
        overlay.addEventListener('click', function(e) {
            e.preventDefault();
            closeMenu();
        });
        overlay.addEventListener('touchend', function(e) {
            e.preventDefault();
            closeMenu();
        });
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && drawer.classList.contains('active')) {
            closeMenu();
        }
    });

    // Close when clicking any nav link inside drawer
    drawer.querySelectorAll('.mobile-nav-link').forEach(link => {
        link.addEventListener('click', closeMenu);
    });

    // Swipe-to-dismiss gesture on mobile (swipe right)
    let touchStartX = 0;
    let touchStartY = 0;
    drawer.addEventListener('touchstart', function(e) {
        if (e.touches && e.touches.length > 0) {
            touchStartX = e.touches[0].clientX;
            touchStartY = e.touches[0].clientY;
        }
    }, { passive: true });

    drawer.addEventListener('touchend', function(e) {
        if (e.changedTouches && e.changedTouches.length > 0) {
            const touchEndX = e.changedTouches[0].clientX;
            const touchEndY = e.changedTouches[0].clientY;
            if (touchEndX - touchStartX > 45 && Math.abs(touchEndY - touchStartY) < 80) {
                closeMenu();
            }
        }
    }, { passive: true });
}

/**
 * Real-time filter & search on event cards
 */
function initClientFilter() {
    const searchInput = document.getElementById('clientSearchInput');
    const deptSelect = document.getElementById('clientDeptSelect');
    const yearSelect = document.getElementById('clientYearSelect');
    const eventCards = document.querySelectorAll('.event-card-item');

    if (!eventCards.length) return;

    function applyFilter() {
        const query = searchInput ? searchInput.value.toLowerCase().trim() : '';
        const dept = deptSelect ? deptSelect.value.toLowerCase().trim() : 'all';
        const year = yearSelect ? yearSelect.value.toLowerCase().trim() : 'all';

        let visibleCount = 0;

        eventCards.forEach(card => {
            const title = card.getAttribute('data-title') || '';
            const organizer = card.getAttribute('data-organizer') || '';
            const category = card.getAttribute('data-category') || '';
            const cardDept = card.getAttribute('data-dept') || '';
            const cardYear = card.getAttribute('data-year') || '';

            const matchesSearch = !query || 
                title.includes(query) || 
                organizer.includes(query) || 
                category.includes(query);

            const matchesDept = (dept === 'all') || 
                cardDept.includes(dept) || 
                cardDept.includes('all');

            const matchesYear = (year === 'all') || 
                cardYear.includes(year) || 
                cardYear.includes('all');

            if (matchesSearch && matchesDept && matchesYear) {
                card.style.display = '';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        const noResultsMsg = document.getElementById('noResultsMsg');
        if (noResultsMsg) {
            noResultsMsg.style.display = visibleCount === 0 ? 'block' : 'none';
        }

        const countBadge = document.getElementById('resultsCountBadge');
        if (countBadge) {
            countBadge.innerText = visibleCount + ' events found';
        }
    }

    if (searchInput) {
        searchInput.addEventListener('input', applyFilter);
    }
    if (deptSelect) {
        deptSelect.addEventListener('change', applyFilter);
    }
    if (yearSelect) {
        yearSelect.addEventListener('change', applyFilter);
    }
}

/**
 * Handle bookmark / save events asynchronously
 */
function initSaveButtons() {
    document.querySelectorAll('.btn-save-toggle').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            const eventId = this.getAttribute('data-event-id');
            const icon = this.querySelector('.save-icon');
            const label = this.querySelector('.save-label');

            if (!eventId) return;

            const formData = new FormData();
            formData.append('eventId', eventId);
            formData.append('ajax', 'true');

            fetch(contextPath + '/toggle-save', {
                method: 'POST',
                body: formData
            })
            .then(res => {
                if (res.redirected) {
                    window.location.href = res.url;
                    return null;
                }
                return res.json();
            })
            .then(data => {
                if (!data) return;
                if (data.saved) {
                    btn.classList.add('saved');
                    if (icon) icon.innerHTML = '&#9829;'; // Filled heart
                    if (label) label.innerText = 'Saved';
                } else {
                    btn.classList.remove('saved');
                    if (icon) icon.innerHTML = '&#9825;'; // Outline heart
                    if (label) label.innerText = 'Save Event';
                }
            })
            .catch(err => {
                console.error('Bookmark error:', err);
            });
        });
    });
}

/**
 * Form Validation
 */
function initFormValidation() {
    const regForm = document.getElementById('studentRegisterForm');
    if (regForm) {
        regForm.addEventListener('submit', function (e) {
            const pass = document.getElementById('regPassword').value;
            const confirm = document.getElementById('regConfirmPassword').value;

            if (pass !== confirm) {
                e.preventDefault();
                alert('Passwords do not match! Please check and try again.');
            }
        });
    }

    const eventForm = document.getElementById('createEventForm');
    if (eventForm) {
        eventForm.addEventListener('submit', function (e) {
            const title = document.getElementById('eventTitle').value.trim();
            const date = document.getElementById('eventDate').value;
            const venue = document.getElementById('eventVenue').value.trim();

            if (!title || !date || !venue) {
                e.preventDefault();
                alert('Please fill out Event Title, Event Date, and Venue.');
            }
        });
    }
}

/**
 * WhatsApp and Direct Share
 */
function initShareButtons() {
    const shareBtn = document.getElementById('btnShareWhatsApp');
    if (shareBtn) {
        shareBtn.addEventListener('click', function () {
            const title = this.getAttribute('data-title');
            const date = this.getAttribute('data-date');
            const venue = this.getAttribute('data-venue');
            const url = window.location.href;

            const text = encodeURIComponent(
                `📢 *${title}*\n\n` +
                `🗓 Date: ${date}\n` +
                `📍 Venue: ${venue}\n\n` +
                `👉 View complete details & register officially on CampusConnect:\n${url}`
            );

            window.open(`https://api.whatsapp.com/send?text=${text}`, '_blank');
        });
    }

    const copyBtn = document.getElementById('btnCopyLink');
    if (copyBtn) {
        copyBtn.addEventListener('click', function () {
            navigator.clipboard.writeText(window.location.href).then(() => {
                const originalText = copyBtn.innerText;
                copyBtn.innerText = 'Copied to Clipboard!';
                setTimeout(() => {
                    copyBtn.innerText = originalText;
                }, 2000);
            });
        });
    }
}

/**
 * Filter events by selected campus club or organizing body
 */
function filterByClub(clubName) {
    const searchInput = document.getElementById('clientSearchInput');
    if (searchInput) {
        searchInput.value = clubName;
        // Trigger input event to invoke real-time client filter
        searchInput.dispatchEvent(new Event('input', { bubbles: true }));
        searchInput.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    } else {
        window.location.href = contextPath + '/dashboard?search=' + encodeURIComponent(clubName);
    }
}

