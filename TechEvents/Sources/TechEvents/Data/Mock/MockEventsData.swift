import Foundation

public enum MockEventsData {
    public static var sampleEvents: [TechEvent] {
        [
            TechEvent(
                id: "event-1",
                title: "iOS Brasil Conf 2026",
                summary: "O maior evento de desenvolvimento Swift e iOS da América Latina.",
                fullDescription: "Edição presencial reunindo os principais especialistas da comunidade Swift. Palestras sobre SwiftUI avançado, Swift 6 Concurrency, arquiteturas modernas e inteligência artificial on-device com CoreML e Apple Intelligence.",
                date: Date().addingTimeInterval(86400 * 15),
                dateFormatted: "15 de Outubro de 2026 • 09:00",
                location: "Centro de Convenções Rebouças, São Paulo - SP",
                format: .presencial,
                modality: .conference,
                isFree: false,
                price: 299.00,
                bannerUrl: "https://images.unsplash.com/photo-1540575467063-178a50c2df87",
                speakers: [
                    Speaker(
                        id: "speaker-1",
                        name: "Ana Clara Silva",
                        role: "Staff iOS Engineer",
                        company: "Apple Specialist LATAM",
                        bio: "Engenheira de software com 10 anos de experiência focada em performance e Swift Concurrency."
                    ),
                    Speaker(
                        id: "speaker-2",
                        name: "Lucas Mendes",
                        role: "Principal Tech Lead",
                        company: "Fintech Mobile",
                        bio: "Entusiasta de arquitetura limpa e testes automatizados no ecossistema iOS."
                    )
                ],
                schedule: [
                    ScheduleSlot(
                        id: "slot-1",
                        title: "Abertura & Keynote: O Futuro do Swift 6",
                        description: "Visão geral sobre strict concurrency checking e novas APIs do iOS 18+.",
                        startTime: "09:00",
                        endTime: "10:15",
                        room: "Auditório Principal",
                        speaker: Speaker(
                            id: "speaker-1",
                            name: "Ana Clara Silva",
                            role: "Staff iOS Engineer",
                            company: "Apple Specialist LATAM"
                        )
                    ),
                    ScheduleSlot(
                        id: "slot-2",
                        title: "Arquitetura Modular em Apps de Grande Porte",
                        description: "Estratégias de desacoplamento de código e Swift Package Manager.",
                        startTime: "10:45",
                        endTime: "12:00",
                        room: "Sala Swift 01",
                        speaker: Speaker(
                            id: "speaker-2",
                            name: "Lucas Mendes",
                            role: "Principal Tech Lead",
                            company: "Fintech Mobile"
                        )
                    )
                ],
                isBookmarked: true
            ),
            TechEvent(
                id: "event-2",
                title: "SwiftUI Advanced Masterclass",
                summary: "Workshop prático online sobre animações complexas e estado reativo com @Observable.",
                fullDescription: "Aprenda a construir UIs de nível mundial com custom layouts, phase animators e integração profunda com a macro @Observable do Swift 5.9+.",
                date: Date().addingTimeInterval(86400 * 5),
                dateFormatted: "05 de Outubro de 2026 • 19:00",
                location: "Transmissão Online via Zoom & YouTube",
                format: .online,
                modality: .workshop,
                isFree: true,
                price: 0.0,
                bannerUrl: "https://images.unsplash.com/photo-1517694712202-14dd9538aa97",
                speakers: [
                    Speaker(
                        id: "speaker-3",
                        name: "Mariana Costa",
                        role: "UI/UX & iOS Developer",
                        company: "Design Systems Studio",
                        bio: "Especialista em animações interativas e acessibilidade em apps iOS."
                    )
                ],
                schedule: [
                    ScheduleSlot(
                        id: "slot-3",
                        title: "Dominando @Observable e State Management",
                        description: "Migração de ObservableObject para @Observable com ganho de performance.",
                        startTime: "19:00",
                        endTime: "21:00",
                        room: "Sala Virtual A",
                        speaker: Speaker(
                            id: "speaker-3",
                            name: "Mariana Costa",
                            role: "UI/UX & iOS Developer",
                            company: "Design Systems Studio"
                        )
                    )
                ],
                isBookmarked: false
            ),
            TechEvent(
                id: "event-3",
                title: "AI & Mobile Developers Meetup",
                summary: "Encontro híbrido focado na integração de Large Language Models em aplicações móveis.",
                fullDescription: "Venha discutir como conectar APIs da OpenAI, Gemini e modelos rodando localmente no iPhone. Happy hour presencial e transmissão ao vivo para inscritos.",
                date: Date().addingTimeInterval(86400 * 20),
                dateFormatted: "20 de Outubro de 2026 • 18:30",
                location: "CUBO Itaú - São Paulo & Stream Online",
                format: .hybrid,
                modality: .meetup,
                isFree: true,
                price: 0.0,
                bannerUrl: "https://images.unsplash.com/photo-1531482615713-2afd69097998",
                speakers: [
                    Speaker(
                        id: "speaker-4",
                        name: "Gabriel Santos",
                        role: "AI Research Engineer",
                        company: "DeepTech Labs",
                        bio: "Pesquisador focado em modelos de linguagem otimizados para dispositivos móveis."
                    )
                ],
                schedule: [
                    ScheduleSlot(
                        id: "slot-4",
                        title: "Integração do Gemini API com Swift Async/Await",
                        description: "Demonstração prática de requisições streaming e structured output no Swift.",
                        startTime: "19:00",
                        endTime: "20:00",
                        room: "Auditório Cubo",
                        speaker: Speaker(
                            id: "speaker-4",
                            name: "Gabriel Santos",
                            role: "AI Research Engineer",
                            company: "DeepTech Labs"
                        )
                    )
                ],
                isBookmarked: false
            ),
            TechEvent(
                id: "event-4",
                title: "Hackathon Mobile Brasil 2026",
                summary: "48 horas ininterruptas criando soluções inovadoras para problemas de impacto social.",
                fullDescription: "Desafio nacional para desenvolvedores, designers e gerentes de produto. Prêmios em dinheiro e mentoria presencial com grandes empresas de tecnologia.",
                date: Date().addingTimeInterval(86400 * 30),
                dateFormatted: "30 de Outubro de 2026 • 18:00",
                location: "Hub de Inovação de Florianópolis - SC",
                format: .presencial,
                modality: .hackathon,
                isFree: true,
                price: 0.0,
                bannerUrl: "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
                speakers: [
                    Speaker(
                        id: "speaker-5",
                        name: "Roberto Lima",
                        role: "Head of Product Innovation",
                        company: "Venture Builder LATAM",
                        bio: "Mentor de startups e organizador de mais de 20 hackathons de tecnologia."
                    )
                ],
                schedule: [
                    ScheduleSlot(
                        id: "slot-5",
                        title: "Kickoff e Divulgação dos Desafios",
                        description: "Formação de equipes e início da maratona de desenvolvimento.",
                        startTime: "18:00",
                        endTime: "19:30",
                        room: "Arena Principal",
                        speaker: Speaker(
                            id: "speaker-5",
                            name: "Roberto Lima",
                            role: "Head of Product Innovation",
                            company: "Venture Builder LATAM"
                        )
                    )
                ],
                isBookmarked: true
            ),
            TechEvent(
                id: "event-5",
                title: "Clean Architecture & Testing Masterclass",
                summary: "Aprenda a aplicar Clean Architecture, Use Cases e Test Driven Development no iOS.",
                fullDescription: "Imersão completa com foco em desacoplamento de camadas de apresentação, domínio e dados. Cobertura de testes unitários e mocks determinísticos.",
                date: Date().addingTimeInterval(86400 * 10),
                dateFormatted: "10 de Outubro de 2026 • 14:00",
                location: "Plataforma WebEx & Discord",
                format: .online,
                modality: .workshop,
                isFree: false,
                price: 149.90,
                bannerUrl: "https://images.unsplash.com/photo-1522071820081-009f0129c71c",
                speakers: [
                    Speaker(
                        id: "speaker-6",
                        name: "Beatriz Rocha",
                        role: "Lead iOS Architect",
                        company: "BankTech Global",
                        bio: "Arquiteta de sistemas móveis com vasta vivência em ecossistemas de alta segurança."
                    )
                ],
                schedule: [
                    ScheduleSlot(
                        id: "slot-6",
                        title: "Construindo Casos de Uso com Protocolos no Swift",
                        description: "Como estruturar Use Cases independentes da interface gráfica.",
                        startTime: "14:00",
                        endTime: "16:00",
                        room: "Workshop Room 01",
                        speaker: Speaker(
                            id: "speaker-6",
                            name: "Beatriz Rocha",
                            role: "Lead iOS Architect",
                            company: "BankTech Global"
                        )
                    )
                ],
                isBookmarked: false
            )
        ]
    }
}
