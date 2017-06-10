#!/usr/bin/env bash

echo "Swift 3 Continuous Integration";

# Determine OS
UNAME=`uname`;
if [[ $UNAME == "Darwin" ]];
then
    OS="macOS";
else
    if [[ $UNAME == "Linux" ]];
    then
        UBUNTU_RELEASE=`lsb_release -a 2>/dev/null`;
        if [[ $UBUNTU_RELEASE == *"15.10"* ]];
        then
            OS="Ubuntu 15.10";
        elif [[ $UBUNTU_RELEASE == *"16.04"* ]];
        then
            OS="Ubuntu 16.04";
        else
            OS="Ubuntu 14.04";
        fi
    else
        echo "Unsupported Operating System: $UNAME";
    fi
fi
echo "🖥 Operating System: $OS";

if [[ $OS != "macOS" ]];
then
    echo "📦 Installing Swiftenv"
    git clone --depth 1 https://github.com/kylef/swiftenv.git ~/.swiftenv
    export SWIFTENV_ROOT="$HOME/.swiftenv"
    export PATH="$SWIFTENV_ROOT/bin:$SWIFTENV_ROOT/shims:$PATH"

    echo "📚 Installing Dependencies"
    sudo apt-get install -y clang libicu-dev uuid-dev

    echo "🐦 Installing Swift";
    if [ -f ".swift-version" ] || [ -n "$SWIFT_VERSION" ]; 
    then
        swiftenv install;
    else
        echo "No SWIFT_VERSION environment variable or .swift-version file found."
        exit 1
    fi
fi

echo "📅 Version: `swift --version`";

echo "🚀 Building";

if [[ $OS == "macOS" ]];
then
    make debug;
else
    make debug;
fi

if [[ $? != 0 ]]; 
then 
    echo "❌  Build failed";
    exit 1; 
fi

echo "💼 Building Release";

if [[ $OS == "macOS" ]];
then
    make release;
else
    make release;
fi

if [[ $? != 0 ]]; 
then 
    echo "❌  Build for release failed";
    exit 1; 
fi

echo "🔎 Testing";

if [[ $OS == "macOS" ]];
then
    make test
else
    make test
fi

if [[ $? != 0 ]];
then 
    echo "❌ Tests failed";
    exit 1; 
fi

echo "✅ Done";
