# 6️⃣ Pokédex

**Nível:** Avançado 🔴 | **Diretório:** `/Pokedex`

Projeto final em SwiftUI com API real (PokéAPI), paginação incremental e foco em qualidade de software com testes automatizados.

## 🎯 Objetivo
Entregar uma Pokédex em SwiftUI com busca, detalhe e paginação, aplicando testes unitários e organização de código.

## 🛠️ Tecnologias e Práticas
- `Swift 5 / 6`
- `SwiftUI`
- `iOS 17+`
- `PokéAPI Integration (URLSession async/await)`
- `Paginação incremental (Infinite Scroll)`
- `Filtro de busca por nome ou ID (#001)`
- `Filtro por Tipo (18 tipos com cores e ícones customizados)`
- `Visualização de Atributos Base (Barras de progresso animadas)`
- `Mocks de serviço para testes e previews`
- `XCTest (5 unit tests passing)`

## ✅ Requisitos para entrega
- Listar pokémons com carregamento paginado real (`/pokemon?limit=20&offset=...`).
- Busca instantânea por nome ou número (#ID) e filtro por tipo de Pokémon.
- Tela de detalhe com hero header em gradiente, imagem de alta resolução, tipos, altura, peso, habilidades e barras de atributos base.
- Suíte de testes unitários no XCTest validando paginação, filtros e casos de erro.

---

## 📱 Implementação

### Estrutura de Pastas
```
Pokedex/
├── Sources/Pokedex/
│   ├── Domain/
│   │   └── Models/ (Pokemon, PokemonDetail, PokemonType, PokemonStat)
│   ├── Data/
│   │   └── Network/ (PokedexService, PokedexServiceProtocol, MockPokedexService, PokedexDTOs)
│   ├── Presentation/
│   │   └── ViewModels/ (PokedexViewModel)
│   ├── Views/ (PokedexListView, PokemonCardView, PokemonDetailView, StatBarView, TypeBadgeView)
│   └── Utilities/ (ColorExtensions)
├── Tests/PokedexTests/
│   └── PokedexViewModelTests.swift
├── PokedexApp.swift
├── Package.swift
└── Pokedex.xcodeproj
```

### Como Executar
1. Abra o arquivo `Pokedex.xcodeproj` no Xcode 15+.
2. Selecione o target `Pokedex` e um Simulator iOS 17+ (ex: iPhone 18 Pro).
3. Pressione `Cmd + R` para rodar o app.
4. Para executar a suíte de testes: `swift test --package-path Pokedex` no terminal ou `Cmd + U` no Xcode.
