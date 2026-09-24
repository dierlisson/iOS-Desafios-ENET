**Relatório de análise da pasta desafiosIos**

Data: 22 de setembro de 2026.

A pasta é um repositório de estudos e portfólio da Formação iOS da Escola Nova Era Tech, organizado em seis desafios independentes com dificuldade crescente. Meu entendimento é que o objetivo é demonstrar a evolução do desenvolvimento de interfaces SwiftUI até persistência, integração com APIs, arquitetura em camadas e testes.

O estado encontrado é de **um desafio com implementação e cinco desafios documentados, ainda sem código-fonte**. A documentação apresenta o planejamento completo da formação; ela não deve ser interpretada como evidência de que os seis aplicativos já estão prontos.

**Escopo da análise**

Foram lidos o README principal, os cinco READMEs dos desafios, o manifesto Swift Package Manager, todos os arquivos Swift de implementação e testes e o `.gitignore`. Também foi verificada a estrutura de diretórios, incluindo a existência dos artefatos locais `.build` e `.swiftpm`. Binários, caches de compilação e metadados internos do Git não foram tratados como código do produto.

A análise é estática: não executei a suíte de testes nem validei as telas em simulador. A presença de artefatos de compilação anteriores não comprova que a versão atual compila ou passa nos testes. Nenhum código de implementação foi alterado nesta análise.

**Panorama dos projetos**

| Pasta | Proposta documentada | Estado encontrado |
| --- | --- | --- |
| `SimuladorInvestimentos` | Simular juros compostos com boas-vindas, formulário e resultado | Implementação SwiftUI, modelos, serviço de cálculo, ViewModel, utilitários e três testes |
| `ListaDeEventos` | Listar eventos, buscar por nome, filtrar por categoria e abrir detalhes | README de requisitos e `.gitkeep` |
| `ControleFinanceiro` | Registrar receitas e despesas, persistir com SwiftData e mostrar resumo mensal | README de requisitos e `.gitkeep` |
| `RickAndMortyCharacters` | Consumir API, listar personagens, buscar com debounce e tratar erros | README de requisitos e `.gitkeep` |
| `TechEvents` | Catálogo com filtros compostos, arquitetura em camadas e testes | README de requisitos e `.gitkeep` |
| `Pokedex` | Buscar e listar pokémons com paginação, detalhes, filtros e testes | README de requisitos e `.gitkeep` |

Lista de Eventos e Tech Events têm temas próximos, mas objetivos didáticos distintos: o primeiro exercita listas e navegação; o segundo pretende aprofundar arquitetura e gestão de estado. Não há duplicação de implementação entre eles neste momento.

**Como o Simulador de Investimentos está organizado**

O projeto possui dez arquivos Swift de implementação e testes, totalizando 898 linhas, além de `Package.swift`. Sua organização se aproxima de MVVM, com separação explícita entre apresentação, estado e cálculo:

| Componente | Responsabilidade observada |
| --- | --- |
| `Models/InvestmentModel.swift` | Define entradas, resultado consolidado e evolução mensal |
| `Services/InvestmentCalculator.swift` | Executa a simulação sem depender da interface |
| `ViewModels/SimulationViewModel.swift` | Mantém os campos, interpreta números, valida entradas e solicita o cálculo |
| `Views/WelcomeView.swift` | Apresenta o aplicativo e inicia a navegação |
| `Views/SimulationFormView.swift` | Recebe os parâmetros e permite redefini-los |
| `Views/SimulationResultView.swift` | Apresenta montante, total investido, lucro e evolução |
| `Utilities` | Formata moeda e percentual e adapta cores e teclados às plataformas |
| `SimuladorInvestimentosApp.swift` | Contém a entrada do aplicativo, condicionada à compilação fora de Swift Package |
| `SimuladorInvestimentosTests` | Contém os testes unitários do cálculo |

`WelcomeView` mantém uma instância de `SimulationViewModel` em `@State`. O formulário acessa seus campos com `@Bindable`, enquanto o ViewModel utiliza `@Observable`. A navegação usa `NavigationStack`, `NavigationLink` e um destino acionado após o cálculo.

O fluxo implementado é: boas-vindas → preenchimento de parâmetros → resultado. Os valores iniciais do formulário são R$ 1.000 de capital, R$ 200 de aporte mensal, taxa anual de 12% e prazo de cinco anos. O usuário pode escolher meses ou anos. A validação exige valores não negativos e prazo entre um e 600 meses.

O resultado apresenta montante final, capital investido, lucro em juros e uma barra proporcional de composição. O cálculo gera todos os meses solicitados, mas a interface mostra somente os primeiros 24, seguidos de uma mensagem sobre os restantes. Não há ação implementada para expandir essa lista.

**O que a regra de cálculo representa**

A taxa mensal é calculada como `(1 + taxaAnual / 100)^(1/12) - 1`. Portanto, o código trata a taxa informada como taxa anual efetiva e calcula sua equivalente mensal, em vez de simplesmente dividir o percentual anual por 12.

Em cada mês, primeiro são calculados juros sobre o saldo existente; depois é adicionado o aporte. Isso corresponde a aportes no final de cada mês. O resultado registra depósitos acumulados, juros do mês, juros acumulados e saldo.

Trata-se de uma projeção matemática com taxa constante. O código não modela impostos, taxas, inflação, variação de rentabilidade ou produtos financeiros específicos. Também não há persistência de simulações, autenticação, chamadas de rede ou dependências externas declaradas no pacote.

**Configuração de execução e testes**

O manifesto declara Swift tools 5.9, iOS 17 e macOS 14 como versões mínimas. Há adaptações explícitas para UIKit e AppKit, indicando intenção de compartilhar a interface entre iOS e macOS.

Um ponto relevante é que `Package.swift` publica uma **biblioteca**, e o arquivo de entrada desativa `@main` quando `SWIFT_PACKAGE` está definido. Não encontrei um projeto `.xcodeproj` com target de aplicativo. Existe um workspace gerado pelo Swift Package Manager em `.swiftpm`, mas ele não equivale a um target de aplicativo iOS configurado. Assim, o repositório contém as telas e a lógica, porém ainda precisa de uma configuração de aplicativo hospedeiro para sua execução como app iOS independente.

Os três testes existentes verificam:

1. Depósitos totais, crescimento do saldo, lucro positivo e quantidade de meses em uma simulação com aportes.
2. Retorno zerado quando o prazo é zero.
3. Montante aproximado de R$ 1.120 para R$ 1.000 aplicados por 12 meses a 12% ao ano, sem aportes.

Essa é uma base útil, mas o teste com aportes não compara o montante final com um valor esperado preciso. Não há testes do ViewModel, da interpretação de números, dos limites de entrada ou do fluxo de interface. A existência dos três casos foi confirmada por leitura, sem aferição de aprovação nesta análise.

**Pontos de atenção identificados no código**

| Prioridade sugerida | Observação | Consequência |
| --- | --- | --- |
| Alta | A conversão de anos para meses usa `value * 12` antes de validar o máximo de 600 meses | Um inteiro muito grande, mas aceito por `Int`, pode provocar overflow e encerrar o processo |
| Alta | Valores monetários e taxa são validados apenas com comparação `>= 0`, sem `isFinite` ou limites de magnitude | Valores extremos podem gerar infinito; o resultado converte a proporção de juros para `Int`, o que pode falhar para um resultado não finito |
| Média | O botão de cálculo fica desabilitado quando os campos são inválidos, mas as mensagens de erro só são definidas ao tentar calcular | No fluxo normal, o usuário pode ficar sem explicação do motivo de o botão estar desabilitado |
| Média | A leitura dos números apenas troca vírgula por ponto | `1000,50` é interpretável, mas `1.000,50`, com separador de milhar brasileiro, não é |
| Média | A tela limita a evolução a 24 meses, embora aceite até 600 | A promessa de relatório mensal é atendida apenas parcialmente na apresentação |
| Baixa | `SimulationResultView` mantém um `LegacyWrapper` com `@ObservedObject` sem publicar mudanças ou utilizá-lo no conteúdo | Há complexidade desnecessária junto ao uso de Observation |

Esses riscos foram identificados por inspeção, sem reprodução dinâmica nesta análise. As referências principais são `SimulationViewModel.swift:47–65`, `SimulationFormView.swift:98` e `SimulationResultView.swift:65`.

O serviço público também tem um contrato mais permissivo que a interface: transforma capital e aporte negativos em zero, não rejeita taxa negativa e limita o lucro final ao mínimo de zero. Se ele for reutilizado fora do formulário, convém definir explicitamente como entradas inválidas e perdas devem ser representadas. Da mesma forma, o retorno totalmente zerado para prazo zero é uma decisão já registrada em teste, embora descarte o capital inicial informado.

**Qualidades e próximos passos sugeridos**

A separação do cálculo em um serviço independente, os modelos simples, os componentes visuais reutilizáveis e a organização por responsabilidades facilitam a leitura e a evolução. Os requisitos dos seis desafios estão bem delimitados, e o `.gitignore` contempla artefatos comuns de Xcode, Swift Package Manager e macOS.

Para concluir o primeiro desafio de forma verificável, a sequência recomendada é:

1. Configurar o target de aplicativo e documentar como abrir, executar e testar o simulador.
2. Tratar overflow, valores não finitos e limites numéricos antes de calcular.
3. Dar feedback de validação durante a edição e definir o formato de entrada monetária aceito.
4. Ampliar os testes para cálculo exato com aportes, taxa zero, conversão de prazo e entradas inválidas.
5. Decidir se a evolução mensal deve permitir consultar todos os meses e remover o wrapper sem função atual.
6. Atualizar o README principal com o estado real de cada desafio e criar um README específico do simulador.

A pasta representa uma trilha de aprendizado organizada, com uma primeira implementação que já demonstra navegação, estado, regras de negócio e testes. Persistência, APIs, paginação e arquitetura em camadas permanecem como objetivos dos próximos projetos, sem implementação presente nos arquivos analisados.
