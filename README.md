# Semantic Versioning
[![Twitter: @ajax64](https://img.shields.io/badge/Author-Alexander%20Ney-00B893.svg)](https://twitter.com/ajax64)
![Platform](https://img.shields.io/cocoapods/v/SemanticVersioning.svg)
![Platform](https://img.shields.io/cocoapods/p/SemanticVersioning.svg)
![License](https://img.shields.io/cocoapods/l/SemanticVersioning.svg)
![Actions Status](https://github.com/AlexanderNey/SemanticVersioning/workflows/Build%20and%20Test/badge.svg)
[![Swift Version](https://img.shields.io/badge/Swift-5.2-F16D39.svg?style=flat)](https://developer.apple.com/swift)

Semantic Versioning implementation in Swift!
Use the struct `Version` to represent a version according to the [Semantic Versioning Specification 2.0.0](http://semver.org/spec/v2.0.0.html).


✅ Fully Unit tested

✅ 100% Swift


## Getting Started

### Requirements

- iOS 11.0+ / Mac OS X 10.13+
- Xcode 11+
- Swift 5.0

### Installation
The easiest way to use SemanticVersion in your project is using the CocaPods package manager.


### Swift PM
See [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) on how to use this library with Swift PM.

### CocoaPods
See installation instructions for [CocoaPods](http://cocoapods.org) if not already installed

To integrate the library into your Xcode project specify the pod dependency to your `Podfile`:

```ruby
platform :ios, '11.0'
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
print(version)
// OR
let stringRepresentation = version.description
```

mutability / immutability


### Comparison

The default operators for comparison are implemented
`<` , `<=` , `>` ,`>=` ,`==` , `!=`
This will compare major, minor, patch and the prerelease identifiers according to the [Semantic Versioning Specification 2.0.0](http://semver.org/spec/v2.0.0.html)


## Parser

The implementation includes a full-fledged component of parse String representation of a version. Please have a look at the tests and the source of `SemanticVersioningParser` for now 😉

## Tests

The library includes a suite of tests showing how to use the different initialiser and the Parser

## Extensions

There are some build in extensions to make your live easier.


### NSBundle

You can get the version as struct `Version` of a NSBundle if set in the bunlde info.plist like:

```Swift
let bundle = NSBundle(forClass: self.dynamicType)
if let version = bundle.version
{
	// ...
}
```

### IntegerLiteralConvertible

Converts an Integer to a `Version` struct. You can use this only to represent major versions.


## Custom extensions

Create your own extensions or Version representations by creating struct / object that conforms to `SemanticVersion`. Have a look at the extensions or the `Version` implementation for more information.
