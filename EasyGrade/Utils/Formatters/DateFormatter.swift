import Foundation

class DateFormatterUtility {

    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()

    static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func formattedDateString(from isoString: String?) -> String {
        guard let isoString = isoString,
              let date = isoFormatter.date(from: isoString) else {
            return "Fecha desconocida"
        }
        return shared.string(from: date)
    }
}
