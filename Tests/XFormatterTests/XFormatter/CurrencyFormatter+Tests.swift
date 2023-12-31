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

import XCTest
@testable import XFormatter

class CurrencyFormatterTests: XCTestCase {
    private let usFormatter = XFormatter.currency(
        locale: .init(identifier: "en_US"),
        currencyCode: "USD"
    )

    func test_shouldFormatAmounts() throws {
        XCTAssertEqual(usFormatter.string(from: 1), "$1.00")
        XCTAssertEqual(usFormatter.string(from: 432), "$432.00")
        XCTAssertEqual(usFormatter.string(from: 1000), "$1,000.00")
        XCTAssertEqual(usFormatter.string(from: 48_729_432), "$48,729,432.00")
    }

    func test_shouldFormatNegativeAmounts() throws {
        XCTAssertEqual(usFormatter.string(from: -1), "-$1.00")
        XCTAssertEqual(usFormatter.string(from: -432), "-$432.00")
        XCTAssertEqual(usFormatter.string(from: -1000), "-$1,000.00")
        XCTAssertEqual(usFormatter.string(from: -48_729_432), "-$48,729,432.00")
    }

    func test_withLocalePLPL_shouldFormatAmountsToPLN() throws {
        let plFormatter = XFormatter.currency(
            locale: .init(identifier: "pl_PL"),
            currencyCode: "PLN"
        )

        XCTAssertEqual(plFormatter.string(from: 1), "1,00 zł")
        XCTAssertEqual(plFormatter.string(from: 432), "432,00 zł")
        XCTAssertEqual(plFormatter.string(from: 1000), "1000,00 zł")
        XCTAssertEqual(plFormatter.string(from: 48_729_432), "48 729 432,00 zł")
    }

    func test_withLocaleENPL_shouldFormatAmountsToPLN() throws {
        let plFormatter = XFormatter.currency(
            locale: .init(identifier: "en_PL"),
            currencyCode: "PLN"
        )

        XCTAssertEqual(plFormatter.string(from: 1), "1,00 PLN")
        XCTAssertEqual(plFormatter.string(from: 432), "432,00 PLN")
        XCTAssertEqual(plFormatter.string(from: 1000), "1 000,00 PLN")
        XCTAssertEqual(plFormatter.string(from: 48_729_432), "48 729 432,00 PLN")
    }

    func test_withLocalePLPL_shouldFormatNegativeAmountsToPLN() throws {
        let plFormatter = XFormatter.currency(
            locale: .init(identifier: "pl_PL"),
            currencyCode: "PLN"
        )

        XCTAssertEqual(plFormatter.string(from: -1), "-1,00 zł")
        XCTAssertEqual(plFormatter.string(from: -432), "-432,00 zł")
        XCTAssertEqual(plFormatter.string(from: -1000), "-1000,00 zł")
        XCTAssertEqual(plFormatter.string(from: -48_729_432), "-48 729 432,00 zł")
    }

    func test_withCurrencyCodePLN_shouldFormatNegativeAmountsToPLN() throws {
        let plFormatter = XFormatter.currency(
            locale: .init(identifier: "en_US"),
            currencyCode: "PLN"
        )

        XCTAssertEqual(plFormatter.string(from: -1), "-PLN1.00")
        XCTAssertEqual(plFormatter.string(from: -432), "-PLN432.00")
        XCTAssertEqual(plFormatter.string(from: -1000), "-PLN1,000.00")
        XCTAssertEqual(plFormatter.string(from: -48_729_432), "-PLN48,729,432.00")
    }

    func test_withAbbreviation_shouldFormatAmounts() throws {
        XCTAssertEqual(usFormatter.string(from: 326.09734, abbreviation: .default), "$326.10")
        XCTAssertEqual(usFormatter.string(from: 1432.99, abbreviation: .default), "$1.43k")
        XCTAssertEqual(usFormatter.string(from: 100_081, abbreviation: .default), "$100.08k")
        XCTAssertEqual(usFormatter.string(from: 48_729_432, abbreviation: .default), "$48.73m")
        XCTAssertEqual(usFormatter.string(from: -42.8111, abbreviation: .default), "-$42.81")
        XCTAssertEqual(usFormatter.string(from: -4239.8111, abbreviation: .default), "-$4.24k")
    }

    func test_withLocalizedSign_shouldFormatAmounts() throws {
        XCTAssertEqual(usFormatter.string(from: 123.456, sign: .none), "$123.46")
        XCTAssertEqual(usFormatter.string(from: 123.456, sign: .default), "$123.46")
        XCTAssertEqual(usFormatter.string(from: 123.456, sign: .both), "+$123.46")
        XCTAssertEqual(usFormatter.string(from: -123.456, sign: .none), "$123.46")
        XCTAssertEqual(usFormatter.string(from: -123.456, sign: .default), "-$123.46")
        XCTAssertEqual(usFormatter.string(from: -123.456, sign: .both), "-$123.46")
    }

    func test_withCustomSign_shouldFormatAmounts() throws {
        let plus: XFormatter.Sign.Style = .custom("▲")
        let minus: XFormatter.Sign.Style = .custom("▼")

        let plusOnly: XFormatter.Sign = .init(plus: plus, minus: .none)
        let minusOnly: XFormatter.Sign = .init(plus: .none, minus: minus)
        let both: XFormatter.Sign = .init(plus: plus, minus: minus)

        XCTAssertEqual(usFormatter.string(from: 123.456, sign: plusOnly), "▲$123.46")
        XCTAssertEqual(usFormatter.string(from: -123.456, sign: plusOnly), "$123.46")
        XCTAssertEqual(usFormatter.string(from: 123.456, sign: minusOnly), "$123.46")
        XCTAssertEqual(usFormatter.string(from: -123.456, sign: minusOnly), "▼$123.46")
        XCTAssertEqual(usFormatter.string(from: 123.456, sign: both), "▲$123.46")
        XCTAssertEqual(usFormatter.string(from: -123.456, sign: both), "▼$123.46")
    }
}
