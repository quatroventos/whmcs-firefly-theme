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

    {* Remove cart-sidebar (Ações) da página do carrinho – elimina do DOM *}
    <script>
    (function() {
        document.addEventListener('DOMContentLoaded', function() {
            var sidebar = document.querySelector('.cart-sidebar');
            if (sidebar) {
                var col = sidebar.closest('[class*="col"]');
                if (col) col.remove();
                else sidebar.remove();
            }
        });
    })();
    </script>

    {* Formulário domínio: abas lado a lado, padrão = Usar meu domínio *}
    <script>
    (function() {
        function initDomainTabs() {
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
            var labelOwn = (optOwn.querySelector('label') || {}).textContent || 'Vou utilizar meu domínio atual';
            var labelReg = (optRegister.querySelector('label') || {}).textContent || 'Registrar um novo domínio';
            tabsWrap.innerHTML = '<button type="button" class="tab active" data-option="owndomain">' + (labelOwn.replace(/\s+/g, ' ').trim()) + '</button>' +
                '<button type="button" class="tab" data-option="register">' + (labelReg.replace(/\s+/g, ' ').trim()) + '</button>';
            container.insertBefore(tabsWrap, optRegister);

            var panelsWrap = document.createElement('div');
            panelsWrap.className = 'domain-tab-panels';
            optRegister.parentNode.insertBefore(panelsWrap, optRegister);
            panelsWrap.appendChild(optRegister);
            panelsWrap.appendChild(optOwn);

            function showOption(optionValue) {
                var isOwn = optionValue === 'owndomain';
                radioOwn.checked = isOwn;
                radioRegister.checked = !isOwn;
                optOwn.classList.toggle('active', isOwn);
                optRegister.classList.toggle('active', !isOwn);
                tabsWrap.querySelectorAll('.tab').forEach(function(t) {
                    t.classList.toggle('active', t.getAttribute('data-option') === optionValue);
                });
            }
            showOption('owndomain');

            tabsWrap.addEventListener('click', function(e) {
                var tab = e.target.closest('.tab');
                if (!tab) return;
                showOption(tab.getAttribute('data-option'));
            });
        }
        function runWhenReady() {
            initDomainTabs();
            var form = document.getElementById('frmProductDomain');
            if (form && !form.querySelector('.domain-tabs') && form.querySelector('.domain-selection-options')) {
                setTimeout(initDomainTabs, 100);
            }
        }
        document.addEventListener('DOMContentLoaded', runWhenReady);
        if (document.readyState === 'complete') runWhenReady();
    })();
    </script>

    {$footeroutput}

</body>
</html>
