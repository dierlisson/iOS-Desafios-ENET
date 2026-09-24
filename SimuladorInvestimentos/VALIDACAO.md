# Validação do Simulador de Investimentos

Revisão em 22/09/2026. Status: **pendente de QA funcional e visual completo no Simulator**.

## Escopo revisado

README raiz e local, referência visual, modelos, motor de cálculo, validação de entrada, três telas, cores adaptativas e projeto Xcode. Dois subagentes independentes analisaram requisitos/cálculos e UI/acessibilidade. Um deles implementou o snapshot de navegação; o outro revisou a alteração.

Foram preservadas as alterações locais já existentes. Nesta revisão, o formulário passou a mostrar a orientação de separadores numéricos e a guardar um snapshot do resultado para manter a tela estável ao redefinir os campos durante o retorno.

## Evidências confirmadas

- Xcode 27.0, build 27A266a.
- Deployment target iOS 17.0.
- Build para iOS Simulator aprovado após as alterações.
- Três testes de cálculo existentes executados com zero falhas.
- `git diff --check` sem erros.
- Branch existente: `codex/simulador-investimentos`.
- Nenhum push realizado.

Comandos executados a partir da raiz:

```sh
xcodebuild -project SimuladorInvestimentos/SimuladorInvestimentos.xcodeproj \
  -scheme SimuladorInvestimentos -sdk iphonesimulator \
  -derivedDataPath /tmp/desafios-simulador-build CODE_SIGNING_ALLOWED=NO build
swift test --package-path SimuladorInvestimentos
```

O build emitiu somente o aviso de extração de metadados App Intents ignorada por ausência de dependência desse framework. O app não implementa App Intents. A execução dos testes também indicou artefatos antigos do SwiftPM relativos ao caminho anterior `desafios ios`; os testes terminaram com sucesso.

## Pendências de execução

### Atualização após recuperação do acesso

O acesso ao CoreSimulator funciona quando `simctl` é executado fora do sandbox, usando a permissão de execução autorizada. O runtime iOS 27.0 está instalado e o iPhone 18 Pro está inicializado. A reinstalação do build e sua abertura foram bem-sucedidas; uma captura real confirmou a renderização de boas-vindas. Portanto, os erros de conexão dentro do sandbox não comprovam ausência de runtime.

Uma nova revisão independente de código, README e referência visual não encontrou defeitos bloqueantes confirmados. Permanecem necessárias as verificações interativas abaixo, especialmente cards com valores extremos e Dynamic Type. O executável gráfico `Simulator.app` não foi encontrado no caminho padrão do Xcode; o acesso por `simctl` permite lançamento e screenshots, mas não oferece comandos de toque.

O manifesto SwiftPM foi atualizado para excluir documentação, screenshots e projeto Xcode do target, corrigindo a origem dos avisos de arquivos não tratados.

### Histórico das tentativas anteriores

Atualização adicional: capturas reais do formulário foram obtidas em aparência clara e escura (`Screenshots/form-light.png` e `Screenshots/form-dark.png`). Os campos, rótulos e seletor de período renderizam em ambas. As capturas não comprovam interação, rolagem ou cálculo. O macOS negou a leitura interativa pelo System Events com “osascript é um acesso assistivo não permitido” (-1728); foi solicitada a habilitação de Acessibilidade para o aplicativo que executa a sessão. O DeviceHub está presente nesta instalação do Xcode, mas isso ainda não comprova acesso aos controles do dispositivo.

As tentativas de abrir o app no iPhone 17e e no iPhone 18 Pro falharam com `FBSOpenApplicationServiceErrorDomain`, código 5: “The system shell probably crashed”. O acesso à interface via System Events expirou com AppleEvent `-1712`. A inicialização do iPhone 18 Pro terminou com sucesso, mas a abertura do aplicativo falhou depois. Não foi possível obter nova captura nem validar os fluxos nesta sessão.

Ainda é necessário validar interativamente:

- Boas-vindas → formulário → resultado → nova simulação → novo cálculo.
- Entrada inválida, limites, teclado, redefinição e retorno entre telas.
- Resumo anual, período parcial e expansão da evolução mensal.
- Formulário e resultado em modo claro/escuro, Dynamic Type ampliado e tamanhos diferentes de iPhone.
- Capturas atuais de todas as telas para comparação com o design.

Os screenshots preexistentes documentam somente boas-vindas e não comprovam a validação completa desta revisão. O próximo desafio não deve ser iniciado enquanto essas pendências permanecerem abertas, conforme a sequência solicitada.
