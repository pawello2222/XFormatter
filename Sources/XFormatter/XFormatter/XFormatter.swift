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

/// A formatter that converts between numeric values and their textual representations.
public class XFormatter: ObjectAppliable {
    public var usesGroupingSeparator = false {
        didSet {
            numberFormatter.usesGroupingSeparator = usesGroupingSeparator
        }
    }

    public var defaultPrecision: Precision = .default
    public var maximumAllowedFractionDigits = 16
    public var usesSignForZero = false
    public var invalidValueString = "--"

    // MARK: Formatters

    internal lazy var numberFormatter = NumberFormatter()

    // MARK: Initialization

    public init() {}
}

// MARK: - Defaults

extension XFormatter {
    public static var currency = currency()

    public static var decimal = decimal()

    public static var percent = percent()
}
