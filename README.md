# Semantic Versioning
[![Twitter: @ajax64](https://img.shields.io/badge/Author-Alexander%20Ney-00B893.svg)](https://twitter.com/ajax64)
![Platform](https://img.shields.io/cocoapods/v/SemanticVersioning.svg)
![Platform](https://img.shields.io/cocoapods/p/SemanticVersioning.svg)
![License](https://img.shields.io/cocoapods/l/SemanticVersioning.svg)
![Travis](https://img.shields.io/travis/AlexanderNey/SemanticVersioning.svg)
[![Swift Version](https://img.shields.io/badge/Swift-3.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![codecov](https://codecov.io/gh/AlexanderNey/SemanticVersioning/branch/master/graph/badge.svg)](https://codecov.io/gh/AlexanderNey/SemanticVersioning)

Semantic Versioning implementation in Swift!
Use the struct `Version` to represent a version according to the [Semantic Versioning Specification 2.0.0](http://semver.org/spec/v2.0.0.html).


✅ Fully Unit tested

✅ 100% Swift


## Getting Started

### Requirements

- iOS 8.0+ / Mac OS X 10.9+
- Xcode 10.0+
- Swift 4.2

### Installation
The easiest way to use SemanticVersion in your project is using the CocaPods package manager.


### CocoaPods
See installation instructions for [CocoaPods](http://cocoapods.org) if not already installed

To integrate the library into your Xcode project specify the pod dependency to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

pod 'SemanticVersioning'
```

run pod install

```bash
pod install
```

## Usage

Create version 2.0.0

```Swift
let version = Version(major: 2)
```

Create version 1.2.3

```Swift
let version = Version(major: 1, minor: 2, patch: 3)
```

Create version 1.0.0-alpha.2

```Swift
let version = Version(major: 1, preReleaseIdentifier: ["alpha", "2"])
```

Create version from a String

```Swift
let version: Version = "1.3.10-rc"
```

Create a list of versions from a Array of Strings

```Swift
let versions: [Version] = ["1.0.0-alpha", "1.0.0-alpha.1"]
```

Check if is prerelease version or not

```Swift
if version.isPrerelease { ... }
```

Access the prerelease identifier via the preReleaseIdentifier Array

```Swift
for identifier in version.preReleaseIdentifier
{
    // ...
}
```

Access the build metadata identifier via the buildMetadataIdentifier Array

```Swift
for identifier in version.buildMetadataIdentifier
{
    // ...
}
```

Conforms to Printable so you can simply get a String representation by accessing the description property

```Swift
println(version)
// OR
let stringRepresentation = version.description
```

mutability / immutability


### Comparsion

The default operators for comparsion are implemented
`<` , `<=` , `>` ,`>=` ,`==` , `!=`
This will comapre major, minor, patch and the prerelease identifiers according to the [Semantic Versioning Sepcification 2.0.0](http://semver.org/spec/v2.0.0.html)


## Parser

The implementation includes a full-fledged component ot parse String representation of a version. Please have a look at the tests and the soruce of `SemanticVersioningParser` for now 😉

## Tests

The libary includes a suite of tests showing how to use the different initialiser and the Parser

## Extensions

There are some build in extensions to make your live easier.

### NSOperatingSystemVersion

`NSOperatingSystemVersion` conforms to `SemanticVersion` so it can be compared with all other structs / objects that conform to the same protocol (e.g. `Version`).

So you can check the current system Version like this (on iOS 8+):
```Swift
let systemVersion = NSProcessInfo.processInfo().operatingSystemVersion
if systemVersion < Version(major: 8)
{
    // ...
}
```

### NSBundle

You can get the version as struct `Version` of a NSBundle if set in the bunlde info.plist like:

```Swift
let bundle = NSBundle(forClass: self.dynamicType)
if let version = bundle.version
{
	// ...
}
```

### UIDevice

You can get the operating system version from a `UIDevice` object by using `operatingSystemVersion` which returns a `Version` representation of `systemVersion`.

```Swift
let systemVersion = UIDevice.currentDevice().operatingSystemVersion
if systemVersion < Version(major: 8)
{
    // ...
}

```

### IntegerLiteralConvertible

Converts an Integer to a `Version` struct. You can use this only to represent major versions.

```Swift
let systemVersion = NSProcessInfo.processInfo().operatingSystemVersion
if systemVersion < 8
{
    // ...
}
```

Reducing the version's minor and major value to a `Float` is also possible. Use this with ⚠️**caution**⚠️ as the `Float` representation could lead to accuracy loss of the minor value (that is represented as fractional digits). I would not reccommend to compare with `==` but `<` , `<=` , `>` ,`>=` should be useful.

```Swift
let systemVersion = NSProcessInfo.processInfo().operatingSystemVersion
if systemVersion.floatValue() < 8.1
{
    // ...
}
```


## Custom extensions

Create your own extensions or Version representations by creating struct / object that conforms to `SemanticVersioning`. Have a look at the extensions or the `Version` implementation for more information.
