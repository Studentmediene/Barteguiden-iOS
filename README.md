Barteguiden-iOS
===============

This is the iOS client for the Barteguiden project.

## Prerequisites
- Xcode 7
- CocoaPods (`[sudo] gem install cocoapods`)

## Setup
```bash
$ git clone git@github.com:Studentmediene/Barteguiden-iOS.git
$ cd Barteguiden-iOS 
$ pod install
$ open Barteguiden.xcworkspace
```

If the app does not build, replace `-framework` and `-ObjC` with
`$(inherit)` in Linking -> Other Linker Flags -> Debug.

## Contribute
Yes! Feel free. 
