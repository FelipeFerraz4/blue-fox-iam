/**
 * Blue Fox Design System - Language Selector with Search
 * Keycloak Login Theme
 */

(function() {
    'use strict';

    const languages = [
        { tag: 'pt-BR', altTags: ['pt', 'pt_BR'], name: 'Português (Brasil)', secondary: 'Portuguese', flag: '🇧🇷', search: 'portugues brasil portuguese brazil pt pt-br' },
        { tag: 'en', altTags: ['en-US', 'en_US'], name: 'English (US)', secondary: 'Inglês', flag: '🇺🇸', search: 'english ingles american united states en us' },
        { tag: 'es', altTags: ['es-ES', 'es_ES'], name: 'Español', secondary: 'Spanish / Espanhol', flag: '🇪🇸', search: 'espanol spanish castellano spain es' },
        { tag: 'de', altTags: ['de-DE', 'de_DE'], name: 'Deutsch', secondary: 'German / Alemão', flag: '🇩🇪', search: 'deutsch german alemao germany de' },
        { tag: 'fr', altTags: ['fr-FR', 'fr_FR'], name: 'Français', secondary: 'French / Francês', flag: '🇫🇷', search: 'francais french frances france fr' },
        { tag: 'it', altTags: ['it-IT', 'it_IT'], name: 'Italiano', secondary: 'Italian / Italiano', flag: '🇮🇹', search: 'italiano italian italia it' },
        { tag: 'ja', altTags: ['ja-JP', 'ja_JP'], name: '日本語', secondary: 'Japanese / Japonês', flag: '🇯🇵', search: '日本語 nihongo japanese japones japan ja jp' },
        { tag: 'zh-CN', altTags: ['zh', 'zh_Hans', 'zh-Hans', 'zh_CN'], name: '简体中文', secondary: 'Chinese / Chinês', flag: '🇨🇳', search: '简体中文 chinese chines zhongwen china zh zh-cn' },
        { tag: 'ko', altTags: ['ko-KR', 'ko_KR'], name: '한국어', secondary: 'Korean / Coreano', flag: '🇰🇷', search: '한국어 hangugeo korean coreano korea ko kr' }
    ];

    function initLanguageSelector() {
        const dropdown = document.getElementById('bf-lang-dropdown');
        if (!dropdown) return;

        const trigger = document.getElementById('bf-lang-trigger');
        const listElem = document.getElementById('bf-lang-list');
        const searchInput = document.getElementById('bf-lang-search-input');
        const searchClear = document.getElementById('bf-lang-search-clear');
        const emptyElem = document.getElementById('bf-lang-empty');
        const flagElem = document.getElementById('bf-current-flag');
        const labelElem = document.getElementById('bf-current-label');

        const currentTag = (window.BF_CURRENT_LOCALE_TAG || 'pt-BR').toLowerCase();
        const currentName = (window.BF_CURRENT_LOCALE_NAME || '').toLowerCase();

        // Identifica idioma ativo
        const activeLang = languages.find(function(l) {
            const tagMatch = l.tag.toLowerCase() === currentTag || (l.altTags && l.altTags.some(function(t) { return t.toLowerCase() === currentTag; }));
            const nameMatch = l.name.toLowerCase() === currentName || currentName.indexOf(l.tag.toLowerCase()) !== -1;
            return tagMatch || nameMatch;
        }) || languages[0];

        if (flagElem) flagElem.textContent = activeLang.flag;
        if (labelElem) labelElem.textContent = activeLang.name;

        function buildLocaleUrl(lang) {
            if (window.BF_LOCALE_MAP) {
                if (window.BF_LOCALE_MAP[lang.tag]) return window.BF_LOCALE_MAP[lang.tag];
                if (lang.altTags) {
                    for (let i = 0; i < lang.altTags.length; i++) {
                        const alt = lang.altTags[i];
                        if (window.BF_LOCALE_MAP[alt]) return window.BF_LOCALE_MAP[alt];
                    }
                }
            }
            try {
                const url = new URL(window.location.href);
                url.searchParams.set('kc_locale', lang.tag);
                return url.toString();
            } catch (e) {
                return '?kc_locale=' + encodeURIComponent(lang.tag);
            }
        }

        // Renderiza lista de idiomas
        if (listElem) {
            listElem.innerHTML = '';
            languages.forEach(function(lang) {
                const isActive = (lang.tag === activeLang.tag);
                const li = document.createElement('li');
                li.className = 'bf-lang-item' + (isActive ? ' is-active' : '');
                li.setAttribute('data-search', (lang.name + ' ' + lang.secondary + ' ' + lang.search + ' ' + lang.tag).toLowerCase());
                li.setAttribute('role', 'option');
                li.setAttribute('aria-selected', isActive ? 'true' : 'false');

                const link = document.createElement('a');
                link.className = 'bf-lang-link';
                link.href = buildLocaleUrl(lang);

                // Flag
                const spanFlag = document.createElement('span');
                spanFlag.className = 'bf-lang-item-flag';
                spanFlag.textContent = lang.flag;
                link.appendChild(spanFlag);

                // Text
                const divText = document.createElement('div');
                divText.className = 'bf-lang-item-text';
                
                const spanName = document.createElement('span');
                spanName.className = 'bf-lang-item-name';
                spanName.textContent = lang.name;
                divText.appendChild(spanName);

                const spanSub = document.createElement('span');
                spanSub.className = 'bf-lang-item-sub';
                spanSub.textContent = lang.secondary;
                divText.appendChild(spanSub);

                link.appendChild(divText);

                // Badge
                const spanBadge = document.createElement('span');
                spanBadge.className = 'bf-lang-item-badge';
                spanBadge.textContent = lang.tag.toUpperCase();
                link.appendChild(spanBadge);

                // Active check icon
                if (isActive) {
                    const checkSvg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
                    checkSvg.setAttribute('class', 'bf-lang-check-icon');
                    checkSvg.setAttribute('viewBox', '0 0 24 24');
                    checkSvg.setAttribute('width', '16');
                    checkSvg.setAttribute('height', '16');
                    checkSvg.setAttribute('fill', 'none');
                    checkSvg.setAttribute('stroke', 'currentColor');
                    checkSvg.setAttribute('stroke-width', '2.5');
                    checkSvg.setAttribute('stroke-linecap', 'round');
                    checkSvg.setAttribute('stroke-linejoin', 'round');

                    const poly = document.createElementNS('http://www.w3.org/2000/svg', 'polyline');
                    poly.setAttribute('points', '20 6 9 17 4 12');
                    checkSvg.appendChild(poly);

                    link.appendChild(checkSvg);
                }

                li.appendChild(link);
                listElem.appendChild(li);
            });
        }

        function filterLanguages(query) {
            const term = (query || '').trim().toLowerCase();
            const items = listElem ? listElem.querySelectorAll('.bf-lang-item') : [];
            let visibleCount = 0;

            for (let i = 0; i < items.length; i++) {
                const item = items[i];
                const searchData = item.getAttribute('data-search') || '';
                if (!term || searchData.indexOf(term) !== -1) {
                    item.style.display = '';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            }

            if (emptyElem) {
                emptyElem.style.display = (visibleCount === 0) ? 'block' : 'none';
            }

            if (searchClear) {
                searchClear.style.display = (term.length > 0) ? 'block' : 'none';
            }
        }

        function openDropdown() {
            dropdown.classList.add('is-open');
            if (trigger) trigger.setAttribute('aria-expanded', 'true');
            if (searchInput) {
                searchInput.value = '';
                filterLanguages('');
                setTimeout(function() { searchInput.focus(); }, 60);
            }
        }

        function closeDropdown() {
            dropdown.classList.remove('is-open');
            if (trigger) trigger.setAttribute('aria-expanded', 'false');
        }

        if (trigger) {
            trigger.addEventListener('click', function(e) {
                e.stopPropagation();
                if (dropdown.classList.contains('is-open')) {
                    closeDropdown();
                } else {
                    openDropdown();
                }
            });
        }

        document.addEventListener('click', function(e) {
            if (dropdown && !dropdown.contains(e.target)) {
                closeDropdown();
            }
        });

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && dropdown && dropdown.classList.contains('is-open')) {
                closeDropdown();
                if (trigger) trigger.focus();
            }
        });

        if (searchInput) {
            searchInput.addEventListener('input', function() {
                filterLanguages(this.value);
            });
        }

        if (searchClear) {
            searchClear.addEventListener('click', function(e) {
                e.stopPropagation();
                if (searchInput) {
                    searchInput.value = '';
                    filterLanguages('');
                    searchInput.focus();
                }
            });
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initLanguageSelector);
    } else {
        initLanguageSelector();
    }
})();
