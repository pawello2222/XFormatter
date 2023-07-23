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

// MARK: - Currency

extension XFormatter {
    public static func currency(
        locale: Locale = .current,
        currencyCode: String = Locale.current.currency?.identifier ?? "USD"
    ) -> XFormatter {
        .init().apply {
            $0.numberFormatter.numberStyle = .currency
            $0.numberFormatter.locale = .init(identifier: "\(locale.identifier)@currency=\(currencyCode)")
            $0.defaultPrecision = .constant(2)
        }
    }
}

// MARK: - Decimal

extension XFormatter {
    public static func decimal(locale: Locale = .current) -> XFormatter {
        .init().apply {
            $0.numberFormatter.numberStyle = .decimal
            $0.numberFormatter.locale = locale
        }
    }
}

// MARK: - Percent

extension XFormatter {
    public static func percent(locale: Locale = .current) -> XFormatter {
        .init().apply {
            $0.numberFormatter.numberStyle = .percent
            $0.numberFormatter.locale = locale
            $0.numberFormatter.multiplier = 1
        }
    }
}
