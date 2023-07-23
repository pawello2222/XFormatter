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

import Appliable
import Foundation
import PhantomKit

/// A formatter that converts between numeric values and their textual representations.
public class XFormatter: ObjectAppliable {
    // MARK: Public Properties

    public var usesGroupingSeparator = false {
        didSet {
            formatter.usesGroupingSeparator = usesGroupingSeparator
        }
    }

    public var defaultPrecision: Precision = .default
    public var maximumAllowedFractionDigits = 16
    public var usesSignForZero = false
    public var invalidValueString = "--"

    // MARK: Internal Properties

    internal var decimalSeparator: String {
        formatter.decimalSeparator
    }

    lazy var formatter = NumberFormatter()
    lazy var dateFormatter = DateFormatter()
    lazy var dateComponentsFormatter = DateComponentsFormatter()

    // MARK: Initialization

    public init() {}
}

// MARK: - Format to Number



// MARK: - Convenience

extension XFormatter {
    public static func currency(
        locale: Locale = .current,
        currencyCode: String = Locale.current.currency?.identifier ?? "USD"
    ) -> XFormatter {
        XFormatter().apply {
            $0.formatter.numberStyle = .currency
            $0.formatter.locale = .init(identifier: "\(locale.identifier)@currency=\(currencyCode)")
            $0.defaultPrecision = .constant(2)
        }
    }

    public static func decimal(locale: Locale = .current) -> XFormatter {
        XFormatter().apply {
            $0.formatter.numberStyle = .decimal
            $0.formatter.locale = locale
        }
    }

    public static func percent(locale: Locale = .current) -> XFormatter {
        XFormatter().apply {
            $0.formatter.numberStyle = .percent
            $0.formatter.locale = locale
            $0.formatter.multiplier = 1
        }
    }
}

extension XFormatter {
    public static var currency = currency()

    public static var decimal = decimal()

    public static var percent = percent()
}
