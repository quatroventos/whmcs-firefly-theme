                    </div>

                    </div>
                    {if !$inShoppingCart && $secondarySidebar->hasChildren()}
                        <div class="d-lg-none sidebar sidebar-secondary">
                            {include file="$template/includes/sidebar.tpl" sidebar=$secondarySidebar}
                        </div>
                    {/if}
                <div class="clearfix"></div>
            </div>
        </div>
    </section>

    <footer id="footer" class="footer">
        <div class="container">
            <ul class="list-inline text-center float-lg-right">
                {include file="$template/includes/social-accounts.tpl"}

                {if $languagechangeenabled && count($locales) > 1 || $currencies}
                    <li class="list-inline-item">
                        <button type="button" class="btn btn-sm btn-outline-light" data-toggle="modal" data-target="#modalChooseLanguage">
                            <div class="d-inline-block align-middle">
                                <div class="iti-flag {if $activeLocale.countryCode === '001'}us{else}{$activeLocale.countryCode|lower}{/if}"></div>
                            </div>
                            {$activeLocale.localisedName}
                            /
                            {$activeCurrency.prefix}
                            {$activeCurrency.code}
                        </button>
                    </li>
                {/if}
            </ul>

            <ul class="nav justify-content-center justify-content-lg-start">
                <li class="nav-item">
                    <a class="nav-link" href="{$WEB_ROOT}/contact.php">
                        {lang key='contactus'}
                    </a>
                </li>
                {if $acceptTOS}
                    <li class="nav-item">
                        <a class="nav-link" href="{$tosURL}" target="_blank">{lang key='ordertos'}</a>
                    </li>
                {/if}
            </ul>

            <p class="copyright mb-0">
                {lang key="copyrightFooterNotice" year=$date_year company=$companyname}
            </p>
        </div>
    </footer>

    </div><!-- #theme-content -->

    <div id="fullpage-overlay" class="w-hidden">
        <div class="outer-wrapper">
            <div class="inner-wrapper">
                <img src="{$WEB_ROOT}/assets/img/overlay-spinner.svg" alt="">
                <br>
                <span class="msg"></span>
            </div>
        </div>
    </div>

    <div class="modal system-modal fade" id="modalAjax" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">{lang key='close'}</span>
                    </button>
                </div>
                <div class="modal-body">
                    {lang key='loading'}
                </div>
                <div class="modal-footer">
                    <div class="float-left loader">
                        <i class="fas fa-circle-notch fa-spin"></i>
                        {lang key='loading'}
                    </div>
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        {lang key='close'}
                    </button>
                    <button type="button" class="btn btn-primary modal-submit">
                        {lang key='submit'}
                    </button>
                </div>
            </div>
        </div>
    </div>

    <form method="get" action="{$currentpagelinkback}">
        <div class="modal modal-localisation" id="modalChooseLanguage" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        <button type="button" class="close text-light" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>

                        {if $languagechangeenabled && count($locales) > 1}
                            <h5 class="h5 pt-5 pb-3">{lang key='chooselanguage'}</h5>
                            <div class="row item-selector">
                                <input type="hidden" name="language" data-current="{$language}" value="{$language}" />
                                {foreach $locales as $locale}
                                    <div class="col-4">
                                        <a href="#" class="item{if $language == $locale.language} active{/if}" data-value="{$locale.language}">
                                            {$locale.localisedName}
                                        </a>
                                    </div>
                                {/foreach}
                            </div>
                        {/if}
                        {if !$loggedin && $currencies}
                            <p class="h5 pt-5 pb-3">{lang key='choosecurrency'}</p>
                            <div class="row item-selector">
                                <input type="hidden" name="currency" data-current="{$activeCurrency.id}" value="">
                                {foreach $currencies as $selectCurrency}
                                    <div class="col-4">
                                        <a href="#" class="item{if $activeCurrency.id == $selectCurrency.id} active{/if}" data-value="{$selectCurrency.id}">
                                            {$selectCurrency.prefix} {$selectCurrency.code}
                                        </a>
                                    </div>
                                {/foreach}
                            </div>
                        {/if}
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-default">{lang key='apply'}</button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    {if !$loggedin && $adminLoggedIn}
        <a href="{$WEB_ROOT}/logout.php?returntoadmin=1" class="btn btn-return-to-admin" data-toggle="tooltip" data-placement="bottom" title="{if $adminMasqueradingAsClient}{lang key='adminmasqueradingasclient'} {lang key='logoutandreturntoadminarea'}{else}{lang key='adminloggedin'} {lang key='returntoadminarea'}{/if}">
            <i class="fas fa-redo-alt"></i>
            <span class="d-none d-md-inline-block">{lang key="admin.returnToAdmin"}</span>
        </a>
    {/if}

    {include file="$template/includes/generate-password.tpl"}

    {* Remove apenas o bloco cart-sidebar (Ações); esconde a coluna vazia com classe para não remover conteúdo *}
    <script>
    (function() {
        document.addEventListener('DOMContentLoaded', function() {
            var sidebar = document.querySelector('.cart-sidebar');
            if (sidebar) {
                var col = sidebar.closest('[class*="col"]');
                if (col) col.classList.add('cart-sidebar-column-hidden');
                sidebar.remove();
            }
        });
    })();
    </script>

    {* Link "Continuar Comprando" aponta para a página principal do site *}
    <script>
    (function() {
        document.addEventListener('DOMContentLoaded', function() {
            var link = document.getElementById('continueShopping') || document.querySelector('.btn-continue-shopping');
            if (link) link.setAttribute('href', 'https://fireflyhost.com.br');
        });
    })();
    </script>

    {* Esconder seletor de gateway quando há apenas um método de pagamento *}
    <script>
    (function() {
        document.addEventListener('DOMContentLoaded', function() {
            var container = document.getElementById('paymentGatewaysContainer');
            if (!container) return;
            var radios = container.querySelectorAll('input[name="paymentmethod"]');
            if (radios.length === 1) container.style.display = 'none';
        });
    })();
    </script>

    {* Formulário domínio: abas lado a lado, padrão = Usar meu domínio *}
    <script>
    (function() {
        function initDomainTabs() {
            try {
                var form = document.getElementById('frmProductDomain');
                if (!form) return;
                var container = form.querySelector('.domain-selection-options');
                if (!container || container.getAttribute('data-tabs-inited')) return;
                var options = container.querySelectorAll('.option');
                if (options.length < 2) return;

                var optRegister = options[0];
                var optOwn = options[1];
                var radioRegister = form.querySelector('input[name="domainoption"][value="register"]');
                var radioOwn = form.querySelector('input[name="domainoption"][value="owndomain"]');
                if (!radioRegister || !radioOwn) return;

                container.setAttribute('data-tabs-inited', '1');
                optRegister.classList.add('domain-tab-panel');
                optOwn.classList.add('domain-tab-panel');
                optRegister.setAttribute('data-option', 'register');
                optOwn.setAttribute('data-option', 'owndomain');

                var tabsWrap = document.createElement('div');
                tabsWrap.className = 'domain-tabs';
                var labelOwn = (optOwn.querySelector('label') && optOwn.querySelector('label').textContent) ? optOwn.querySelector('label').textContent.replace(/\s+/g, ' ').trim() : 'Vou utilizar meu domínio atual';
                var labelReg = (optRegister.querySelector('label') && optRegister.querySelector('label').textContent) ? optRegister.querySelector('label').textContent.replace(/\s+/g, ' ').trim() : 'Registrar um novo domínio';
                tabsWrap.innerHTML = '<button type="button" class="tab active" data-option="owndomain">' + labelOwn + '</button><button type="button" class="tab" data-option="register">' + labelReg + '</button>';
                container.insertBefore(tabsWrap, optRegister);

                var panelsWrap = document.createElement('div');
                panelsWrap.className = 'domain-tab-panels';
                var parent = optRegister.parentNode;
                if (!parent) return;
                parent.insertBefore(panelsWrap, optRegister);
                panelsWrap.appendChild(optRegister);
                panelsWrap.appendChild(optOwn);

                function showOption(optionValue) {
                    var isOwn = optionValue === 'owndomain';
                    radioOwn.checked = isOwn;
                    radioRegister.checked = !isOwn;
                    optOwn.classList.toggle('active', isOwn);
                    optRegister.classList.toggle('active', !isOwn);
                    var inputGroupOwn = optOwn.querySelector('.domain-input-group');
                    var inputGroupReg = optRegister.querySelector('.domain-input-group');
                    if (inputGroupOwn) inputGroupOwn.style.display = isOwn ? 'block' : 'none';
                    if (inputGroupReg) inputGroupReg.style.display = isOwn ? 'none' : 'block';
                    var tabs = tabsWrap.querySelectorAll('.tab');
                    for (var i = 0; i < tabs.length; i++) {
                        tabs[i].classList.toggle('active', tabs[i].getAttribute('data-option') === optionValue);
                    }
                }
                showOption('owndomain');

                tabsWrap.addEventListener('click', function(e) {
                    var tab = e.target.closest('.tab');
                    if (tab) showOption(tab.getAttribute('data-option'));
                });
            } catch (e) {}
        }
        document.addEventListener('DOMContentLoaded', function() {
            initDomainTabs();
            setTimeout(initDomainTabs, 300);
        });
        if (document.readyState === 'complete') initDomainTabs();
    })();
    </script>

    {* Checkout: botões "Já registrado?" / "Criar uma nova conta" – lado a lado, toggle form, padrão = nova conta *}
    <script>
    (function() {
        function initCheckoutAlreadyRegistered() {
            var btnExisting = document.getElementById('btnAlreadyRegistered');
            var btnNew = document.getElementById('btnNewUserSignup');
            var containerNew = document.getElementById('containerNewUserSignup');
            var containerExisting = document.getElementById('containerExistingUserSignin');
            var inputCustType = document.getElementById('inputCustType');
            if (!btnExisting || !btnNew || !containerNew || !containerExisting) return;

            btnExisting.classList.remove('w-hidden');
            btnNew.classList.remove('w-hidden');

            function showNewUser() {
                containerNew.style.display = '';
                containerExisting.style.display = 'none';
                btnNew.classList.add('active');
                btnExisting.classList.remove('active');
                if (inputCustType) inputCustType.value = 'new';
            }
            function showExistingUser() {
                containerExisting.style.display = '';
                containerNew.style.display = 'none';
                btnExisting.classList.add('active');
                btnNew.classList.remove('active');
                if (inputCustType) inputCustType.value = 'existing';
            }

            showNewUser();

            btnExisting.addEventListener('click', function() { showExistingUser(); });
            btnNew.addEventListener('click', function() { showNewUser(); });
        }
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(initCheckoutAlreadyRegistered, 150);
        });
        if (document.readyState === 'complete') setTimeout(initCheckoutAlreadyRegistered, 150);
    })();
    </script>

    <script>
    (function() {
        var STORAGE_KEY = 'firefly-theme';
        function getTheme() {
            try {
                var wrap = document.getElementById('theme-content');
                if (wrap && wrap.getAttribute('data-force-theme') === 'dark') return 'dark';
                var stored = localStorage.getItem(STORAGE_KEY);
                if (stored) return stored;
                if (wrap && wrap.getAttribute('data-default-theme') === 'light') return 'light';
                return 'dark';
            } catch (e) { return 'dark'; }
        }
        function setTheme(value) {
            try { localStorage.setItem(STORAGE_KEY, value); } catch (e) {}
        }
        function applyTheme(isLight) {
            var wrap = document.getElementById('theme-content');
            if (!wrap) return;
            if (isLight) {
                wrap.classList.add('theme-light');
            } else {
                wrap.classList.remove('theme-light');
            }
            var iconLight = document.querySelectorAll('.theme-icon-light');
            var iconDark = document.querySelectorAll('.theme-icon-dark');
            for (var i = 0; i < iconLight.length; i++) {
                iconLight[i].classList.toggle('d-none', !isLight);
            }
            for (var i = 0; i < iconDark.length; i++) {
                iconDark[i].classList.toggle('d-none', isLight);
            }
            var cb = document.getElementById('theme-toggle-input');
            if (cb) cb.checked = isLight;
        }
        function initTheme() {
            var theme = getTheme();
            applyTheme(theme === 'light');
        }
        document.addEventListener('DOMContentLoaded', function() {
            initTheme();
            var cb = document.getElementById('theme-toggle-input');
            if (cb) {
                cb.addEventListener('change', function() {
                    var isLight = cb.checked;
                    setTheme(isLight ? 'light' : 'dark');
                    applyTheme(isLight);
                });
            }
        });
    })();
    </script>

    {$footeroutput}

</body>
</html>
