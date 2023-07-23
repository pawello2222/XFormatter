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
import PhantomKit

// MARK: - Read

extension XFormatter {
    public func number(from string: String) -> NSNumber? {
        formatter.number(from: string)
    }

    public func decimal(from string: String) -> NSDecimalNumber? {
        guard let number = number(from: string) else {
            return nil
        }
        return .init(decimal: number.decimalValue)
    }
}

// MARK: - Write

extension XFormatter {
    public func string(
        from value: Int,
        abbreviation: Abbreviation = .none,
        sign: Sign = .default,
        precision: Precision? = nil
    ) -> String {
        string(
            from: NSDecimalNumber(value: value),
            abbreviation: abbreviation,
            sign: sign,
            precision: precision
        )
    }

    public func string(
        from value: Float,
        abbreviation: Abbreviation = .none,
        sign: Sign = .default,
        precision: Precision? = nil
    ) -> String {
        string(
            from: NSDecimalNumber(value: value),
            abbreviation: abbreviation,
            sign: sign,
            precision: precision
        )
    }

    public func string(
        from value: Double,
        abbreviation: Abbreviation = .none,
        sign: Sign = .default,
        precision: Precision? = nil
    ) -> String {
        string(
            from: NSDecimalNumber(value: value),
            abbreviation: abbreviation,
            sign: sign,
            precision: precision
        )
    }

    public func string(
        from value: Decimal,
        abbreviation: Abbreviation = .none,
        sign: Sign = .default,
        precision: Precision? = nil
    ) -> String {
        string(
            from: NSDecimalNumber(decimal: value),
            abbreviation: abbreviation,
            sign: sign,
            precision: precision
        )
    }

    public func string(
        from value: NSDecimalNumber,
        abbreviation: Abbreviation = .none,
        sign: Sign = .default,
        precision: Precision? = nil
    ) -> String {
        var roundedValue: NSDecimalNumber
        if let places = precision?.maximum ?? defaultPrecision.maximum {
            roundedValue = value.rounded(toPlaces: places)
        } else {
            roundedValue = value
        }
        guard roundedValue != .zero else {
            if usesSignForZero {
                return with(zeroSign: sign.zero) {
                    with(precision: precision) {
                        string(from: roundedValue)
                    }
                }
            } else {
                return with(precision: precision) {
                    string(from: roundedValue)
                }
            }
        }
        return with(sign: sign) {
            with(precision: precision) {
                abbreviatedString(from: value, abbreviation: abbreviation)
            }
        }
    }

    private func abbreviatedString(
        from value: NSDecimalNumber,
        abbreviation: Abbreviation
    ) -> String {
        for threshold in abbreviation.thresholds where value.absValue >= threshold.value {
            return with(abbreviationSuffix: threshold.suffix) {
                string(from: value / threshold.value)
            }
        }
        return string(from: value)
    }

    private func string(from value: NSDecimalNumber) -> String {
        formatter.string(from: value) ?? invalidValueString
    }
}

// MARK: - Helpers

extension XFormatter {
    private func with<T>(abbreviationSuffix: String, _ block: () -> T) -> T {
        let existingPositiveSuffix = formatter.positiveSuffix
        let existingNegativeSuffix = formatter.negativeSuffix
        formatter.positiveSuffix = abbreviationSuffix + formatter.positiveSuffix
        formatter.negativeSuffix = abbreviationSuffix + formatter.negativeSuffix
        let result = block()
        formatter.positiveSuffix = existingPositiveSuffix
        formatter.negativeSuffix = existingNegativeSuffix
        return result
    }

    private func with<T>(precision: Precision?, _ block: () -> T) -> T {
        let existingMinimumFractionDigits = formatter.minimumFractionDigits
        let existingMaximumFractionDigits = formatter.maximumFractionDigits
        let precision = precision ?? defaultPrecision
        formatter.minimumFractionDigits = precision.minimum ?? 0
        formatter.maximumFractionDigits = precision.maximum ?? maximumAllowedFractionDigits
        let result = block()
        formatter.minimumFractionDigits = existingMinimumFractionDigits
        formatter.maximumFractionDigits = existingMaximumFractionDigits
        return result
    }

    private func with<T>(sign: Sign, _ block: () -> T) -> T {
        let existingPositivePrefix = formatter.positivePrefix
        let existingNegativePrefix = formatter.negativePrefix

        var newPlusSign: String
        switch sign.plus {
        case .none:
            newPlusSign = ""
        case .localized:
            newPlusSign = formatter.plusSign
        case .custom(let plusSign):
            newPlusSign = plusSign
        }
        if formatter.positivePrefix.contains(formatter.plusSign) {
            formatter.positivePrefix = formatter.positivePrefix
                .replacingOccurrences(of: formatter.plusSign, with: newPlusSign)
        } else {
            formatter.positivePrefix = newPlusSign + formatter.positivePrefix
        }

        var newMinusSign: String
        switch sign.minus {
        case .none:
            newMinusSign = ""
        case .localized:
            newMinusSign = formatter.minusSign
        case .custom(let minusSign):
            newMinusSign = minusSign
        }
        if formatter.negativePrefix.contains(formatter.minusSign) {
            formatter.negativePrefix = formatter.negativePrefix
                .replacingOccurrences(of: formatter.minusSign, with: newMinusSign)
        } else {
            formatter.negativePrefix = newMinusSign + formatter.negativePrefix
        }

        let result = block()

        formatter.positivePrefix = existingPositivePrefix
        formatter.negativePrefix = existingNegativePrefix
        return result
    }

    private func with<T>(zeroSign: Sign.Style, _ block: () -> T) -> T {
        let existingPositivePrefix = formatter.positivePrefix

        var newZeroSign: String
        switch zeroSign {
        case .custom(let zeroSign):
            newZeroSign = zeroSign
        default:
            newZeroSign = ""
        }
        formatter.positivePrefix = newZeroSign + formatter.positivePrefix

        let result = block()

        formatter.positivePrefix = existingPositivePrefix
        return result
    }
}
