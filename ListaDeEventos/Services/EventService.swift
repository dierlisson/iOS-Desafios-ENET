import Foundation

public protocol EventServiceProtocol {
    func fetchEvents() async throws -> [Event]
}

public final class EventService: EventServiceProtocol {
    public init() {}
    
    public func fetchEvents() async throws -> [Event] {
        // Simulando delay de rede para demonstrar loading state limpo
        try? await Task.sleep(nanoseconds: 300_000_000)
        return EventService.sampleEvents
    }
    
    public static var sampleEvents: [Event] {
        let calendar = Calendar.current
        let now = Date()
        
        return [
            Event(
                title: "WWDC 2026 Keynote Watch Party",
                subtitle: "Assista ao vivo aos lançamentos do ecossistema Apple com a comunidade.",
                date: calendar.date(byAdding: .day, value: 3, to: now) ?? now,
                location: "São Paulo, SP",
                address: "Av. Paulista, 1000 - Bela Vista",
                category: .tech,
                description: "Reunião especial para desenvolvedores e entusiastas acompanharem a transmissão oficial da WWDC26. Teremos debates técnicos sobre novas APIs em SwiftUI, SwiftData e Apple Intelligence, além de networking com chopp e pizza.",
                iconName: "apple.logo",
                price: "Gratuito",
                organizer: "Comunidade iOS Brasil",
                maxCapacity: 150,
                attendeesCount: 112
            ),
            Event(
                title: "SwiftUI & Architecture Masterclass",
                subtitle: "Boas práticas de arquitetura, separação de estado e performance em iOS 17+.",
                date: calendar.date(byAdding: .day, value: 7, to: now) ?? now,
                location: "Online (Live Zoom)",
                address: "Link enviado após inscrição",
                category: .workshop,
                description: "Workshop prático avançado abordando a transição de ObservableObject para o novo macro @Observable, concorrência estruturada com async/await, isolamento de Actors e estratégias eficientes de testes unitários em ViewModels.",
                iconName: "swift",
                price: "R$ 49,90",
                organizer: "Escola Nova Era Tech",
                maxCapacity: 300,
                attendeesCount: 245
            ),
            Event(
                title: "Design System Conf 2026",
                subtitle: "Como escalar a consistência visual de produtos digitais em grande escala.",
                date: calendar.date(byAdding: .day, value: 14, to: now) ?? now,
                location: "Florianópolis, SC",
                address: "Centro de Convenções Canasvieiras",
                category: .design,
                description: "Conferência voltada a Product Designers, UI/UX Specialists e Desenvolvedores Mobile. Palestras sobre Tokens de Design, Acessibilidade nativa, Dark Mode inteligente e sincronização perfeita entre Figma e SwiftUI.",
                iconName: "paintpalette.fill",
                price: "R$ 149,00",
                organizer: "Design Guild Brasil",
                maxCapacity: 200,
                attendeesCount: 180
            ),
            Event(
                title: "Startup Pitch Night & Inovação",
                subtitle: "Apresentação de startups inovadoras para investidores-anjo e fundos VCs.",
                date: calendar.date(byAdding: .day, value: 21, to: now) ?? now,
                location: "Rio de Janeiro, RJ",
                address: "InovaHub - Porto Maravilha",
                category: .business,
                description: "Noite de pitches rápidos com startups selecionadas dos setores de Fintech, Healthtech e Edtech. Espaço para rodadas de perguntas com investidores e coquetel de encerramento para conexões estratégicas.",
                iconName: "chart.line.uptrend.xyaxis",
                price: "Gratuito",
                organizer: "Venture Club RJ",
                maxCapacity: 120,
                attendeesCount: 95
            ),
            Event(
                title: "Mentoria de Carreira iOS & Portfólio",
                subtitle: "Como preparar seu GitHub, LinkedIn e projetos para vagas internacionais.",
                date: calendar.date(byAdding: .day, value: 30, to: now) ?? now,
                location: "Online (Google Meet)",
                address: "Link enviado por e-mail",
                category: .career,
                description: "Sessão prática focada no desenvolvimento profissional em iOS. Dicas cruciais para entrevistas técnicas, construção de READMEs profissionais, demonstração de projetos no Simulator e posicionamento para vagas remotas em dólar/euro.",
                iconName: "person.crop.circle.badge.checkmark",
                price: "Gratuito",
                organizer: "iOS Career Lab",
                maxCapacity: 50,
                attendeesCount: 48
            ),
            Event(
                title: "DevOps & Cloud Native Summit",
                subtitle: "Infraestrutura moderna, CI/CD autônomo e observabilidade de microsserviços.",
                date: calendar.date(byAdding: .day, value: 45, to: now) ?? now,
                location: "Belo Horizonte, MG",
                address: "Tech Tower - Savassi",
                category: .tech,
                description: "Encontro técnico explorando automatização de testes com Xcode Cloud, pipelines em GitHub Actions, distribuição via TestFlight e monitoramento de crashlytics e performance em tempo real.",
                iconName: "cloud.fill",
                price: "R$ 89,00",
                organizer: "Cloud BH Community",
                maxCapacity: 180,
                attendeesCount: 130
            )
        ]
    }
}
