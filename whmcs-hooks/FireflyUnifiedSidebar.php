<?php
/**
 * Firefly Unified Sidebar – sidebar única em todas as telas da área do cliente.
 * Compatível com WHMCS 9.x.
 * @see https://docs.whmcs.com/9-0/customization/client-area-customization/client-area-sidebars/
 *
 * Copie este ficheiro para: includes/hooks/ da sua instalação WHMCS.
 *
 * Para mostrar/ocultar painéis: altere 'visible' => true/false.
 * Para alterar texto ou link: edite 'label' e 'uri' nos painéis e children.
 * Para alterar ordem: edite 'order' (menor = mais acima).
 */

use WHMCS\View\Menu\Item as MenuItem;

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

// ========== CONFIGURAÇÃO – edite aqui o que mostrar/ocultar ==========
$GLOBALS['FIREFLY_SIDEBAR_PANELS'] = [
    'account' => [
        'visible' => true,
        'order'   => 10,
        'label'   => 'Minha Conta',
        'icon'    => 'fas fa-user',
        'children' => [
            ['label' => 'Painel da Conta', 'uri' => 'clientarea.php', 'icon' => 'fas fa-tachometer-alt'],
            ['label' => 'Meus Serviços', 'uri' => 'clientarea.php?action=products', 'icon' => 'fas fa-cube'],
            ['label' => 'Contas de utilizador', 'uri' => 'index.php?rp=/account/users', 'icon' => 'fas fa-users'],
        ],
    ],
    'domains' => [
        'visible' => true,
        'order'   => 30,
        'label'   => 'Domínios',
        'icon'    => 'fas fa-globe',
        'children' => [
            ['label' => 'Meus Domínios', 'uri' => 'clientarea.php?action=domains', 'icon' => 'fas fa-globe'],
        ],
    ],
    'invoices' => [
        'visible' => true,
        'order'   => 40,
        'label'   => 'Financeiro',
        'icon'    => 'fas fa-file-invoice',
        'children' => [
            ['label' => 'Ver Faturas', 'uri' => 'clientarea.php?action=invoices', 'icon' => 'fas fa-file-invoice'],
            ['label' => 'Métodos de Pagamento', 'uri' => 'index.php?rp=/account/paymentmethods', 'icon' => 'fas fa-credit-card'],
        ],
    ],
    'support' => [
        'visible' => true,
        'order'   => 50,
        'label'   => 'Suporte',
        'icon'    => 'fas fa-ticket-alt',
        'children' => [
            ['label' => 'Meus Tickets de Suporte', 'uri' => 'supporttickets.php', 'icon' => 'fas fa-ticket-alt'],
            ['label' => 'Abrir Ticket', 'uri' => 'submitticket.php', 'icon' => 'fas fa-comments'],
            ['label' => 'Anúncios', 'uri' => 'index.php?rp=/announcements', 'icon' => 'fas fa-list'],
            ['label' => 'Base de Conhecimento', 'uri' => 'index.php?rp=/knowledgebase', 'icon' => 'fas fa-info-circle'],
            ['label' => 'Downloads', 'uri' => 'index.php?rp=/download', 'icon' => 'fas fa-download'],
            ['label' => 'Status da Rede', 'uri' => 'serverstatus.php', 'icon' => 'fas fa-server'],
        ],
    ],
    'user' => [
        'visible' => true,
        'order'   => 60,
        'label'   => 'Meus dados',
        'icon'    => 'fas fa-user-cog',
        'children' => [
            ['label' => 'Alterar Dados', 'uri' => 'clientarea.php?action=details', 'icon' => 'fas fa-address-card'],
            ['label' => 'Alterar Senha', 'uri' => 'clientarea.php?action=changepw', 'icon' => 'fas fa-key'],
        ],
    ],

    
];

add_hook('ClientAreaPrimarySidebar', 1, function (MenuItem $primarySidebar) {
    // Na página de login ou de registo não mostrar o menu (sidebar)
    $rp = isset($_GET['rp']) ? trim((string) $_GET['rp'], "/ \t\n\r\0\x0B") : '';
    $isRegister = ($rp === 'register') || (isset($_SERVER['REQUEST_URI']) && strpos($_SERVER['REQUEST_URI'], 'register') !== false);
    if ($rp === 'login' || $isRegister) {
        foreach ($primarySidebar->getChildren() as $child) {
            $primarySidebar->removeChild($child->getName());
        }
        return;
    }

    $panels = isset($GLOBALS['FIREFLY_SIDEBAR_PANELS']) ? $GLOBALS['FIREFLY_SIDEBAR_PANELS'] : [];
    if (empty($panels)) {
        return;
    }

    // Remover todos os itens atuais da primary sidebar
    $existingChildren = $primarySidebar->getChildren();
    foreach ($existingChildren as $child) {
        $primarySidebar->removeChild($child->getName());
    }

    // Ordenar painéis por 'order' (default 999)
    uasort($panels, function ($a, $b) {
        $orderA = isset($a['order']) ? (int) $a['order'] : 999;
        $orderB = isset($b['order']) ? (int) $b['order'] : 999;
        return $orderA <=> $orderB;
    });

    $panelOrder = 0;
    foreach ($panels as $key => $panel) {
        if (empty($panel['visible'])) {
            continue;
        }

        $panelOrder += 10;
        $label = isset($panel['label']) ? $panel['label'] : $key;
        $icon = isset($panel['icon']) ? $panel['icon'] : '';
        $children = isset($panel['children']) && is_array($panel['children']) ? $panel['children'] : [];

        $panelItem = $primarySidebar->addChild($key)
            ->setLabel($label)
            ->setOrder($panelOrder);

        if ($icon !== '') {
            $panelItem->setIcon($icon);
        }

        foreach ($children as $i => $child) {
            $childName = $key . '_' . $i;
            $childLabel = isset($child['label']) ? $child['label'] : $childName;
            $childUri = isset($child['uri']) ? $child['uri'] : '#';
            $childIcon = isset($child['icon']) ? $child['icon'] : '';

            $childItem = $panelItem->addChild($childName)
                ->setLabel($childLabel)
                ->setUri($childUri)
                ->setOrder(($i + 1) * 10);

            if ($childIcon !== '') {
                $childItem->setIcon($childIcon);
            }
        }
    }

    if (method_exists($primarySidebar, 'sort')) {
        MenuItem::sort($primarySidebar, true);
    }
});

// Esvaziar sempre a secondary sidebar (menu contextual da página) – fica só o menu unificado da primary
add_hook('ClientAreaSecondarySidebar', 1, function (MenuItem $secondarySidebar) {
    foreach ($secondarySidebar->getChildren() as $child) {
        $secondarySidebar->removeChild($child->getName());
    }
});
