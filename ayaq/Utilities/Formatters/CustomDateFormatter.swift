
import Foundation

struct CustomDateFormatter {
    
    private static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    private static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private static let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func formatShort(_ date: Date) -> String {
        return shortDateFormatter.string(from: date)
    }
    
    static func formatMedium(_ date: Date) -> String {
        return mediumDateFormatter.string(from: date)
    }
    
    static func formatLong(_ date: Date) -> String {
        return longDateFormatter.string(from: date)
    }
    
    static func formatTime(_ date: Date) -> String {
        return timeFormatter.string(from: date)
    }
    
    static func formatWithTime(_ date: Date, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: date)
    }
    
    static func formatCustom(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func parseISO8601(_ dateString: String) -> Date? {
        return iso8601Formatter.date(from: dateString)
    }
    
    static func formatISO8601(_ date: Date) -> String {
        return iso8601Formatter.string(from: date)
    }
    
    static func formatRelative(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today at \(formatTime(date))"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday at \(formatTime(date))"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow at \(formatTime(date))"
        } else {
            return formatMedium(date)
        }
    }
}

