TARGET = SwiftyHaru

SWIFT_FLAGS += -Xlinker -lz

SWIFT_BUILD = $(SWIFT_EXECUTABLE) build
SWIFT_TEST = $(SWIFT_EXECUTABLE) test
SWIFT_PACKAGE = $(SWIFT_EXECUTABLE) package

debug:
	swift build $(SWIFT_FLAGS) -c debug

release:
	swift build $(SWIFT_FLAGS) -c release

test:
	swift test $(SWIFT_FLAGS) --parallel

generate-xcodeproj:
	swift package $(SWIFT_FLAGS) generate-xcodeproj --enable-code-coverage

docs: generate-xcodeproj
	jazzy -o docs/ \
      --source-directory ./ \
      --readme README.md \
      -a 'Sergej Jaskiewicz' \
      -u 'https://twitter.com/broadway_lamb' \
      -m 'SwiftyHaru' \
      -g 'https://github.com/WeirdMath/SwiftyHaru' \
      -x '-scheme,SwiftyHaru-Package' \

clean:
	swift package clean

.PHONY: debug release test generate-xcodeproj clean