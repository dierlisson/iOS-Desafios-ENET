import SwiftUI

public enum TransactionCategory: String, Codable, CaseIterable, Identifiable {
    case salary = "Salário"
    case freelance = "Freelance"
    case investments = "Investimentos"
    case food = "Alimentação"
    case housing = "Moradia"
    case transport = "Transporte"
    case leisure = "Lazer"
    case health = "Saúde"
    case education = "Educação"
    case outros = "Outros"
    
    public var id: String { rawValue }
    
    public var defaultType: TransactionType {
        switch self {
        case .salary, .freelance, .investments:
            return .income
        default:
            return .expense
        }
    }
    
    public var iconName: String {
        switch self {
        case .salary: return "banknote.fill"
        case .freelance: return "laptopcomputer"
        case .investments: return "chart.line.uptrend.xyaxis"
        case .food: return "fork.knife"
        case .housing: return "house.fill"
        case .transport: return "car.fill"
        case .leisure: return "gamecontroller.fill"
        case .health: return "heart.fill"
        case .education: return "book.fill"
        case .outros: return "ellipsis.circle.fill"
        }
    }
    
    public var color: Color {
        switch self {
        case .salary: return .green
        case .freelance: return .teal
        case .investments: return .purple
        case .food: return .orange
        case .housing: return .blue
        case .transport: return .indigo
        case .leisure: return .pink
        case .health: return .red
        case .education: return .cyan
        case .outros: return .gray
        }
    }
}
