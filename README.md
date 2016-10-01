# SwiftyHaru

[![Build Status](https://travis-ci.org/WeirdMath/SwiftyHaru.svg?branch=dev)](https://travis-ci.org/WeirdMath/SwiftyHaru)
[![codecov](https://codecov.io/gh/WeirdMath/SwiftyHaru/branch/dev/graph/badge.svg)](https://codecov.io/gh/WeirdMath/SwiftyHaru)

Building in macOS:

```
swift build -Xlinker -lz
```

Testing in macOS:

```
swift test -Xlinker -lz
```

Building in Ubuntu:

```
swift build -Xlinker -rpath=.build/debug/ -Xlinker -lz
```

Testing in Ubuntu:

```
swift test -Xlinker -rpath=.build/debug/ -Xlinker -lz
```
