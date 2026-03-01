<!doctype html>
<html lang="en">
<head>
    <meta charset="{$charset}" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>{if $kbarticle.title}{$kbarticle.title} - {/if}{$pagetitle} - {$companyname}</title>
    {include file="$template/includes/head.tpl"}
    {$headoutput}
</head>
<body data-phone-cc-input="{$phoneNumberInputStyle}">
    {if $captcha}{$captcha->getMarkup()}{/if}
    {$headeroutput}

    <header id="header" class="header">
        <div class="{if $loggedin && !$inShoppingCart}container-fluid{else}container{/if} header-row d-flex align-items-center flex-wrap mt-2 mb-2">
            <a class="navbar-brand" href="https://fireflyhost.com.br" target="_blank" rel="noopener">
                <img src="https://fireflyhost-wordpress.fpix6w.easypanel.host/wp-content/uploads/2026/01/logo-firefly.svg" alt="{$companyname}" class="logo-img" width="157" height="39">
            </a>
            {if $loggedin}
                <div class="topbar d-flex align-items-center ml-auto">
                    <div class="d-flex w-100 justify-content-end flex-wrap">
                        <div class="d-flex align-items-center theme-toggle-switch-wrapper mr-2">
                            <i class="fas fa-sun theme-icon-light theme-toggle-icon" aria-hidden="true"></i>
                            <label class="custom-control custom-switch mb-0 mx-2" for="theme-toggle-input" title="Alternar tema claro/escuro">
                                <input type="checkbox" class="custom-control-input" id="theme-toggle-input" aria-label="Alternar tema claro/escuro">
                                <span class="custom-control-label"></span>
                            </label>
                            <i class="fas fa-moon theme-icon-dark theme-toggle-icon d-none" aria-hidden="true"></i>
                        </div>
                        <div class="mr-auto">
                            <button type="button" class="btn" data-toggle="popover" id="accountNotifications" data-placement="bottom">
                                <i class="far fa-flag"></i>
                                {if count($clientAlerts) > 0}
                                    {count($clientAlerts)}
                                    <span class="d-none d-sm-inline">{lang key='notifications'}</span>
                                {else}
                                    <span class="d-sm-none">0</span>
                                    <span class="d-none d-sm-inline">{lang key='nonotifications'}</span>
                                {/if}
                            </button>
                            <div id="accountNotificationsContent" class="w-hidden">
                                <ul class="client-alerts">
                                {foreach $clientAlerts as $alert}
                                    <li>
                                        <a href="{$alert->getLink()}">
                                            <i class="fas fa-fw fa-{if $alert->getSeverity() == 'danger'}exclamation-circle{elseif $alert->getSeverity() == 'warning'}exclamation-triangle{elseif $alert->getSeverity() == 'info'}info-circle{else}check-circle{/if}"></i>
                                            <div class="message">{$alert->getMessage()}</div>
                                        </a>
                                    </li>
                                {foreachelse}
                                    <li class="none">
                                        {lang key='notificationsnone'}
                                    </li>
                                {/foreach}
                                </ul>
                            </div>
                        </div>
                        <div class="ml-auto">
                            <div class="input-group active-client" role="group">
                                <div class="input-group-prepend d-none d-md-inline">
                                    <span class="input-group-text">{lang key='loggedInAs'}:</span>
                                </div>
                                <div class="btn-group">
                                    <a href="{$WEB_ROOT}/clientarea.php?action=details" class="btn btn-active-client">
                                        <span>
                                            {if $client.companyname}
                                                {$client.companyname}
                                            {else}
                                                {$client.fullName}
                                            {/if}
                                        </span>
                                    </a>
                                    <a href="{routePath('user-accounts')}" class="btn" data-toggle="tooltip" data-placement="bottom" title="Switch Account">
                                        <i class="fad fa-random"></i>
                                    </a>
                                    {if $adminMasqueradingAsClient || $adminLoggedIn}
                                        <a href="{$WEB_ROOT}/logout.php?returntoadmin=1" class="btn btn-return-to-admin" data-toggle="tooltip" data-placement="bottom" title="{if $adminMasqueradingAsClient}{lang key='adminmasqueradingasclient'} {lang key='logoutandreturntoadminarea'}{else}{lang key='adminloggedin'} {lang key='returntoadminarea'}{/if}">
                                            <i class="fas fa-redo-alt"></i>
                                            <span class="d-none d-md-inline-block">{lang key="admin.returnToAdmin"}</span>
                                        </a>
                                    {/if}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <ul class="navbar-nav toolbar ml-2 d-xl-none">
                    <li class="nav-item">
                        <button class="btn nav-link" type="button" data-toggle="collapse" data-target="#mainNavbar">
                            <span class="fas fa-bars fa-fw"></span>
                        </button>
                    </li>
                </ul>
            {else}
                <a href="{$WEB_ROOT}/clientarea.php" class="btn btn-entrar-header">{lang key='login'}</a>
                <ul class="navbar-nav toolbar ml-2">
                    <li class="nav-item d-xl-none">
                        <button class="btn nav-link" type="button" data-toggle="collapse" data-target="#mainNavbar">
                            <span class="fas fa-bars fa-fw"></span>
                        </button>
                    </li>
                </ul>
            {/if}
        </div>
        <div class="navbar navbar-expand-xl main-navbar-wrapper d-none">
            <div class="{if $loggedin && !$inShoppingCart}container-fluid{else}container{/if}">
                <div class="collapse navbar-collapse" id="mainNavbar">
                    <ul id="nav" class="navbar-nav mr-auto">
                        {include file="$template/includes/navbar.tpl" navbar=$primaryNavbar}
                    </ul>
                </div>
            </div>
        </div>
    </header>

    <div id="theme-content"{if $loggedin} data-default-theme="light"{/if}>
    {include file="$template/includes/network-issues-notifications.tpl"}

    {include file="$template/includes/validateuser.tpl"}
    {include file="$template/includes/verifyemail.tpl"}

    {if $templatefile == 'homepage'}
        {if $registerdomainenabled || $transferdomainenabled}
            {include file="$template/includes/domain-search.tpl"}
        {/if}
    {/if}

    <section id="main-body">
        <div class="{if $skipMainBodyContainer}{else}{if $loggedin && !$inShoppingCart}container-fluid{else}container{/if}{/if}">
            <div class="row">

            {if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}
                <div class="col-2">
                    <div class="sidebar">
                        {include file="$template/includes/sidebar.tpl" sidebar=$primarySidebar}
                    </div>
                    {if !$inShoppingCart && $secondarySidebar->hasChildren()}
                        <div class="d-none d-lg-block sidebar">
                            {include file="$template/includes/sidebar.tpl" sidebar=$secondarySidebar}
                        </div>
                    {/if}
                </div>
            {/if}
            <div class="{if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}col-10{else}col-12{/if} primary-content">
