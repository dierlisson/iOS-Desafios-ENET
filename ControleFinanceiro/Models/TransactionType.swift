import Foundation
import SwiftUI

public enum TransactionType: String, Codable, CaseIterable, Identifiable {
    case income = "Receita"
    case expense = "Despesa"
    
    public var id: String { rawValue }
    
    public var color: Color {
        switch self {
        case .income: return .green
        case .expense: return .red
        }
    }
    
    public var iconName: String {
        switch self {
        case .income: return "arrow.down.left.circle.fill"
        case .expense: return "arrow.up.right.circle.fill"
        }
    }
}
