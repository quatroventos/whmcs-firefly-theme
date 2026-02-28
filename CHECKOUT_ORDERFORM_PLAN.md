# Plano: Order Form Checkout em Duas Colunas (Desktop)

Plano para um repositório que contém apenas o **order form customizado** do WHMCS. O layout em duas colunas (cadastro à esquerda, pagamento à direita, em cards) é obtido via HTML no template; o CSS fica no **tema** (Firefly ou outro) que consome este order form.

---

## Objetivo

- Order form customizado que herda do **Standard Cart** e altera apenas a página de checkout.
- No checkout, o formulário deve ter dois blocos claros no HTML:
  - **Esquerda (cadastro):** conta existente/login, dados pessoais, endereço de cobrança, campos customizados, contacto do domínio (se aplicável), segurança (senha), captcha — tudo até antes da secção "Detalhes do pagamento".
  - **Direita (pagamento):** "Detalhes do pagamento", total a pagar, crédito, gateways, cartão, notas, TOS, botão finalizar.
- Cada bloco dentro de um wrapper com classes para o tema aplicar layout em duas colunas e estilo de card **apenas em desktop** (o tema faz isso com CSS `@media (min-width: 992px)`).
- Em mobile o HTML continua a ser dois blocos em sequência; o tema não altera o layout (empilhado).

---

## Estrutura do repositório

```
orderforms/
  firefly_cart/           # ou outro nome (ex.: firefly_checkout)
    theme.yaml
    checkout.tpl
```

- Só estes dois ficheiros. Todo o resto (viewcart, products, configureproduct, etc.) é herdado do `standard_cart`.

---

## 1. theme.yaml

Criar `orderforms/firefly_cart/theme.yaml` com:

```yaml
config:
  parent: standard_cart
```

Isto faz com que todos os templates não definidos neste diretório sejam carregados do Standard Cart.

---

## 2. checkout.tpl

- **Fonte:** Copiar o `checkout.tpl` do [Standard Cart (GitHub)](https://github.com/WHMCS/orderforms-standard_cart/blob/master/checkout.tpl).
- **Alteração única:** Adicionar dois wrappers no interior do `<form id="frmCheckout">`, sem mudar a ordem nem os IDs dos campos.

### Ponto de corte

- No template original, a secção de pagamento começa com o bloco:
  - `<div class="sub-heading">` que contém `{$LANG.orderForm.paymentDetails}` (ex.: "Detalhes do pagamento" / "Payment Details").
  - Imediatamente a seguir vem o elemento com `id="totalDueToday"` (total a pagar hoje).

### Estrutura desejada no HTML (após edição)

```html
<form method="post" ... id="frmCheckout">
  <input type="hidden" ... />
  <!-- outros hidden que existam no início -->

  <div class="checkout-card checkout-card-left">
    <!-- Tudo desde: already-registered, containerExistingAccountSelect, containerExistingUserSignin,
         containerNewUserSignup (dados pessoais, billing, custom fields, domain contact, security, captcha)
         até ao último bloco ANTES do div.sub-heading de paymentDetails -->
  </div>

  <div class="checkout-card checkout-card-right">
    <div class="sub-heading">
      <span class="primary-bg-color">{$LANG.orderForm.paymentDetails}</span>
    </div>
    <div id="totalDueToday" ...>...</div>
    <!-- applyCreditContainer, paymentGatewaysContainer, creditCardInputFields, notes, TOS, botão, etc. -->
  </div>
</form>
```

### Passos concretos no checkout.tpl

1. Localizar a abertura do `<form id="frmCheckout">` e os primeiros `<input type="hidden">` (e quaisquer outros elementos que devam ficar no início do form). Deixá-los como estão.
2. Imediatamente a seguir aos hidden iniciais, abrir:  
   `<div class="checkout-card checkout-card-left">`
3. Manter todo o conteúdo existente (already-registered, containerExistingAccountSelect, containerExistingUserSignin, containerNewUserSignup com todos os blocos internos: dados pessoais, billing, custom fields, domain registrant se houver, account security, hookOutput, captcha) até **antes** do próximo passo.
4. Fechar o primeiro wrapper:  
   `</div>`
5. Abrir o segundo wrapper:  
   `<div class="checkout-card checkout-card-right">`
6. Incluir o bloco que começa com:  
   `<div class="sub-heading">` com `{$LANG.orderForm.paymentDetails}`  
   e todo o conteúdo seguinte até ao fim do form (totalDueToday, applyCreditContainer, paymentGatewaysContainer, creditCardInputFields, notes, marketing opt-in, TOS, botão, scripts inline se existirem dentro do form, etc.).
7. Fechar o segundo wrapper:  
   `</div>`
8. Fechar o `</form>` como no original.

### Verificações

- Todos os `name` e `id` dos inputs permanecem iguais.
- O `#totalDueToday` continua a existir e no mesmo contexto (dentro do form), para possível uso por JavaScript do WHMCS ou do tema.
- Não remover nem mover nenhum `{if}`, `{foreach}` ou includes; apenas envolver blocos nos dois divs.

---

## 3. Instalação (para documentar no README do novo repo)

1. Clonar ou copiar o conteúdo do repositório para a instalação WHMCS.
2. Copiar a pasta do order form (ex.: `firefly_cart`) para o diretório de order forms do WHMCS:  
   `templates/orderforms/firefly_cart/`  
   (deve conter `theme.yaml` e `checkout.tpl`).
3. No WHMCS: **Configuração** > **Definições do sistema** > **Geral** > separador **Ordering** (Encomenda).
4. Em **Default Order Form Template** (Modelo de formulário de encomenda predefinido), selecionar **firefly_cart** (ou o nome usado).
5. Guardar.

Alternativa: definir o order form por grupo de produtos em **Configuração** > **Definições do sistema** > **Produtos/Serviços** > grupo > **Order Form Template**.

---

## 4. Tema (responsabilidade do tema, não deste repo)

O repositório do **tema** (ex.: Firefly) deve ter CSS semelhante a:

- Dentro de `@media (min-width: 992px)`:
  - `#order-standard_cart #frmCheckout`: `display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;`
  - `.checkout-card`: estilo de card (fundo, borda, border-radius, padding, sombra).

Em viewports menores, não aplicar grid; os dois `.checkout-card` ficam em bloco (empilhados). Nenhum JavaScript é necessário para a estrutura se este order form estiver em uso.

---

## 5. Resumo de ficheiros neste repo

| Ficheiro | Ação |
| -------- | ----- |
| `orderforms/firefly_cart/theme.yaml` | Criar com `config.parent: standard_cart`. |
| `orderforms/firefly_cart/checkout.tpl` | Copiar do standard_cart e adicionar os dois wrappers `.checkout-card-left` e `.checkout-card-right` como descrito acima. |

Opcional: README com instruções de instalação e referência a este plano.
