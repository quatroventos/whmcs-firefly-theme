<?php
/**
 * Firefly cPanel Sidebar Stats – dados de uso e informações gerais do cPanel (CPU, memória, disco, etc.)
 * Chamada à UAPI do cPanel (ResourceUsage / StatsBar) e exposição no template do overview.
 *
 * Copie para: includes/hooks/ da instalação WHMCS.
 * Requer: serviço cPanel com username/password e servidor com hostname configurado.
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

/**
 * Obtém hostname do servidor a partir do serviceid.
 */
function firefly_cpanel_get_server_hostname($serviceId) {
    try {
        $service = Capsule::table('tblhosting')->where('id', (int) $serviceId)->first();
        if (!$service) {
            return null;
        }
        $serverId = isset($service->server) ? $service->server : (isset($service->serverid) ? $service->serverid : null);
        if ($serverId && is_numeric($serverId)) {
            $server = Capsule::table('tblservers')->where('id', (int) $serverId)->first();
            if ($server && !empty($server->hostname)) {
                return $server->hostname;
            }
        }
        if (!empty($service->server) && !is_numeric($service->server)) {
            return $service->server;
        }
    } catch (\Exception $e) {
        // ignore
    }
    return null;
}

/**
 * Chama a UAPI do cPanel (GET) com Basic Auth.
 */
function firefly_cpanel_uapi_call($hostname, $username, $password, $module, $function, array $params = []) {
    $port = 2083;
    $path = '/execute/' . $module . '/' . $function;
    if (!empty($params)) {
        $path .= '?' . http_build_query($params);
    }
    $url = 'https://' . $hostname . ':' . $port . $path;
    $auth = base64_encode($username . ':' . $password);
    $opts = [
        'http' => [
            'method' => 'GET',
            'header' => "Authorization: Basic $auth\r\nAccept: application/json\r\n",
            'timeout' => 10,
            'ignore_errors' => true,
        ],
        'ssl' => [
            'verify_peer' => false,
            'verify_peer_name' => false,
        ],
    ];
    $ctx = stream_context_create($opts);
    $json = @file_get_contents($url, false, $ctx);
    if ($json === false) {
        return null;
    }
    $data = @json_decode($json, true);
    return $data;
}

/**
 * Formata valor de uso (bytes, percent, array) para exibição.
 */
function firefly_cpanel_format_usage($val) {
    if ($val === null || $val === '') {
        return '—';
    }
    if (is_array($val)) {
        $count = isset($val['count']) ? $val['count'] : (isset($val['used']) ? $val['used'] : '');
        $limit = isset($val['limit']) ? $val['limit'] : (isset($val['max']) ? $val['max'] : '');
        if ($limit === 'unlimited' || $limit === '∞') {
            return $count . ' / ∞';
        }
        return $count . ' / ' . $limit;
    }
    return (string) $val;
}

add_hook('ClientAreaProductDetailsPreModuleTemplate', 1, function (array $vars) {
    // #region agent log
    $logPath = '/Users/gabriel/VisualStudioProjects/WHMCS firefly theme/whmcs-firefly-theme/.cursor/debug-a8bd46.log';
    @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyCpanelSidebarStats.php:entry','message'=>'hook_entered','data'=>['modulename'=>isset($vars['modulename'])?$vars['modulename']:null,'var_keys'=>array_keys($vars)],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'D'])."\n", FILE_APPEND | LOCK_EX);
    // #endregion
    if (empty($vars['modulename']) || strtolower($vars['modulename']) !== 'cpanel') {
        @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyCpanelSidebarStats.php:skip','message'=>'not_cpanel','data'=>['modulename'=>isset($vars['modulename'])?$vars['modulename']:null],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'D'])."\n", FILE_APPEND | LOCK_EX);
        return [];
    }
    $serviceId = (int) $vars['serviceid'];
    $username = isset($vars['username']) ? trim($vars['username']) : '';
    $password = isset($vars['password']) ? $vars['password'] : '';
    if ($username === '' || $password === '') {
        @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyCpanelSidebarStats.php:no_auth','message'=>'username_or_password_empty','data'=>['has_username'=>($username!==''),'has_password'=>($password!=='')],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'E'])."\n", FILE_APPEND | LOCK_EX);
        return [];
    }

    $hostname = firefly_cpanel_get_server_hostname($serviceId);
    if ($hostname === null || $hostname === '') {
        @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyCpanelSidebarStats.php:no_hostname','message'=>'hostname_empty','data'=>['serviceId'=>$serviceId],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'E'])."\n", FILE_APPEND | LOCK_EX);
        return [];
    }

    $out = [
        'cpanelSidebarStats' => [],
        'cpanelGeneralInfo' => [
            ['label' => 'Usuário', 'value' => $username],
            ['label' => 'Domínio primário', 'value' => isset($vars['domain']) ? $vars['domain'] : '—'],
        ],
    ];

    // StatsBar get_stats – estatísticas da barra lateral (bandwidth, disk, domínios, email, etc.)
    $display = 'bandwidthusage|diskusage|fileusage|emailaccounts|addondomains|subdomains|parkeddomains|ftpaccounts|mysqldatabases|hostname|sharedip';
    $stats = firefly_cpanel_uapi_call($hostname, $username, $password, 'StatsBar', 'get_stats', ['display' => $display]);
    if (!empty($stats['result']['data'])) {
        foreach ($stats['result']['data'] as $row) {
            $title = isset($row['title']) ? $row['title'] : (isset($row['name']) ? $row['name'] : '');
            $value = isset($row['value']) ? $row['value'] : (isset($row['rawvalue']) ? $row['rawvalue'] : '');
            if ($title !== '') {
                $out['cpanelSidebarStats'][] = [
                    'title' => $title,
                    'value' => firefly_cpanel_format_usage($value),
                ];
            }
        }
    }

    // ResourceUsage get_usages – uso de recursos (pode incluir CPU, memória, etc. conforme o servidor)
    $usages = firefly_cpanel_uapi_call($hostname, $username, $password, 'ResourceUsage', 'get_usages');
    if (!empty($usages['result']['data']) && is_array($usages['result']['data'])) {
        foreach ($usages['result']['data'] as $row) {
            $title = isset($row['title']) ? $row['title'] : (isset($row['name']) ? $row['name'] : '');
            $value = isset($row['value']) ? $row['value'] : (isset($row['rawvalue']) ? $row['rawvalue'] : '');
            if ($title !== '') {
                $out['cpanelSidebarStats'][] = [
                    'title' => $title,
                    'value' => firefly_cpanel_format_usage($value),
                ];
            }
        }
    }

    // #region agent log
    @file_put_contents($logPath, json_encode(['sessionId'=>'a8bd46','location'=>'FireflyCpanelSidebarStats.php:return','message'=>'returning_stats','data'=>['stats_count'=>count($out['cpanelSidebarStats']),'has_data'=>(!empty($out['cpanelSidebarStats'])||!empty($out['cpanelGeneralInfo']))],'timestamp'=>round(microtime(true)*1000),'hypothesisId'=>'D'])."\n", FILE_APPEND | LOCK_EX);
    // #endregion
    return [
        'cpanelSidebarStats' => $out['cpanelSidebarStats'],
        'cpanelGeneralInfo'  => $out['cpanelGeneralInfo'],
        'cpanelStatsHasData' => !empty($out['cpanelSidebarStats']) || !empty($out['cpanelGeneralInfo']),
    ];
});
