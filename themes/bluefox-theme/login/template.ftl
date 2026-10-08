<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html lang="${lang!'pt'}"<#if realm.internationalizationEnabled?? && realm.internationalizationEnabled> dir="${(locale.rtl)?then('rtl','ltr')}"</#if>>
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

    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>

<body class="bf-login-body ${bodyClass!}">
    <#-- Elementos de iluminação ambiente no fundo -->
    <div class="bf-ambient-glow bf-ambient-glow-1"></div>
    <div class="bf-ambient-glow bf-ambient-glow-2"></div>

    <div class="bf-page-container">
        <#-- Barra superior com Botão Voltar para a aplicação de origem -->
        <#assign clientTargetName = (client.name)!(client.clientId)!'aplicativo'>
        <#assign clientTargetUrl = (client.rootUrl)!(client.baseUrl)!''>
        <#if clientTargetUrl?ends_with("/*")>
            <#assign clientTargetUrl = clientTargetUrl?keep_before_last("/*")>
        <#elseif clientTargetUrl?ends_with("*")>
            <#assign clientTargetUrl = clientTargetUrl?keep_before_last("*")>
        </#if>

        <div class="bf-top-nav">
            <a href="<#if clientTargetUrl?has_content>${clientTargetUrl}<#else>javascript:history.back()</#if>" 
               class="bf-back-btn" 
               id="bf-back-to-app-btn"
               title="Retornar para ${clientTargetName}"
               onclick="if (window.history.length > 1) { window.history.back(); return false; }">
                <svg class="bf-back-icon" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                <span>Voltar para <strong>${clientTargetName}</strong></span>
            </a>
        </div>

        <#-- Card Principal Glassmorphism -->
        <main class="bf-card">
            <header class="bf-card-header">
                <div class="bf-logo-wrapper">
                    <img src="${url.resourcesPath}/img/logo.png" alt="Blue Fox Logo" class="bf-logo" />
                </div>
                <h1 class="bf-title"><#nested "header"></h1>
                <p class="bf-subtitle">Identidade Corporativa Unificada</p>
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
                                <line x1="12" y1="16" x2="12" y2="12"></line>
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
                <span>&copy; 2026 Blue Fox Global Group &bull; Todos os direitos reservados.</span>
            </footer>
        </main>
    </div>
</body>
</html>
</#macro>
