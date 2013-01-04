#!/bin/sh

# Halt on any errors
set -e

# Run tests
xcodebuild -workspace default.xcworkspace -scheme KulturkalenderTests -configuration Release -sdk iphonesimulator
