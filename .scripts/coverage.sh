#!/usr/bin/env bash

echo "Swift CodeCov Integration";

# Determine OS
UNAME=`uname`;
if [[ $UNAME == "Darwin" ]];
then
    OS="macOS";
else
    echo "🚫  Unsupported OS: $UNAME, skipping...";
    exit 0;
fi
echo "🖥  Operating System: $OS";

PROJ_NAME="SwiftyHaru"
SCHEME_NAME="${PROJ_NAME}"

echo "🚀  Testing: $SCHEME_NAME";

rvm install 2.2.3
gem install xcpretty
make generate-xcodeproj
WORKING_DIRECTORY=$(PWD) xcodebuild -project $PROJ_NAME.xcodeproj -scheme $SCHEME_NAME -sdk macosx10.12 -destination arch=x86_64 -configuration Debug -enableCodeCoverage YES test | xcpretty
bash <(curl -s https://codecov.io/bash)

echo "✅  Done";
