import Foundation

extension Date {
    static var customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    var toString: String {
        return Date.customFormatter.string(from: self)
    }
}
