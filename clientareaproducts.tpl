{include file="$template/includes/tablelist.tpl" tableName="ServicesList" filterColumn="4" noSortColumns="0"}

<script>
    jQuery(document).ready(function() {
        var table = jQuery('#tableServicesList').show().DataTable();

        {if $orderby == 'product'}
            table.order([1, '{$sort}'], [4, 'asc']);
        {elseif $orderby == 'amount' || $orderby == 'billingcycle'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'nextduedate'}
            table.order(3, '{$sort}');
        {elseif $orderby == 'domainstatus'}
            table.order(4, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').hide();
    });
</script>

<div class="table-container clearfix">
    <table id="tableServicesList" class="table table-list w-hidden">
        <thead>
            <tr>
                <th></th>
                <th>{lang key='orderproduct'}</th>
                <th>{lang key='clientareaaddonpricing'}</th>
                <th>{lang key='clientareahostingnextduedate'}</th>
                <th>{lang key='clientareastatus'}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $services as $service}
                <tr onclick="clickableSafeRedirect(event, 'clientarea.php?action=productdetails&amp;id={$service.id}', false)">
                    <td class="py-0 text-center{if $service.sslStatus} ssl-info{/if}" data-element-id="{$service.id}" data-type="service"{if $service.domain} data-domain="{$service.domain}"{/if}>
                        {if $service.sslStatus}
                            <img src="{$service.sslStatus->getImagePath()}" data-toggle="tooltip" title="{$service.sslStatus->getTooltipContent()}" class="{$service.sslStatus->getClass()}" width="25">
                        {elseif !$service.isActive}
                            <img src="{$BASE_PATH_IMG}/ssl/ssl-inactive-domain.png" data-toggle="tooltip" title="{lang key='sslState.sslInactiveService'}" width="25">
                        {/if}
                    </td>
                    <td><strong>{$service.product}</strong>{if $service.domain}<br /><a href="http://{$service.domain}" target="_blank">{$service.domain}</a>{else}<br />-{/if}</td>
                    <td class="text-center" data-order="{$service.amountnum}">{$service.amount} <small class="text-muted">{$service.billingcycle}</small></td>
                    <td class="text-center"><span class="w-hidden">{$service.normalisedNextDueDate}</span>{$service.nextduedate}</td>
                    <td class="text-center"><span class="label status status-{$service.status|strtolower}">{$service.statustext}</span></td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fas fa-spinner fa-spin"></i> {lang key='loading'}</p>
    </div>
</div>

{if isset($fireflyUpsellProducts) && $fireflyUpsellProducts|@count > 0}
    <div class="card mt-4 mb-4">
        <div class="card-header">
            <h3 class="card-title m-0">
                <i class="fas fa-arrow-up fa-fw"></i>
                {if isset($fireflyUpsellGroupName) && $fireflyUpsellGroupName}
                    {lang key='clientareaproducts' assign='defaultTitle'}
                    Outros planos de {$fireflyUpsellGroupName|escape}
                {else}
                    Outros planos de hospedagem
                {/if}
            </h3>
        </div>
        <div class="card-body">
            <p class="text-muted small mb-3">Conheça mais opções da mesma categoria e faça upgrade quando precisar.</p>
            <div class="row">
                {foreach $fireflyUpsellProducts as $upsell}
                    <div class="col-sm-6 col-md-4 col-lg-3 mb-3">
                        <a href="{$upsell.url}" class="btn btn-outline-primary btn-block text-left d-flex align-items-center justify-content-between">
                            <span>{$upsell.name|escape}</span>
                            <i class="fas fa-chevron-right fa-sm"></i>
                        </a>
                    </div>
                {/foreach}
            </div>
        </div>
    </div>
{/if}
