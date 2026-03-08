/**
 * Substitui os ícones dos Atalhos rápidos (cPanel) por Phosphor Icons.
 * Executa na página de detalhes do produto (clientareaproductdetails).
 */
(function() {
    var map = [
        { keys: ['contas de email', 'email accounts'], icon: 'ph-envelope' },
        { keys: ['encaminhadores', 'forwarders', 'forwarder', 'encaminhador'], icon: 'ph-share-network' },
        { keys: ['auto-resposta', 'autoresponder'], icon: 'ph-chat-circle-dots' },
        { keys: ['gerenciador de arquivos', 'file manager'], icon: 'ph-folder-open' },
        { keys: ['backup', 'cópia de segurança'], icon: 'ph-clock-counter-clockwise' },
        { keys: ['domínios', 'domains'], icon: 'ph-globe' },
        { keys: ['tarefas agendadas', 'cron', 'scheduled'], icon: 'ph-calendar' },
        { keys: ['mysql', 'bancos de dados'], icon: 'ph-database' },
        { keys: ['phpmyadmin'], icon: 'ph-browser' },
        { keys: ['awstats', 'estatísticas'], icon: 'ph-chart-line' },
        { keys: ['criar conta', 'email account'], icon: 'ph-envelope-simple' },
        { keys: ['accelerate wp', 'acceleratewp', 'litespeed accelerate', 'cache'], icon: 'ph-rocket-launch' },
        { keys: ['imunify360', 'imunify', 'anti-vírus', 'anti-virus', 'antivirus'], icon: 'ph-shield-check' }
    ];

    function iconForText(text) {
        if (!text) return 'ph-app-window';
        var t = text.toLowerCase().trim();
        for (var i = 0; i < map.length; i++) {
            for (var k = 0; k < map[i].keys.length; k++) {
                if (t.indexOf(map[i].keys[k]) !== -1) return map[i].icon;
            }
        }
        return 'ph-app-window';
    }

    function run() {
        var tab = document.getElementById('tabOverview');
        if (!tab) return;
        var cards = tab.querySelectorAll('.card');
        for (var c = 0; c < cards.length; c++) {
            var title = cards[c].querySelector('.card-title, h3, h4');
            var titleText = title ? title.textContent : '';
            if (titleText.indexOf('Atalhos') === -1 && titleText.indexOf('Shortcuts') === -1) continue;
            var links = cards[c].querySelectorAll('a');
            for (var i = 0; i < links.length; i++) {
                var a = links[i];
                var text = (a.textContent || '').trim().replace(/\s+/g, ' ');
                if (text.length < 2) continue;
                var icon = a.querySelector('img, i.fa, i.fas, i.far, i.fab, i.fal, i.fad, .fa, .icon');
                var phIcon;
                var href = (a.getAttribute('href') || a.href || '').toLowerCase();
                if (href.indexOf('litespeed_accelerate') !== -1) {
                    phIcon = 'ph-rocket-launch';
                } else if (href.indexOf('imunify360') !== -1) {
                    phIcon = 'ph-shield-check';
                } else {
                    phIcon = iconForText(text);
                }
                var ph = document.createElement('i');
                ph.className = 'ph-thin ph ' + phIcon + ' product-shortcut-phosphor-icon';
                ph.setAttribute('aria-hidden', 'true');
                if (icon) {
                    icon.parentNode.replaceChild(ph, icon);
                } else {
                    a.insertBefore(ph, a.firstChild);
                }
            }
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', run);
    } else {
        run();
    }
})();
