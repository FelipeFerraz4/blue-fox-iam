<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        ${msg("loginTitle")}
    <#elseif section = "form">
        <#if realm.password>
            <form id="kc-form-login" class="bf-form" action="${url.loginAction}" method="post" onsubmit="const btn = document.getElementById('kc-login'); if(btn){ btn.disabled = true; btn.innerText = '${msg("bfAuthenticating")}'; } return true;">
                
                <#-- Campo de Usuário ou E-mail -->
                <#if !usernameHidden??>
                    <div class="bf-form-group">
                        <label for="username" class="bf-label">
                            <#if !realm.loginWithEmailAllowed>
                                ${msg("username")}
                            <#elseif !realm.registrationEmailAsUsername>
                                ${msg("usernameOrEmail")}
                            <#else>
                                ${msg("bfCorporateEmail")}
                            </#if>
                        </label>
                        <div class="bf-input-wrapper">
                            <span class="bf-input-icon">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                            </span>
                            <input tabindex="1" 
                                   id="username" 
                                   class="bf-input <#if messagesPerField.existsError('username','password')>bf-input-error</#if>" 
                                   name="username" 
                                   value="${(login.username!'')}" 
                                   type="text" 
                                   autofocus 
                                   autocomplete="username" 
                                   placeholder="${msg('bfEmailPlaceholder')}"
                                   dir="ltr" />
                        </div>
                    </div>
                </#if>

                <#-- Campo de Senha com alternador de visibilidade -->
                <div class="bf-form-group">
                    <div class="bf-label-row">
                        <label for="password" class="bf-label">${msg("bfPasswordLabel")}</label>
                    </div>
                    <div class="bf-input-wrapper">
                        <span class="bf-input-icon">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                            </svg>
                        </span>
                        <input tabindex="2" 
                               id="password" 
                               class="bf-input bf-input-password <#if messagesPerField.existsError('username','password')>bf-input-error</#if>" 
                               name="password" 
                               type="password" 
                               autocomplete="current-password" 
                               placeholder="${msg('bfPasswordPlaceholder')}" />
                        
                        <button type="button" 
                                class="bf-password-toggle" 
                                id="bf-pwd-toggle" 
                                aria-label="${msg('bfShowPassword')}"
                                onclick="togglePasswordVisibility()">
                            <svg id="bf-eye-open" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                            </svg>
                            <svg id="bf-eye-closed" style="display:none;" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                <line x1="1" y1="1" x2="23" y2="23"></line>
                            </svg>
                        </button>
                    </div>

                    <#if messagesPerField.existsError('username','password')>
                        <div class="bf-field-error">
                            ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                        </div>
                    </#if>
                </div>

                <#-- Opções: Lembrar de mim e Esqueci a senha -->
                <div class="bf-form-options">
                    <#if realm.rememberMe && !usernameHidden??>
                        <label class="bf-checkbox-label">
                            <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMe??>checked</#if>>
                            <span class="bf-checkbox-custom"></span>
                            <span class="bf-checkbox-text">${msg("rememberMe")}</span>
                        </label>
                    <#else>
                        <div></div>
                    </#if>

                    <#if realm.resetPasswordAllowed>
                        <a tabindex="4" class="bf-link" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
                    </#if>
                </div>

                <#-- Botão de Envio Principal (Gradiente Pílula) -->
                <div class="bf-form-actions">
                    <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                    <button tabindex="5" class="bf-btn-primary" name="login" id="kc-login" type="submit">
                        <span>${msg("doLogIn")}</span>
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </button>
                </div>
            </form>

            <script>
                function togglePasswordVisibility() {
                    const pwd = document.getElementById('password');
                    const eyeOpen = document.getElementById('bf-eye-open');
                    const eyeClosed = document.getElementById('bf-eye-closed');
                    if (pwd.type === 'password') {
                        pwd.type = 'text';
                        eyeOpen.style.display = 'none';
                        eyeClosed.style.display = 'block';
                    } else {
                        pwd.type = 'password';
                        eyeOpen.style.display = 'block';
                        eyeClosed.style.display = 'none';
                    }
                }
            </script>
        </#if>
    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div class="bf-register-prompt">
                <span>${msg("bfNoAccount")}</span>
                <a tabindex="6" class="bf-link-highlight" href="${url.registrationUrl}">${msg("doRegister")}</a>
            </div>
        </#if>
    <#elseif section = "socialProviders" >
        <#if realm.password && social?? && social.providers?has_content>
            <div class="bf-social-section">
                <div class="bf-divider">
                    <span>${msg("bfSocialDivider")}</span>
                </div>
                <div class="bf-social-grid">
                    <#list social.providers as p>
                        <a id="social-${p.alias}" class="bf-social-btn" href="${p.loginUrl}">
                            <#if p.iconClasses?has_content>
                                <i class="${properties.kcCommonLogoIdP!} ${p.iconClasses!}"></i>
                            </#if>
                            <span>${p.displayName!}</span>
                        </a>
                    </#list>
                </div>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>
