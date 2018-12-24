# SwiftyHaru

[![Build Status](https://travis-ci.org/WeirdMath/SwiftyHaru.svg?branch=dev)](https://travis-ci.org/WeirdMath/SwiftyHaru)
[![codecov](https://codecov.io/gh/WeirdMath/SwiftyHaru/branch/dev/graph/badge.svg)](https://codecov.io/gh/WeirdMath/SwiftyHaru)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/66cfcbcec9884191a0f8aa1bef26deb8)](https://www.codacy.com/app/broadway_lamb/SwiftyHaru?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=WeirdMath/SwiftyHaru&amp;utm_campaign=Badge_Grade)
![Language](https://img.shields.io/badge/Swift-4.2-orange.svg)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS-lightgrey.svg)
![Cocoapods](https://img.shields.io/cocoapods/v/SwiftyHaru.svg?style=flat)

SwiftyHaru is an object-oriented Swift wrapper for [LibHaru](https://github.com/libharu/libharu), a C library for creating PDF documents. It brings the safety of Swift itself to the process of creating PDFs on different platforms like Linux, macOS, iOS, watchOS and tvOS.

Check out which [features of LibHaru](https://github.com/libharu/libharu/wiki) has already been implemented in [FEATURES.md](FEATURES.md)

## Requirements

* Swift 4.2+
* iOS 8.0+
* macOS 10.10+
* tvOS 9.0+
* watchOS 2.0+
* Ubuntu 14.04+

## Installation

#### CocoaPods

For the latest release in CocoaPods add the following to your `Podfile`:

```ruby
use_frameworks!

pod 'SwiftyHaru'
```

For the latest dev build:

```ruby
use_frameworks!

pod 'SwiftyHaru', :git => 'https://github.com/WeirdMath/SwiftyHaru.git', :branch => 'dev'
```

### Swift Package Manager
Add SwiftyHaru as a dependency to your `Package.swift`. For example:

```swift
let package = Package(
    name: "YourPackageName",
    dependencies: [
        .package(url: "https://github.com/WeirdMath/SwiftyHaru.git", from: "0.3.0")
    ]
)
```

**Important:** when building your project that has SwiftyHaru as a dependency, 
you need to pass the `-Xlinker -lz` flags to the compiler. This is because SwiftyHaru has to be linked with zlib (which must be intalled on your computer). For example:

```
$ swift build -Xlinker -lz
$ swift test -Xlinker -lz
```

## Documentation

Available [here](https://weirdmath.github.io/SwiftyHaru/).

## Getting started

```swift
import SwiftyHaru

// Initialize stuff
let document = PDFDocument()
let page = document.addPage(width: 600, height: 400) { context in

    // Construct a path
    let path = Path()
        .moving(toX: 100, y: 100)
        .appendingLine(toX: 400, y: 100)
        .moving(toX: 500, y: 200)
        .appendingArc(x: 400, y: 200, radius: 100, beginningAngle: 90, endAngle: 180)
        .appendingCircle(x: 200, y: 200, radius: 50)
        .moving(toX: 500, y: 200)
        .appendingCurve(controlPoint1: Point(x: 400, y: 200),
                        controlPoint2: Point(x: 400, y: 300),
                        endPoint: Point(x: 500, y: 300))
        .closingSubpath()

    // Paint the path
    context.strokeColor = .blue
    context.stroke(path)

    // Put some text
    context.textLeading = 11
    context.show(text: "Roses are red,\nViolets are blue,\nSugar is sweet,\nAnd so are you.",
                 atX: 300, y: 200)
}
```

## Contributing

### Building:

```
$ make debug
```
Or:

```
$ make release
```

### Testing:

```
$ make test
```

### Generating Xcode project
Since the Xcode project is explicitly `gitignore`d, you might want to generate it in order to make development comfortable for you. This can be accomplished by running the following command:

```
make generate-xcodeproj
```

