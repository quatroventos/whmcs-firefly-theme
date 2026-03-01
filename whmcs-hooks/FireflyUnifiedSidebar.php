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
            ['label' => 'Detalhes da Conta', 'uri' => 'clientarea.php'],
            ['label' => 'Contatos', 'uri' => 'clientarea.php?action=contacts'],
            ['label' => 'Alterar Senha', 'uri' => 'clientarea.php?action=changepw'],
            ['label' => 'Segurança', 'uri' => 'clientarea.php?action=security'],
            ['label' => 'Métodos de Pagamento', 'uri' => 'index.php?rp=/account/paymentmethods'],
            ['label' => 'Contas de utilizador', 'uri' => 'index.php?rp=/account/users'],
        ],
    ],
    'services' => [
        'visible' => true,
        'order'   => 20,
        'label'   => 'Serviços',
        'icon'    => 'fas fa-cube',
        'children' => [
            ['label' => 'Meus Serviços', 'uri' => 'clientarea.php?action=products'],
        ],
    ],
    'domains' => [
        'visible' => true,
        'order'   => 30,
        'label'   => 'Domínios',
        'icon'    => 'fas fa-globe',
        'children' => [
            ['label' => 'Meus Domínios', 'uri' => 'clientarea.php?action=domains'],
        ],
    ],
    'invoices' => [
        'visible' => true,
        'order'   => 40,
        'label'   => 'Faturas',
        'icon'    => 'fas fa-file-invoice',
        'children' => [
            ['label' => 'Ver Faturas', 'uri' => 'clientarea.php?action=invoices'],
        ],
    ],
    'support' => [
        'visible' => true,
        'order'   => 50,
        'label'   => 'Suporte',
        'icon'    => 'fas fa-ticket-alt',
        'children' => [
            ['label' => 'Tickets', 'uri' => 'supporttickets.php'],
            ['label' => 'Abrir Ticket', 'uri' => 'submitticket.php'],
            ['label' => 'Base de Conhecimento', 'uri' => 'knowledgebase.php'],
        ],
    ],
    'downloads' => [
        'visible' => true,
        'order'   => 60,
        'label'   => 'Downloads',
        'icon'    => 'fas fa-download',
        'children' => [
            ['label' => 'Downloads', 'uri' => 'downloads.php'],
        ],
    ],
];

add_hook('ClientAreaPrimarySidebar', 1, function (MenuItem $primarySidebar) {
    // Na página de login não mostrar o menu (sidebar)
    $rp = isset($_GET['rp']) ? trim((string) $_GET['rp'], "/ \t\n\r\0\x0B") : '';
    if ($rp === 'login') {
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

// Na página de login esvaziar também a secondary sidebar (senão a coluna do menu ainda aparece)
add_hook('ClientAreaSecondarySidebar', 1, function (MenuItem $secondarySidebar) {
    $rp = isset($_GET['rp']) ? trim((string) $_GET['rp'], "/ \t\n\r\0\x0B") : '';
    if ($rp === 'login') {
        foreach ($secondarySidebar->getChildren() as $child) {
            $secondarySidebar->removeChild($child->getName());
        }
    }
});
