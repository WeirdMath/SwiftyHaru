# SwiftyHaru

[![Build Status](https://travis-ci.org/WeirdMath/SwiftyHaru.svg?branch=dev)](https://travis-ci.org/WeirdMath/SwiftyHaru)
[![codecov](https://codecov.io/gh/WeirdMath/SwiftyHaru/branch/dev/graph/badge.svg)](https://codecov.io/gh/WeirdMath/SwiftyHaru)
![Language](https://img.shields.io/badge/Swift-3.0-orange.svg)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS-lightgrey.svg)

SwiftyHaru is an object-oriented Swift wrapper for [LibHaru](https://github.com/libharu/libharu), a C library for creating PDF documents. It brings the safety of Swift itself to the process of creating PDFs on different platforms like Linux, macOS, iOS, watchOS and tvOS.

Check out which [features of LibHaru](https://github.com/libharu/libharu/wiki) has already been implemented in [FEATURES.md](FEATURES.md)

## Installation

Add SwiftyHaru as a dependency to your `Package.swift`. For example:

```swift
let package = Package(
    name: "YourPackageName",
    dependencies: [
        .Package(url: "https://github.com/WeirdMath/SwiftyHaru.git", majorVersion: 1)
    ]
)	
```

## Contributing

Building in macOS:

```
$ swift build -Xlinker -lz
```

Testing in macOS:

```
$ swift test -Xlinker -lz
```

Building in Ubuntu:

```
$ swift build -Xlinker -rpath=.build/debug/ -Xlinker -lz
```

Testing in Ubuntu:

```
$ swift test -Xlinker -rpath=.build/debug/ -Xlinker -lz
```
