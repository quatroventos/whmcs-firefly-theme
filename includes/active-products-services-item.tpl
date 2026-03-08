<div class="div-service-item" data-href="clientarea.php?action=productdetails&id={$service->id}">
    <div class="div-service-status">
        <span class="label label-placeholder">
            {$statusProperties[array_key_first($statusProperties)]['translation']}
        </span>
        <span class="label label-{$statusProperties[$service->domainStatus]['modifier']}"
              title="{$statusProperties[$service->domainStatus]['translation']}"
        >
            {$statusProperties[$service->domainStatus]['translation']}
        </span>
    </div>
    <div class="div-service-name">
        <span class="font-weight-bold">
            {$service->product->productGroup->name} - {$service->product->name}
        </span>
        <span class="text-domain">{$service->domain}</span>
    </div>
    <div class="div-service-buttons">
        {if !empty($buttonData)}
            <div class="btn-group btn-group-sm btn-group-primary" role="group">
                <button type="button"
                        class="btn btn-sm btn-default dropdown-toggle"
                        data-toggle="dropdown"
                        aria-haspopup="true"
                        aria-expanded="false"
                >
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu">
                    {foreach $buttonData as $buttonDatum}
                        <li class="dropdown-item btn-custom-action{if !$buttonDatum['active']} disabled{/if}"
                            data-serviceid="{$buttonDatum['serviceid']}"
                            data-identifier="{$buttonDatum['identifier']}"
                            data-active="{$buttonDatum['active']}"
                            {if !$buttonDatum['active']}disabled="disabled"{/if}
                        >
                            <span class="loading" style="display: none;">
                                <i class="fas fa-spinner fa-spin"></i>
                            </span>
                            {$buttonDatum['display']}
                        </li>
                    {/foreach}
                </ul>
            </div>
            {foreach $accentPrimaryServiceBtns as $accentPrimaryServiceBtn}
            <div class="btn-group btn-group-sm btn-group-secondary" role="group">
                <button class="btn btn-primary btn-sm btn-custom-action{if !$accentPrimaryServiceBtn['active']} disabled{/if}"
                        data-serviceid="{$accentPrimaryServiceBtn['serviceid']}"
                        data-identifier="{$accentPrimaryServiceBtn['identifier']}"
                        data-active="{$accentPrimaryServiceBtn['active']}"
                        {if !$accentPrimaryServiceBtn['active']}disabled="disabled"{/if}
                >
                            <span class="loading" style="display: none;">
                                <i class="fas fa-spinner fa-spin"></i>
                            </span>
                    {$accentPrimaryServiceBtn['display']}
                </button>
            </div>
            {/foreach}
            {if $primaryServiceBtn}
                <div class="div-service-login-buttons d-flex flex-wrap">
                    <button type="button"
                            class="btn btn-secondary btn-sm btn-custom-action btn-service-login{if !$primaryServiceBtn['active']} disabled{/if}"
                            data-serviceid="{$primaryServiceBtn['serviceid']}"
                            data-identifier="{$primaryServiceBtn['identifier']}"
                            data-active="{$primaryServiceBtn['active']}"
                            {if !$primaryServiceBtn['active']}disabled="disabled"{/if}
                    >
                        <span class="loading" style="display: none;">
                            <i class="fas fa-spinner fa-spin"></i>
                        </span>
                        {if $primaryServiceBtn['identifier']|lower == 'cpanel'}
                            <i class="ph ph-squares-four btn-service-icon" aria-hidden="true"></i>
                            <span class="btn-service-label">Acessar Painel</span>
                        {else}
                            <i class="ph ph-squares-four btn-service-icon" aria-hidden="true"></i>
                            <span class="btn-service-label">{$primaryServiceBtn['display']}</span>
                        {/if}
                    </button>
                    {if $secondaryButtons}
                        {foreach $secondaryButtons as $secondaryButton}
                            <button type="button"
                                    class="btn btn-secondary btn-sm btn-custom-action btn-service-login{if !$secondaryButton['active']} disabled{/if}"
                                    data-serviceid="{$secondaryButton['serviceid']}"
                                    data-identifier="{$secondaryButton['identifier']}"
                                    data-active="{$secondaryButton['active']}"
                                    {if !$secondaryButton['active']}disabled="disabled"{/if}
                            >
                                <span class="loading" style="display: none;">
                                    <i class="fas fa-spinner fa-spin"></i>
                                </span>
                                {if $secondaryButton['identifier']|lower == 'webmail'}
                                    <i class="ph ph-mailbox btn-service-icon" aria-hidden="true"></i>
                                    <span class="btn-service-label">Acessar E-mails</span>
                                {else}
                                    <i class="ph ph-envelope btn-service-icon" aria-hidden="true"></i>
                                    <span class="btn-service-label">{$secondaryButton['display']}</span>
                                {/if}
                            </button>
                        {/foreach}
                    {/if}
                </div>
            {/if}
        {/if}
    </div>
</div>