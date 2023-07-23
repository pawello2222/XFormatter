<p align="center">
  <img src=".resources/Assets/logo.png" alt="XFormatter logo" height=150>
</p>
<p align="center">
  <a href="https://github.com/pawello2222/XFormatter/actions?query=branch%3Amain">
    <img src="https://img.shields.io/github/actions/workflow/status/pawello2222/XFormatter/ci.yml?logo=github" alt="Build">
  </a>
  <a href="https://codecov.io/gh/pawello2222/XFormatter">
    <img src="https://codecov.io/gh/pawello2222/XFormatter/branch/main/graph/badge.svg?token=EYQ7VExCll" alt="Code coverage">
  </a>
  <a href="https://github.com/pawello2222/XFormatter">
    <img src="https://img.shields.io/badge/language-swift-orange.svg" alt="Language">
  </a>
  <a href="https://github.com/pawello2222/XFormatter#installation">
    <img src="https://img.shields.io/badge/SPM-compatible-brightgreen.svg" alt="Swift Package Manager">
  </a>
  <a href="https://github.com/pawello2222/XFormatter/releases">
    <img src="https://img.shields.io/github/v/release/pawello2222/XFormatter" alt="Release version">
  </a>
  <a href="https://github.com/pawello2222/XFormatter/blob/main/LICENSE.md">
    <img src="https://img.shields.io/github/license/pawello2222/XFormatter" alt="License">
  </a>
</p>

# XFormatter

XFormatter (eXtended Formatter) provides localized strings from numbers, currencies, dates and more.

<details>
  <summary>
    <b>Table of Contents</b>
  </summary>

  1. [Installation](#installation)
  2. [Highlights](#highlights)
  3. [License](#license)

</details>

## Installation <a name="installation"></a>

### Requirements
* iOS 16.0+
* macOS 13.0+

### Swift Package Manager

XFormatter is available as a Swift Package.

```swift
.package(url: "https://github.com/pawello2222/XFormatter.git", .upToNextMajor(from: "1.0.0"))
```

## Highlights <a name="highlights"></a>

### Currency

```swift
let formatter = XFormatter.currency(
    locale: .init(identifier: "en_US"),
    currencyCode: "USD"
)

XCTAssertEqual(formatter.string(from: 326.097, abbreviation: .default), "$326.10")
XCTAssertEqual(formatter.string(from: 1432.99, abbreviation: .default), "$1.43k")
XCTAssertEqual(formatter.string(from: 100_081, abbreviation: .default), "$100.08k")
XCTAssertEqual(formatter.string(from: 4_729_432, abbreviation: .default), "$4.73m")
XCTAssertEqual(formatter.string(from: -42.811, abbreviation: .default), "-$42.81")
XCTAssertEqual(formatter.string(from: -4239.81, abbreviation: .default), "-$4.24k")
XCTAssertEqual(formatter.string(from: 123.456, sign: .arrow), "▲$123.46")
```

### Decimal

```swift
let formatter = XFormatter.decimal(
    locale: .init(identifier: "en_US")
)

XCTAssertEqual(formatter.string(from: -1000), "-1,000")
XCTAssertEqual(formatter.string(from: 1000, abbreviation: .default), "1k")
XCTAssertEqual(formatter.string(from: 1000, abbreviation: .capitalized), "1K")
XCTAssertEqual(formatter.string(from: 123.456, sign: .both), "+123.46")
XCTAssertEqual(formatter.string(from: -123.456, sign: .spacedArrow), "▼ 123.46")
XCTAssertEqual(formatter.string(from: 0.123456789, precision: .default), "0.12")
XCTAssertEqual(formatter.string(from: 0.12, precision: .init(3...)), "0.120")
```

### Date

```swift
let formatter = XDateFormatter.date(
    locale: .init(identifier: "pl_PL"),
    localizedFormat: "yyyyMMddjjmmss"
)

let date = Date(year: 2000, month: 3, day: 24, hour: 16, minute: 14, second: 44)

XCTAssertEqual(formatter.string(from: date), "24.03.2000, 16:14:44")
```

### Date components

```swift
let formatter = XDateFormatter.dateComponents(
    locale: .init(identifier: "en_US")
)

let now = Date()
let future = now.adjusting(.day, by: 2)

XCTAssertEqual(formatter.string(from: now, to: future), "48 hours")
```

```swift
let formatter = XDateFormatter.dateComponents(
    locale: .init(identifier: "en_US")
)

let date = Date(year: 2000, month: 3, day: 24, hour: 16, minute: 14, second: 44)
let components = date.components([.hour, .minute])

XCTAssertEqual(formatter.string(from: components), "16 hours, 14 minutes")
```

## License <a name="license"></a>

PhantomKit is available under the MIT license. See the [LICENSE](./LICENSE.md) file for more info.
