// The MIT License (MIT)
//
// Copyright (c) 2023-Present Paweł Wiszenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

// MARK: - Read

extension XFormatter {
    public func date(from string: String, timeZone: TimeZone? = nil) -> Date? {
        with(timeZone: timeZone) {
            dateFormatter.date(from: string)
        }
    }
}

// MARK: - Write

extension XFormatter {
    public func string(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
}

extension XFormatter {
    public func string(from dateComponents: DateComponents) -> String {
        dateComponentsFormatter.string(from: dateComponents) ?? invalidValueString
    }

    public func string(fromTimeInterval timeInterval: TimeInterval) -> String {
        dateComponentsFormatter.string(from: timeInterval) ?? invalidValueString
    }

    public func string(from startDate: Date, to endDate: Date) -> String {
        dateComponentsFormatter.string(from: startDate, to: endDate) ?? invalidValueString
    }
}

// MARK: - Helpers

extension XFormatter {
    private func with<T>(timeZone: TimeZone?, _ block: () -> T) -> T {
        let existingTimeZone = dateFormatter.timeZone
        dateFormatter.timeZone = timeZone
        let result = block()
        dateFormatter.timeZone = existingTimeZone
        return result
    }
}
