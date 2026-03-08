<?php
/**
 * Firefly Services Upsell – mostra outros planos de hospedagem da mesma categoria
 * na página Meus Serviços, para upsell/cross-sell.
 *
 * Copie para: includes/hooks/ da instalação WHMCS.
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

add_hook('ClientAreaPageProductsServices', 1, function (array $vars) {
    $clientId = null;
    if (!empty($vars['clientsdetails']['id'])) {
        $clientId = (int) $vars['clientsdetails']['id'];
    }
    if (!$clientId && function_exists('getClientsDetails')) {
        $clientId = (int) ($_SESSION['uid'] ?? 0);
    }
    if (!$clientId) {
        return ['fireflyUpsellProducts' => [], 'fireflyUpsellGroupName' => ''];
    }

    try {
        // Produtos que o cliente já tem (packageid em tblhosting)
        $clientProductIds = Capsule::table('tblhosting')
            ->where('userid', $clientId)
            ->whereNotNull('packageid')
            ->where('packageid', '>', 0)
            ->distinct()
            ->pluck('packageid')
            ->toArray();

        if (empty($clientProductIds)) {
            return ['fireflyUpsellProducts' => [], 'fireflyUpsellGroupName' => ''];
        }

        // Grupos (gid) desses produtos
        $groupIds = Capsule::table('tblproducts')
            ->whereIn('id', $clientProductIds)
            ->whereNotNull('gid')
            ->distinct()
            ->pluck('gid')
            ->toArray();

        if (empty($groupIds)) {
            return ['fireflyUpsellProducts' => [], 'fireflyUpsellGroupName' => ''];
        }

        // Nome do primeiro grupo (para o título da secção)
        $firstGroup = Capsule::table('tblproductgroups')->whereIn('id', $groupIds)->first();
        $groupName = $firstGroup ? $firstGroup->name : '';

        // Outros produtos dos mesmos grupos que o cliente ainda não tem (visíveis e ativos)
        $upsellProducts = Capsule::table('tblproducts')
            ->whereIn('gid', $groupIds)
            ->whereNotIn('id', $clientProductIds)
            ->where('hidden', 0)
            ->orderBy('name')
            ->get(['id', 'name', 'gid'])
            ->map(function ($row) {
                return [
                    'id'   => (int) $row->id,
                    'name' => $row->name,
                    'url'  => 'cart.php?a=add&pid=' . (int) $row->id,
                ];
            })
            ->values()
            ->all();

        return [
            'fireflyUpsellProducts' => $upsellProducts,
            'fireflyUpsellGroupName' => $groupName,
        ];
    } catch (\Exception $e) {
        return ['fireflyUpsellProducts' => [], 'fireflyUpsellGroupName' => ''];
    }
});
