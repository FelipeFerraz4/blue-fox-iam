<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html lang="${(locale.currentLanguageTag)!lang!'pt'}"<#if realm.internationalizationEnabled?? && realm.internationalizationEnabled> dir="${(locale.rtl)?then('rtl','ltr')}"</#if>>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="robots" content="noindex, nofollow" />

    <title><#nested "header"> | Blue Fox</title>
    <link rel="icon" href="${url.resourcesPath}/img/logo.png" type="image/png" />

    <#-- Google Fonts: Outfit (Display & Títulos) + Inter (Corpo & Inputs) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap" rel="stylesheet">

    <#-- Folhas de estilo do tema com cache buster -->
    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}?v=2.0" rel="stylesheet" />
        </#list>
    </#if>

    <#-- Estilos críticos do Dropdown e Top Bar embutidos para imunidade total contra cache -->
    <style id="bf-critical-dropdown-styles">
        .bf-top-nav {
            display: flex !important;
            justify-content: space-between !important;
            align-items: center !important;
            gap: 12px !important;
            width: 100% !important;
            position: relative !important;
            z-index: 50 !important;
        }

        .bf-back-btn {
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            padding: 8px 16px !important;
            border-radius: 9999px !important;
            background: rgba(28, 37, 65, 0.65) !important;
            backdrop-filter: blur(12px) !important;
            -webkit-backdrop-filter: blur(12px) !important;
            border: 1px solid rgba(56, 182, 255, 0.25) !important;
            color: #cbd5e1 !important;
            text-decoration: none !important;
            font-size: 0.85rem !important;
            font-weight: 500 !important;
            transition: all 0.25s ease !important;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2) !important;
        }

        .bf-back-btn:hover {
            background: rgba(56, 182, 255, 0.15) !important;
            border-color: #38b6ff !important;
            color: #ffffff !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 6px 16px rgba(56, 182, 255, 0.25) !important;
        }

        .bf-lang-dropdown {
            position: relative !important;
            display: inline-block !important;
            user-select: none !important;
            z-index: 60 !important;
        }

        .bf-lang-trigger {
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            padding: 8px 14px !important;
            border-radius: 9999px !important;
            background: rgba(28, 37, 65, 0.65) !important;
            backdrop-filter: blur(12px) !important;
            -webkit-backdrop-filter: blur(12px) !important;
            border: 1px solid rgba(56, 182, 255, 0.25) !important;
            color: #cbd5e1 !important;
            font-family: inherit !important;
            font-size: 0.85rem !important;
            font-weight: 500 !important;
            cursor: pointer !important;
            outline: none !important;
            transition: all 0.25s ease !important;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2) !important;
        }

        .bf-lang-trigger:hover,
        .bf-lang-dropdown.is-open .bf-lang-trigger {
            background: rgba(56, 182, 255, 0.15) !important;
            border-color: #38b6ff !important;
            color: #ffffff !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 6px 16px rgba(56, 182, 255, 0.25) !important;
        }

        .bf-lang-globe-icon {
            color: #38b6ff !important;
            flex-shrink: 0 !important;
        }

        .bf-lang-current-flag {
            font-size: 1rem !important;
            line-height: 1 !important;
        }

        .bf-lang-current-label {
            font-weight: 500 !important;
            max-width: 140px !important;
            overflow: hidden !important;
            text-overflow: ellipsis !important;
            white-space: nowrap !important;
        }

        .bf-lang-chevron {
            transition: transform 0.25s ease !important;
            color: #94a3b8 !important;
            margin-left: 2px !important;
        }

        .bf-lang-dropdown.is-open .bf-lang-chevron {
            transform: rotate(180deg) !important;
            color: #38b6ff !important;
        }

        .bf-lang-menu {
            position: absolute !important;
            top: calc(100% + 8px) !important;
            right: 0 !important;
            width: 290px !important;
            max-width: calc(100vw - 32px) !important;
            background: rgba(17, 26, 54, 0.96) !important;
            backdrop-filter: blur(20px) !important;
            -webkit-backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(56, 182, 255, 0.3) !important;
            border-radius: 18px !important;
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.55), 0 0 30px rgba(0, 74, 173, 0.25) !important;
            padding: 12px !important;
            z-index: 1000 !important;
            display: none !important;
            flex-direction: column !important;
            gap: 8px !important;
        }

        .bf-lang-dropdown.is-open .bf-lang-menu {
            display: flex !important;
            animation: bfDropdownFadeIn 0.2s cubic-bezier(0.16, 1, 0.3, 1) !important;
        }

        @keyframes bfDropdownFadeIn {
            from {
                opacity: 0;
                transform: translateY(-8px) scale(0.97);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .bf-lang-search-wrapper {
            position: relative !important;
            display: flex !important;
            align-items: center !important;
            background: rgba(11, 19, 43, 0.85) !important;
            border: 1px solid rgba(255, 255, 255, 0.12) !important;
            border-radius: 10px !important;
            padding: 2px 8px !important;
            transition: all 0.2s ease !important;
        }

        .bf-lang-search-wrapper:focus-within {
            border-color: #38b6ff !important;
            box-shadow: 0 0 0 2px rgba(56, 182, 255, 0.25) !important;
            background: rgba(11, 19, 43, 0.98) !important;
        }

        .bf-lang-search-icon {
            color: #64748b !important;
            flex-shrink: 0 !important;
            margin-right: 6px !important;
        }

        .bf-lang-search-input {
            width: 100% !important;
            background: transparent !important;
            border: none !important;
            outline: none !important;
            color: #ffffff !important;
            font-family: inherit !important;
            font-size: 0.82rem !important;
            padding: 8px 4px !important;
        }

        .bf-lang-search-input::placeholder {
            color: #64748b !important;
        }

        .bf-lang-search-clear {
            background: none !important;
            border: none !important;
            color: #94a3b8 !important;
            font-size: 1.1rem !important;
            cursor: pointer !important;
            padding: 0 4px !important;
            line-height: 1 !important;
        }

        .bf-lang-search-clear:hover {
            color: #ffffff !important;
        }

        .bf-lang-list {
            list-style: none !important;
            max-height: 250px !important;
            overflow-y: auto !important;
            overflow-x: hidden !important;
            display: flex !important;
            flex-direction: column !important;
            gap: 4px !important;
            padding-right: 2px !important;
            margin: 0 !important;
            padding-left: 0 !important;
        }

        .bf-lang-list::-webkit-scrollbar {
            width: 5px !important;
        }

        .bf-lang-list::-webkit-scrollbar-thumb {
            background: rgba(56, 182, 255, 0.3) !important;
            border-radius: 4px !important;
        }

        .bf-lang-item {
            border-radius: 10px !important;
            transition: background-color 0.18s ease !important;
            list-style: none !important;
        }

        .bf-lang-item:hover {
            background: rgba(56, 182, 255, 0.12) !important;
        }

        .bf-lang-item.is-active {
            background: rgba(0, 74, 173, 0.35) !important;
            border: 1px solid rgba(56, 182, 255, 0.3) !important;
        }

        .bf-lang-link {
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
            padding: 8px 10px !important;
            text-decoration: none !important;
            color: #e2e8f0 !important;
            width: 100% !important;
        }

        .bf-lang-item-flag {
            font-size: 1.15rem !important;
            line-height: 1 !important;
            flex-shrink: 0 !important;
        }

        .bf-lang-item-text {
            flex: 1 !important;
            display: flex !important;
            flex-direction: column !important;
            min-width: 0 !important;
        }

        .bf-lang-item-name {
            font-size: 0.84rem !important;
            font-weight: 600 !important;
            color: #ffffff !important;
            white-space: nowrap !important;
            overflow: hidden !important;
            text-overflow: ellipsis !important;
        }

        .bf-lang-item-sub {
            font-size: 0.72rem !important;
            color: #94a3b8 !important;
            white-space: nowrap !important;
            overflow: hidden !important;
            text-overflow: ellipsis !important;
        }

        .bf-lang-item-badge {
            font-size: 0.68rem !important;
            font-weight: 700 !important;
            letter-spacing: 0.04em !important;
            padding: 2px 6px !important;
            border-radius: 6px !important;
            background: rgba(255, 255, 255, 0.08) !important;
            color: #94a3b8 !important;
            flex-shrink: 0 !important;
        }

        .bf-lang-item.is-active .bf-lang-item-badge {
            background: rgba(56, 182, 255, 0.2) !important;
            color: #38b6ff !important;
        }

        .bf-lang-check-icon {
            color: #38b6ff !important;
            flex-shrink: 0 !important;
        }

        .bf-lang-empty {
            padding: 16px 8px !important;
            text-align: center !important;
            font-size: 0.8rem !important;
            color: #94a3b8 !important;
        }
    </style>
</head>

<body class="bf-login-body ${bodyClass!}">
    <#-- Elementos de iluminação ambiente no fundo -->
    <div class="bf-ambient-glow bf-ambient-glow-1"></div>
    <div class="bf-ambient-glow bf-ambient-glow-2"></div>

    <div class="bf-page-container">
        <#-- Barra superior com Botão Voltar e Seletor de Idioma -->
        <#assign clientTargetName = (client.name)!(client.clientId)!msg("bfDefaultApp")>
        <#assign clientTargetUrl = (client.rootUrl)!(client.baseUrl)!''>
        <#if clientTargetUrl?ends_with("/*")>
            <#assign clientTargetUrl = clientTargetUrl?keep_before_last("/*")>
        <#elseif clientTargetUrl?ends_with("*")>
            <#assign clientTargetUrl = clientTargetUrl?keep_before_last("*")>
        </#if>

        <#-- Definição dos 9 idiomas suportados com metadados -->
        <#assign bfSupportedLanguages = [
            { "tag": "pt-BR", "altTag": "pt", "name": "Português (Brasil)", "sub": "Portuguese", "flag": "🇧🇷", "search": "portugues brasil portuguese brazil pt pt-br" },
            { "tag": "en", "altTag": "en", "name": "English (US)", "sub": "Inglês", "flag": "🇺🇸", "search": "english ingles american united states en us" },
            { "tag": "es", "altTag": "es", "name": "Español", "sub": "Spanish / Espanhol", "flag": "🇪🇸", "search": "espanol spanish castellano spain es" },
            { "tag": "de", "altTag": "de", "name": "Deutsch", "sub": "German / Alemão", "flag": "🇩🇪", "search": "deutsch german alemao germany de" },
            { "tag": "fr", "altTag": "fr", "name": "Français", "sub": "French / Francês", "flag": "🇫🇷", "search": "francais french frances france fr" },
            { "tag": "it", "altTag": "it", "name": "Italiano", "sub": "Italian / Italiano", "flag": "🇮🇹", "search": "italiano italian italia it" },
            { "tag": "ja", "altTag": "ja", "name": "日本語", "sub": "Japanese / Japonês", "flag": "🇯🇵", "search": "日本語 nihongo japanese japones japan ja jp" },
            { "tag": "zh-CN", "altTag": "zh", "name": "简体中文", "sub": "Chinese / Chinês", "flag": "🇨🇳", "search": "简体中文 chinese chines zhongwen china zh zh-cn" },
            { "tag": "ko", "altTag": "ko", "name": "한국어", "sub": "Korean / Coreano", "flag": "🇰🇷", "search": "한국어 hangugeo korean coreano korea ko kr" }
        ]>

        <#-- Identifica bandeira e rótulo do idioma corrente -->
        <#assign currentFlag = "🇧🇷">
        <#assign currentName = "Português (Brasil)">
        <#assign curLocaleTag = (locale.currentLanguageTag)!(locale.current)!'pt'>
        <#list bfSupportedLanguages as langItem>
            <#if curLocaleTag?lower_case == langItem.tag?lower_case || curLocaleTag?lower_case == langItem.altTag?lower_case || ((locale.current)!'')?lower_case?contains(langItem.tag?lower_case)>
                <#assign currentFlag = langItem.flag>
                <#assign currentName = langItem.name>
            </#if>
        </#list>

        <div class="bf-top-nav">
            <a href="<#if clientTargetUrl?has_content>${clientTargetUrl}<#else>javascript:history.back()</#if>" 
               class="bf-back-btn" 
               id="bf-back-to-app-btn"
               title="${msg('bfBackToAppTitle', clientTargetName)}"
               onclick="if (window.history.length > 1) { window.history.back(); return false; }">
                <svg class="bf-back-icon" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                <span>${msg('bfBackToApp', clientTargetName)?no_esc}</span>
            </a>

            <#-- Dropdown de Idiomas com Busca -->
            <#if realm.internationalizationEnabled?? && realm.internationalizationEnabled>
                <div class="bf-lang-dropdown" id="bf-lang-dropdown">
                    <button type="button" 
                            class="bf-lang-trigger" 
                            id="bf-lang-trigger" 
                            aria-haspopup="listbox" 
                            aria-expanded="false" 
                            aria-label="${msg('bfLanguage')}: ${currentName}">
                        <svg class="bf-lang-globe-icon" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="2" y1="12" x2="22" y2="12"></line>
                            <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                        </svg>
                        <span class="bf-lang-current-flag">${currentFlag}</span>
                        <span class="bf-lang-current-label">${currentName}</span>
                        <svg class="bf-lang-chevron" viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="6 9 12 15 18 9"></polyline>
                        </svg>
                    </button>

                    <div class="bf-lang-menu" id="bf-lang-menu" role="listbox" aria-label="${msg('bfSelectLanguage')}">
                        <div class="bf-lang-search-wrapper">
                            <svg class="bf-lang-search-icon" viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            <input type="text" 
                                   id="bf-lang-search-input" 
                                   class="bf-lang-search-input" 
                                   placeholder="${msg('bfSearchLanguage')}" 
                                   autocomplete="off" 
                                   spellcheck="false" />
                            <button type="button" id="bf-lang-search-clear" class="bf-lang-search-clear" style="display:none;" aria-label="Limpar">
                                &times;
                            </button>
                        </div>

                        <ul class="bf-lang-list" id="bf-lang-list">
                            <#-- Renderização nativa dos 9 idiomas direto do servidor -->
                            <#list bfSupportedLanguages as langItem>
                                <#assign langUrl = "?kc_locale=" + langItem.tag>
                                <#if locale?? && locale.supported??>
                                    <#list locale.supported as l>
                                        <#if (l.languageTag!'') == langItem.tag || (l.languageTag!'') == langItem.altTag || (l.label!'') == langItem.name>
                                            <#assign langUrl = l.url>
                                        </#if>
                                    </#list>
                                </#if>
                                <#assign isCurrent = (curLocaleTag?lower_case == langItem.tag?lower_case || curLocaleTag?lower_case == langItem.altTag?lower_case)>
                                <li class="bf-lang-item<#if isCurrent> is-active</#if>" data-search="${langItem.search} ${langItem.name?lower_case}" role="option" aria-selected="${isCurrent?then('true','false')}">
                                    <a class="bf-lang-link" href="${langUrl}">
                                        <span class="bf-lang-item-flag">${langItem.flag}</span>
                                        <div class="bf-lang-item-text">
                                            <span class="bf-lang-item-name">${langItem.name}</span>
                                            <span class="bf-lang-item-sub">${langItem.sub}</span>
                                        </div>
                                        <span class="bf-lang-item-badge">${langItem.tag?upper_case}</span>
                                        <#if isCurrent>
                                            <svg class="bf-lang-check-icon" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                                <polyline points="20 6 9 17 4 12"></polyline>
                                            </svg>
                                        </#if>
                                    </a>
                                </li>
                            </#list>
                        </ul>

                        <div class="bf-lang-empty" id="bf-lang-empty" style="display:none;">
                            <span>${msg('bfNoLanguageFound')}</span>
                        </div>
                    </div>
                </div>
            </#if>
        </div>

        <#-- Card Principal Glassmorphism -->
        <main class="bf-card">
            <header class="bf-card-header">
                <div class="bf-logo-wrapper">
                    <img src="${url.resourcesPath}/img/logo.png" alt="Blue Fox Logo" class="bf-logo" />
                </div>
                <h1 class="bf-title"><#nested "header"></h1>
                <p class="bf-subtitle">${msg("bfSubtitle")}</p>
            </header>

            <#-- Exibição de alertas e mensagens do sistema -->
            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="bf-alert bf-alert-${message.type}" role="alert">
                    <div class="bf-alert-icon">
                        <#if message.type = 'error'>
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                        <#elseif message.type = 'success'>
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                        <#elseif message.type = 'warning'>
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                                <line x1="12" y1="9" x2="12" y2="13"></line>
                                <line x1="12" y1="17" x2="12.01" y2="17"></line>
                            </svg>
                        <#else>
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                        </#if>
                    </div>
                    <div class="bf-alert-text">
                        ${kcSanitize(message.summary)?no_esc}
                    </div>
                </div>
            </#if>

            <#-- Formulário -->
            <div class="bf-form-content">
                <#nested "form">
            </div>

            <#-- Provedores sociais (IDPs) se configurados -->
            <#nested "socialProviders">

            <#-- Informações adicionais (ex: link de cadastro) -->
            <#if displayInfo>
                <div class="bf-info-content">
                    <#nested "info">
                </div>
            </#if>

            <footer class="bf-card-footer">
                <span>${msg("bfCopyright")}</span>
            </footer>
        </main>
    </div>

    <#-- Script de controle do Seletor de Idiomas (busca e dropdown) -->
    <#if realm.internationalizationEnabled?? && realm.internationalizationEnabled>
    <script>
        (function() {
            var dropdown = document.getElementById('bf-lang-dropdown');
            var trigger = document.getElementById('bf-lang-trigger');
            var searchInput = document.getElementById('bf-lang-search-input');
            var searchClear = document.getElementById('bf-lang-search-clear');
            var listElem = document.getElementById('bf-lang-list');
            var emptyElem = document.getElementById('bf-lang-empty');

            if (!dropdown || !trigger) return;

            function toggleDropdown(e) {
                if (e) e.stopPropagation();
                var isOpen = dropdown.classList.contains('is-open');
                if (isOpen) {
                    closeDropdown();
                } else {
                    openDropdown();
                }
            }

            function openDropdown() {
                dropdown.classList.add('is-open');
                trigger.setAttribute('aria-expanded', 'true');
                if (searchInput) {
                    searchInput.value = '';
                    filterList('');
                    setTimeout(function() { searchInput.focus(); }, 50);
                }
            }

            function closeDropdown() {
                dropdown.classList.remove('is-open');
                trigger.setAttribute('aria-expanded', 'false');
            }

            function filterList(query) {
                var term = (query || '').trim().toLowerCase();
                var items = listElem ? listElem.querySelectorAll('.bf-lang-item') : [];
                var count = 0;

                for (var i = 0; i < items.length; i++) {
                    var item = items[i];
                    var searchData = item.getAttribute('data-search') || '';
                    if (!term || searchData.indexOf(term) !== -1) {
                        item.style.display = '';
                        count++;
                    } else {
                        item.style.display = 'none';
                    }
                }

                if (emptyElem) {
                    emptyElem.style.display = (count === 0) ? 'block' : 'none';
                }
                if (searchClear) {
                    searchClear.style.display = (term.length > 0) ? 'block' : 'none';
                }
            }

            trigger.addEventListener('click', toggleDropdown);

            document.addEventListener('click', function(e) {
                if (!dropdown.contains(e.target)) {
                    closeDropdown();
                }
            });

            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && dropdown.classList.contains('is-open')) {
                    closeDropdown();
                    trigger.focus();
                }
            });

            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    filterList(this.value);
                });
            }

            if (searchClear) {
                searchClear.addEventListener('click', function(e) {
                    e.stopPropagation();
                    if (searchInput) {
                        searchInput.value = '';
                        filterList('');
                        searchInput.focus();
                    }
                });
            }
        })();
    </script>
    </#if>
</body>
</html>
</#macro>
