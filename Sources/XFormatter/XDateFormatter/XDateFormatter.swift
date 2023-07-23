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

/// A formatter that converts between dates and their textual representations
/// or creates string representations of quantities of time.
public class XDateFormatter: ObjectAppliable {
    public var invalidValueString = "--"

    // MARK: Formatters

    internal lazy var dateFormatter = DateFormatter()
    internal lazy var dateComponentsFormatter = DateComponentsFormatter()

    // MARK: Initialization

    public init() {}
}

// MARK: - Defaults

extension XDateFormatter {
    public static var date = date(localizedFormat: "yyyyMMdd")

    public static var time = date(localizedFormat: "jjmmss")

    public static var datetime = date(localizedFormat: "yyyyMMddjjmmss")

    public static var dateComponents = dateComponents(
        allowedUnits: [.year, .month, .day]
    )

    public static var timeComponents = dateComponents(
        allowedUnits: [.hour, .minute, .second]
    )

    public static var datetimeComponents = dateComponents(
        allowedUnits: [.year, .month, .day, .hour, .minute, .second]
    )
}
