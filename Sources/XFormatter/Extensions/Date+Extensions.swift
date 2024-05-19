import Foundation

extension Date {
    public func localizedString(formatter: XDateFormatter = .date) -> String {
        formatter.string(from: self)
    }
}
