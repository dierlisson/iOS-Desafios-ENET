import Foundation

extension Date {
    public var formattedEventDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "E, d 'de' MMM 'às' HH:mm"
        return formatter.string(from: self).capitalized
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
