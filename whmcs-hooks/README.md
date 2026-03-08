# Hooks do tema Firefly (WHMCS)

Instruções para usar os hooks incluídos no tema Firefly na sua instalação WHMCS.

## FireflyUnifiedSidebar – Sidebar unificada

Uma única sidebar na área do cliente em **todas as páginas**, controlada por um array de configuração. Para mostrar/ocultar itens ou alterar textos e links, basta editar esse array no ficheiro do hook.

### Instalação

1. Copie o ficheiro **`FireflyUnifiedSidebar.php`** para a pasta de hooks do WHMCS:
   - **Destino:** `includes/hooks/` da sua instalação WHMCS  
   - Exemplo: se o WHMCS está em `/var/www/whmcs/`, o ficheiro deve ficar em `/var/www/whmcs/includes/hooks/FireflyUnifiedSidebar.php`.

2. Não é necessário ativar nada: o WHMCS carrega automaticamente todos os ficheiros `.php` dentro de `includes/hooks/`.

### Configuração

Abra `FireflyUnifiedSidebar.php` e edite o array **`$GLOBALS['FIREFLY_SIDEBAR_PANELS']`** no topo do ficheiro.

- **Mostrar/ocultar um painel:** altere `'visible' => true` para `'visible' => false` (ou o contrário).
- **Alterar texto do painel:** altere o valor de `'label'`.
- **Alterar ordem:** altere o valor de `'order'` (número menor = painel mais acima).
- **Ícone (Font Awesome):** altere `'icon'` (ex.: `'fas fa-user'`).
- **Itens dentro do painel:** edite o array `'children'`. Cada filho tem:
  - `'label'` – texto do link
  - `'uri'` – URL (ex.: `'clientarea.php?action=invoices'`)
  - `'icon'` – opcional

Exemplo para ocultar “Downloads” e mudar o texto de “Faturas”:

```php
'invoices' => [
    'visible' => true,
    'order'   => 40,
    'label'   => 'Faturas e Pagamentos',  // texto alterado
    ...
],
'downloads' => [
    'visible' => false,  // painel oculto
    ...
],
```

### Documentação WHMCS

- [Client Area Sidebars](https://docs.whmcs.com/9-0/customization/client-area-customization/client-area-sidebars/)  
- [Menu and Sidebar Context](https://docs.whmcs.com/9-0/customization/client-area-customization/menu-and-sidebar-context/)

Compatível com **WHMCS 9.x**.

---

## FireflyCpanelSidebarStats – Estatísticas e informações do cPanel no painel Pacote/Domínio

Preenche o overview do produto cPanel com dados da barra lateral do cPanel: uso de disco, largura de banda, CPU, memória, domínios, contas de e-mail, etc., obtidos via **UAPI do cPanel** (StatsBar/get_stats e ResourceUsage/get_usages). Também mostra informações gerais (usuário da conta, domínio primário).

### Instalação

1. Copie o ficheiro **`FireflyCpanelSidebarStats.php`** para a pasta de hooks do WHMCS:
   - **Destino:** `includes/hooks/`  
   - Exemplo: `/var/www/whmcs/includes/hooks/FireflyCpanelSidebarStats.php`.

2. O WHMCS carrega os hooks automaticamente. Não é necessário ativar nada.

### Requisitos

- Serviço com **módulo cPanel** e servidor configurado em *Setup → Products/Services → Servers* com **hostname** correto.
- A conta cPanel deve ter **username e password** disponíveis (o WHMCS passa-os ao hook).
- O servidor cPanel deve responder em **porta 2083** (HTTPS) e permitir chamadas UAPI com as credenciais da conta.

### Onde aparece

No painel **Pacote/Domínio** da página de detalhes do produto (overview cPanel), **logo abaixo do nome do plano**, em duas secções:

- **Informações gerais:** usuário da conta, domínio primário.
- **Estatísticas:** largura de banda, uso de disco, contas de e-mail, domínios, subdomínios, bases de dados, etc. (conforme o que o cPanel devolver).

Se a chamada à API falhar (servidor inacessível, credenciais incorretas, firewall), o bloco não é mostrado e a página continua normal.
