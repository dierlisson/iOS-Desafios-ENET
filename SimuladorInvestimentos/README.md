# Simulador de Investimentos

Aplicativo iOS em SwiftUI para projetar juros compostos com um valor inicial e aportes mensais. O fluxo tem três telas: boas-vindas, parâmetros e resultado. A referência visual é `desafio-ios-simulador-investimentos-detalhe.webp` nesta pasta.

## Funcionalidades

- Entrada de capital inicial, aporte mensal, taxa anual e período em anos ou meses.
- Validação de valores finitos e não negativos, com limites de R$ 1 bilhão por campo, 100% ao ano e 600 meses.
- Resultado com montante final, total investido, lucro, resumo anual e evolução mensal completa.
- Mensagens de validação no formulário e opção de redefinir ou iniciar nova simulação.

## Tecnologias e arquitetura

Swift, SwiftUI, Observation e Foundation; compatível com **iOS 17+**. As `Views` apresentam o fluxo, `SimulationViewModel` interpreta e valida a entrada, `InvestmentCalculator` calcula a projeção, `Models` representam entradas e resultados, e `Utilities` reúnem formatação e cores. A separação mantém as regras de cálculo independentes da interface.

## Cálculo e limites

A taxa informada é anual efetiva e é convertida para uma taxa mensal equivalente. Os juros incidem sobre o saldo existente e cada aporte entra **ao final** do mês. A projeção usa taxa constante e não desconta impostos, taxas ou inflação. Os números são apresentados em reais, com duas casas decimais; o cálculo interno usa `Double`, de modo que valores extremos podem ter pequenas diferenças de arredondamento em centavos.

O formulário aceita `1.234,56` no padrão brasileiro. Também aceita `12.5` como decimal em teclados que oferecem ponto; `1.234` representa mil duzentos e trinta e quatro, portanto use vírgula em entradas ambíguas. O prazo é um número inteiro entre 1 e 50 anos, ou 1 e 600 meses.

Essa orientação também aparece no formulário. A tela de resultado mantém uma cópia da projeção durante a navegação, permitindo limpar os campos ao iniciar uma nova simulação sem remover o resultado durante a transição.

## Como executar

1. Abra `SimuladorInvestimentos.xcodeproj` no Xcode.
2. Selecione o esquema `SimuladorInvestimentos` e um iPhone Simulator.
3. Execute o aplicativo com **Run** (`⌘R`).

Os três testes de cálculo existentes podem ser executados pelo terminal com `swift test --package-path SimuladorInvestimentos` a partir da raiz do repositório. O `Package.swift` mantém o módulo de cálculo e UI disponível como pacote Swift. O target do Xcode é o aplicativo iOS executável.

## Estrutura

- `Models`: parâmetros, resultados e evolução mensal.
- `Services`: motor de juros compostos.
- `ViewModels`: validação, interpretação e estado da simulação.
- `Views`: boas-vindas, formulário e resultado.
- `Utilities`: formatação e aparência.
- `SimuladorInvestimentosTests`: testes existentes para o cálculo.

## Design

O app usa a composição verde e os cards claros da referência. O formulário e o relatório mensal se ajustam à largura disponível e ao tamanho dinâmico do texto. A UI usa cores adaptativas para melhorar o contraste no modo escuro.

## Screenshot

![Boas-vindas no iPhone 18 Pro](Screenshots/welcome.png)

![Boas-vindas em modo escuro](Screenshots/welcome-dark.png)
