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

    {* Modal "aguarde" ao enviar pedido/pagamento no checkout *}
    <div class="modal fade" id="modalOrderProcessing" tabindex="-1" role="dialog" aria-labelledby="modalOrderProcessingTitle" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content modal-order-processing">
                <div class="modal-body modal-order-processing-body">
                    <div class="mb-4">
                        <i class="fas fa-circle-notch fa-spin fa-4x modal-order-processing-spinner" aria-hidden="true"></i>
                    </div>
                    <h5 class="modal-title mb-3" id="modalOrderProcessingTitle">Por favor aguarde</h5>
                    <p class="mb-0">Enquanto configuramos sua conta. Não feche esta janela &mdash; essa operação pode demorar alguns minutos.</p>
                </div>
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

    {* Modal "aguarde" ao clicar para pagar / completar pedido no checkout; some no retorno do JS ou quando aparece erro *}
    <script>
    (function() {
        function hideOrderProcessingModal() {
            if (typeof jQuery !== 'undefined') {
                jQuery('#modalOrderProcessing').modal('hide');
            }
        }
        function initOrderProcessingModal() {
            var form = document.getElementById('frmCheckout');
            var modal = document.getElementById('modalOrderProcessing');
            if (!form || !modal) return;
            var submitted = false;
            form.addEventListener('submit', function handler(e) {
                if (submitted) return;
                var hasPayment = form.querySelector('#paymentGatewaysContainer, #creditCardInputFields, #paymentGatewayInput, [name="ccnumber"], [name="paymentmethod"]');
                var hasCheckoutBtn = (e.submitter && (e.submitter.name === 'checkout' || (e.submitter.value === '1' && e.submitter.name === 'checkout') || /completar|pagar|checkout|pay/i.test((e.submitter.textContent || e.submitter.value || ''))));
                if (!hasPayment && !hasCheckoutBtn) return;
                submitted = true;
                e.preventDefault();
                if (typeof jQuery !== 'undefined' && jQuery(modal).modal) {
                    jQuery(modal).modal('show');
                }
                setTimeout(function() {
                    form.removeEventListener('submit', handler);
                    form.submit();
                }, 150);
            }, false);
        }
        function hookPaymentReset() {
            if (window.WHMCS && WHMCS.payment && WHMCS.payment.event && WHMCS.payment.event.display) {
                var display = WHMCS.payment.event.display;
                if (display.submitReset) {
                    var origSubmitReset = display.submitReset;
                    display.submitReset = function(source) {
                        origSubmitReset.apply(this, arguments);
                        if (source === 'checkout') hideOrderProcessingModal();
                    };
                }
                if (display.errorShow) {
                    var origErrorShow = display.errorShow;
                    display.errorShow = function(errorMessage, source) {
                        origErrorShow.apply(this, arguments);
                        if (source === 'checkout') hideOrderProcessingModal();
                    };
                }
                return true;
            }
            return false;
        }
        function hookShowCheckoutError() {
            if (typeof showCheckoutError !== 'function') return false;
            var orig = showCheckoutError;
            window.showCheckoutError = function(errorMessage, container) {
                orig(errorMessage, container);
                hideOrderProcessingModal();
            };
            return true;
        }
        function watchForGatewayErrorAndHideModal() {
            var sel = '.gateway-errors, .checkout-error-feedback, .alert-danger';
            var nodes = document.querySelectorAll(sel);
            if (!nodes.length) return;
            nodes.forEach(function(el) {
                if (el._orderModalWatcher) return;
                el._orderModalWatcher = true;
                var obs = new MutationObserver(function() {
                    var hasContent = (el.textContent || '').trim().length > 0;
                    var visible = el.offsetParent !== null || (window.getComputedStyle(el).display !== 'none' && window.getComputedStyle(el).visibility !== 'hidden');
                    if (hasContent && visible) hideOrderProcessingModal();
                });
                obs.observe(el, { childList: true, subtree: true, characterData: true });
            });
        }
        function watchForButtonReenable() {
            var btn = document.getElementById('btnCompleteOrder');
            if (!btn || btn._orderModalWatcher) return;
            btn._orderModalWatcher = true;
            var obs = new MutationObserver(function() {
                if (!btn.disabled) hideOrderProcessingModal();
            });
            obs.observe(btn, { attributes: true, attributeFilter: ['disabled', 'class'] });
            setInterval(function() {
                if (!btn.disabled && document.getElementById('modalOrderProcessing') && jQuery('#modalOrderProcessing').hasClass('show')) hideOrderProcessingModal();
            }, 500);
        }
        document.addEventListener('DOMContentLoaded', function() {
            initOrderProcessingModal();
            if (!hookPaymentReset()) {
                setTimeout(hookPaymentReset, 300);
                setTimeout(hookPaymentReset, 800);
                setTimeout(hookPaymentReset, 1500);
            }
            if (!hookShowCheckoutError()) {
                setTimeout(hookShowCheckoutError, 300);
                setTimeout(hookShowCheckoutError, 800);
            }
            setTimeout(watchForGatewayErrorAndHideModal, 200);
            setTimeout(watchForGatewayErrorAndHideModal, 1000);
            setTimeout(watchForButtonReenable, 500);
        });
    })();
    </script>

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

    {$footeroutput}

</body>
</html>
