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
    // #region agent log (log file: includes/hooks/firefly_debug_a8bd46.log no servidor)
    $logPath = __DIR__ . DIRECTORY_SEPARATOR . 'firefly_debug_a8bd46.log';
    @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyServicesUpsell.php:entry','message'=>'hook_entered','data'=>['has_clientsdetails'=>isset($vars['clientsdetails']),'has_services'=>isset($vars['services']),'var_keys'=>array_keys($vars)],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'A'])."\n", FILE_APPEND | LOCK_EX);
    // #endregion
    $clientId = null;
    if (!empty($vars['clientsdetails']['id'])) {
        $clientId = (int) $vars['clientsdetails']['id'];
    }
    if (!$clientId && function_exists('getClientsDetails')) {
        $clientId = (int) ($_SESSION['uid'] ?? 0);
    }
    if (!$clientId) {
        // #region agent log
        @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyServicesUpsell.php:early_return','message'=>'no_client_id','data'=>[],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'B'])."\n", FILE_APPEND | LOCK_EX);
        // #endregion
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
            // #region agent log
            @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyServicesUpsell.php:empty_products','message'=>'no_client_products','data'=>['clientId'=>$clientId],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'C'])."\n", FILE_APPEND | LOCK_EX);
            // #endregion
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
            // #region agent log
            @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyServicesUpsell.php:empty_groups','message'=>'no_group_ids','data'=>['clientProductIds'=>$clientProductIds],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'C'])."\n", FILE_APPEND | LOCK_EX);
            // #endregion
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

        // #region agent log
        @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyServicesUpsell.php:return','message'=>'returning_upsell','data'=>['count'=>count($upsellProducts),'groupName'=>$groupName],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'A'])."\n", FILE_APPEND | LOCK_EX);
        // #endregion
        return [
            'fireflyUpsellProducts' => $upsellProducts,
            'fireflyUpsellGroupName' => $groupName,
        ];
    } catch (\Exception $e) {
        // #region agent log
        @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyServicesUpsell.php:catch','message'=>'exception','data'=>['msg'=>$e->getMessage()],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'C'])."\n", FILE_APPEND | LOCK_EX);
        // #endregion
        return ['fireflyUpsellProducts' => [], 'fireflyUpsellGroupName' => ''];
    }
});
