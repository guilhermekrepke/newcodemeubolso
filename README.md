# Meu Bolso

Estrutura de `lib/`:

- `core/`: tema, textos (um arquivo por idioma), formatação e navegação.
- `data/`: modelos (Tx, MkItem, Promo, AiItem) e o `Store`, que guarda e salva os dados.
- `services/`: API da IA e leitura de planilhas. Não têm tela.
- `widgets/`: componentes usados em várias telas.
- `features/`: uma pasta por tela (home, transactions, market, settings, shell).

Regras: telas usam `data/` e `services/`; `data/` e `services/` não conhecem as telas.
Imagens futuras: criar `assets/images/` e declarar no `pubspec.yaml`.

## Entrada rápida no painel

O cartão **Lançar com IA** aceita texto escrito, ditado pelo microfone e ficheiros XLSX/CSV. A análise identifica receitas, despesas e dívidas por pagar, ou produtos para a lista de compras. Antes de guardar, apresenta uma pré-visualização para o utilizador selecionar os itens.

Receitas e despesas precisam de valor; produtos da lista podem ser registados sem preço, sem inventar estimativas. A análise usa a chave da API Anthropic configurada no próprio cartão.

Arquivos:

core/l10n/en_strings.dart  (1 linhas)
core/l10n/es_strings.dart  (1 linhas)
core/l10n/pt_strings.dart  (1 linhas)
core/l10n/ru_strings.dart  (1 linhas)
core/l10n/strings.dart  (7 linhas)
core/l10n/zh_strings.dart  (1 linhas)
core/navigation.dart  (1 linhas)
core/theme/app_theme.dart  (19 linhas)
core/utils/format.dart  (14 linhas)
data/models/ai_item.dart  (46 linhas)
data/models/market.dart  (18 linhas)
data/models/tx.dart  (21 linhas)
data/store.dart  (119 linhas)
features/home/ai/ai_card.dart  (172 linhas)
features/home/ai/ai_review_sheet.dart  (65 linhas)
features/home/home_page.dart  (129 linhas)
features/home/widgets/dashboard_widgets.dart  (30 linhas)
features/market/market_tiles.dart  (32 linhas)
features/market/mk_page.dart  (31 linhas)
features/market/mk_sheet.dart  (57 linhas)
features/settings/settings_page.dart  (26 linhas)
features/shell/shell_page.dart  (36 linhas)
features/transactions/add_sheet.dart  (101 linhas)
features/transactions/list_page.dart  (20 linhas)
features/transactions/pay_sheet.dart  (48 linhas)
features/transactions/tx_tile.dart  (17 linhas)
main.dart  (21 linhas)
services/ai_service.dart  (46 linhas)
services/spreadsheet_service.dart  (26 linhas)
widgets/common.dart  (35 linhas)
