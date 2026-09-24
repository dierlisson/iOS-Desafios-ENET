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
        case .freelance: return "chart.line.uptrend.xyaxis"
        case .investments: return "briefcase.fill"
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
        case .freelance: return .purple
        case .investments: return .teal
        case .food: return .orange
        case .housing: return .blue
        case .transport: return Color(red: 0.3, green: 0.45, blue: 0.95)
        case .leisure: return .pink
        case .health: return .red
        case .education: return .cyan
        case .outros: return .gray
        }
    }
}
