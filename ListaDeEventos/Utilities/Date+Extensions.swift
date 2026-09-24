import Foundation

extension Date {
    public var formattedEventDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "E, d 'de' MMM 'às' HH:mm"
        return formatter.string(from: self).capitalized
    }
    
    public var relativeBadgeText: String? {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(self) {
            return "Hoje"
        }
        
        if let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: now), to: calendar.startOfDay(for: self)).day,
           days >= 0 && days <= 7 {
            return "Esta semana"
        }
        
        return nil
    }
    
    public var shortDayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    public var shortMonthString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMM"
        return formatter.string(from: self).uppercased()
    }
}
