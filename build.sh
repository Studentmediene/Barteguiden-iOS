#!/bin/sh

# Halt on any errors
set -e

# Clean and build project
xcodebuild -workspace default.xcworkspace -scheme Kulturkalender -configuration Release -sdk iphonesimulator clean build
