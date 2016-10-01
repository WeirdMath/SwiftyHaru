# SwiftyHaru

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
