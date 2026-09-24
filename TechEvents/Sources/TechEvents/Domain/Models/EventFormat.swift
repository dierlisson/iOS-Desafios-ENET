import Foundation
import SwiftUI

public enum EventFormat: String, CaseIterable, Codable, Sendable, Identifiable {
    case presencial
    case online
    case hybrid
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .presencial:
            return "Presencial"
        case .online:
            return "Online"
        case .hybrid:
            return "Híbrido"
        }
    }
    
    public var iconName: String {
        switch self {
        case .presencial:
            return "building.2.fill"
        case .online:
            return "laptopcomputer"
        case .hybrid:
            return "person.2.wave.2.fill"
        }
    }
    
    public var color: Color {
        switch self {
        case .presencial:
            return .blue
        case .online:
            return .purple
        case .hybrid:
            return .orange
        }
    }
}
