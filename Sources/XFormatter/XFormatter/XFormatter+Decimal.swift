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
import PhantomKitCore

// MARK: - Read

extension XFormatter {
    public func number(from string: String) -> NSNumber? {
        numberFormatter.number(from: string)
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
        guard roundedValue == .zero else {
            return with(sign: sign) {
                with(precision: precision) {
                    abbreviatedString(from: value, abbreviation: abbreviation)
                }
            }
        }
        guard usesSignForZero else {
            return with(precision: precision) {
                string(from: roundedValue)
            }
        }
        return with(zeroSign: sign.zero) {
            with(precision: precision) {
                string(from: roundedValue)
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
        numberFormatter.string(from: value) ?? invalidValueString
    }
}

// MARK: - Helpers

extension XFormatter {
    private func with<T>(abbreviationSuffix: String, _ block: () -> T) -> T {
        let existingPositiveSuffix = numberFormatter.positiveSuffix
        let existingNegativeSuffix = numberFormatter.negativeSuffix
        numberFormatter.positiveSuffix = abbreviationSuffix + numberFormatter.positiveSuffix
        numberFormatter.negativeSuffix = abbreviationSuffix + numberFormatter.negativeSuffix
        let result = block()
        numberFormatter.positiveSuffix = existingPositiveSuffix
        numberFormatter.negativeSuffix = existingNegativeSuffix
        return result
    }

    private func with<T>(precision: Precision?, _ block: () -> T) -> T {
        let existingMinimumFractionDigits = numberFormatter.minimumFractionDigits
        let existingMaximumFractionDigits = numberFormatter.maximumFractionDigits
        let precision = precision ?? defaultPrecision
        numberFormatter.minimumFractionDigits = precision.minimum ?? 0
        numberFormatter.maximumFractionDigits = precision.maximum ?? maximumAllowedFractionDigits
        let result = block()
        numberFormatter.minimumFractionDigits = existingMinimumFractionDigits
        numberFormatter.maximumFractionDigits = existingMaximumFractionDigits
        return result
    }

    private func with<T>(sign: Sign, _ block: () -> T) -> T {
        let existingPositivePrefix = numberFormatter.positivePrefix
        let existingNegativePrefix = numberFormatter.negativePrefix

        var newPlusSign: String
        switch sign.plus {
        case .none:
            newPlusSign = ""
        case .localized:
            newPlusSign = numberFormatter.plusSign
        case .custom(let plusSign):
            newPlusSign = plusSign
        }
        if numberFormatter.positivePrefix.contains(numberFormatter.plusSign) {
            numberFormatter.positivePrefix = numberFormatter.positivePrefix
                .replacingOccurrences(of: numberFormatter.plusSign, with: newPlusSign)
        } else {
            numberFormatter.positivePrefix = newPlusSign + numberFormatter.positivePrefix
        }

        var newMinusSign: String
        switch sign.minus {
        case .none:
            newMinusSign = ""
        case .localized:
            newMinusSign = numberFormatter.minusSign
        case .custom(let minusSign):
            newMinusSign = minusSign
        }
        if numberFormatter.negativePrefix.contains(numberFormatter.minusSign) {
            numberFormatter.negativePrefix = numberFormatter.negativePrefix
                .replacingOccurrences(of: numberFormatter.minusSign, with: newMinusSign)
        } else {
            numberFormatter.negativePrefix = newMinusSign + numberFormatter.negativePrefix
        }

        let result = block()

        numberFormatter.positivePrefix = existingPositivePrefix
        numberFormatter.negativePrefix = existingNegativePrefix
        return result
    }

    private func with<T>(zeroSign: Sign.Style, _ block: () -> T) -> T {
        let existingPositivePrefix = numberFormatter.positivePrefix

        var newZeroSign: String
        switch zeroSign {
        case .custom(let zeroSign):
            newZeroSign = zeroSign
        default:
            newZeroSign = ""
        }
        numberFormatter.positivePrefix = newZeroSign + numberFormatter.positivePrefix

        let result = block()

        numberFormatter.positivePrefix = existingPositivePrefix
        return result
    }
}
