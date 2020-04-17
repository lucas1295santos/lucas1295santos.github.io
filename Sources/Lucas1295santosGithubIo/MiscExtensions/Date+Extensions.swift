import Foundation

extension Date {
    static var customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var toString: String {
        return Date.customFormatter.string(from: self)
    }
}
