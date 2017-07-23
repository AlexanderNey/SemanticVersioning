//
//  SemanticVersioningParser.swift
//
//  Copyright (c) 2015 Alexander Ney. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

private let defaultDelimeter = "."
private let prereleaseDelimeter = "-"
private let buildMetaDataDelimeter = "+"

private let numericCharacterSet = CharacterSet.decimalDigits
private let indentifierCharacterSet: CharacterSet = {
    var characterSet = NSMutableCharacterSet.alphanumeric()
    characterSet.addCharacters(in: "-")
    return characterSet as CharacterSet
}()

/**
 compares two ParseComponent
 returns true if the enumeration value incl. the associated value equals on both sides
*/
public func == (left: SemanticVersionParser.Component, right: SemanticVersionParser.Component) -> Bool {
    func compareIdentifier(_ lhs: [String]?, _ rhs: [String]?) -> Bool {
        switch (lhs, rhs) {
        case (let lhs, let rhs) where lhs != nil && rhs != nil:
            return lhs! == rhs!
        case (let lhs, let rhs) where lhs == nil && rhs == nil:
            return true
        default:
            return false
        }
    }

    switch(left, right) {
    case (.major(let majorLeft), .major(let majorRight)) where majorLeft == majorRight:
        return true
    case (.minor(let minorLeft), .minor(let minorRight)) where minorLeft == minorRight:
        return true
    case (.patch(let patchLeft), .patch(let patchRight)) where patchLeft == patchRight:
        return true
    case (.prereleaseIdentifier(let identiferLeft), .prereleaseIdentifier(let identiferRight)):
        return compareIdentifier(identiferLeft, identiferRight)
    case (.buildMetadataIdentifier(let identiferLeft), .buildMetadataIdentifier(let identiferRight)):
        return compareIdentifier(identiferLeft, identiferRight)
    default:
        return false
    }
}

/**
compares two ParseComponent
returns true if only the enumeration value equals on both sides - ignores the associated value
*/

precedencegroup ComparisonPrecedence {
  associativity: left
  higherThan: LogicalConjunctionPrecedence
}
infix operator ≈ : ComparisonPrecedence
// swiftlint:disable:next identifier_name
public func ≈ (left: SemanticVersionParser.Component, right: SemanticVersionParser.Component) -> Bool {
    switch(left, right) {
    case (.major(_), .major(_)):
        return true
    case (.minor(_), .minor(_)):
        return true
    case (.patch(_), .patch(_)):
        return true
    case (.prereleaseIdentifier(_), .prereleaseIdentifier(_)):
        return true
    case (.buildMetadataIdentifier(_), .buildMetadataIdentifier(_)):
        return true
    default:
        return false
    }
}

/**
* SemanticVersionParser parses a semantic version string and returns the parsed compoentns
*/
open class SemanticVersionParser {
    fileprivate let scanner: Scanner

    /**
    Represents the result of the string parsing
    
    - Success: Success case with an array of sucessfully parsed components
    - Failure: Failure case with the location in the original string, the failed component and the already successful parsed components
    */
    public enum Result {
        case success([Component])
        case failure(location: Int, failedComponent: Component, parsedComponents: [Component])
    }

    /**
    Represents the components of a Semantic Version
    
    - Major:                   Major version number
    - Minor:                   Minor version number
    - Patch:                   Patch number
    - PrereleaseIdentifier:    Array of prerelease identifier
    - BuildMetadataIdentifier: Array of build meta data identifer
    */
    public enum Component: CustomStringConvertible {
        case major(Int?), minor(Int?), patch(Int?), prereleaseIdentifier([String]?), buildMetadataIdentifier([String]?)
         public var description: String {

            func componentDecription<T: CustomStringConvertible>(_ component: T?) -> String {
                return (component != nil) ? component!.description : "?"
            }

            switch self {
            case .major(let major):
                return "Major(\(componentDecription(major)))"
            case .minor(let minor):
                return "Minor(\(componentDecription(minor)))"
            case .patch(let patch):
                return "Patch(\(componentDecription(patch)))"
            case .prereleaseIdentifier(let identifer):
                return "PrereleaseIdentifier(\(componentDecription(identifer)))"
            case .buildMetadataIdentifier(let identifer):
                return "BuildMetadataIdentifier(\(componentDecription(identifer)))"
            }
        }
    }

    /**
    Default initializer
    
    - parameter :versionString String representing the version
    
    - returns: valid SemanticVersionParser
    */
    public init(_ versionString: String) {
        self.scanner = Scanner(string: versionString)
    }

    /**
    starts parsing the version string
    
    - returns: Result object represeting the success of the parsing operation
    */
    open func parse() -> Result {
        self.scanner.scanLocation = 0
        var parsedComponents = [Component]()

        let majorString = scanNumeric()
        var majorValue: Int?
        let majorDelimeterScanned = scanDelimeter(defaultDelimeter)

        if let unwrapedMajorString = majorString {
            majorValue = Int(unwrapedMajorString)
        }

        if majorValue != nil {
            parsedComponents.append(.major(majorValue))
        }

        if !majorDelimeterScanned {
            return Result.failure(location: scanner.scanLocation, failedComponent: .major(nil), parsedComponents: parsedComponents)
        }

        let minorString = scanNumeric()
        var minorValue: Int?
        let minorDelimeterScanned = scanDelimeter(defaultDelimeter)

        if let unwrapedMinorString = minorString {
            minorValue = Int(unwrapedMinorString)
        }

        if minorValue != nil {
            parsedComponents.append(.minor(minorValue))
        }

        if !minorDelimeterScanned {
            return Result.failure(location: scanner.scanLocation, failedComponent: .minor(nil), parsedComponents: parsedComponents)
        }

        let patchString = scanNumeric()
        var patchValue: Int?

        if let unwrapedPatchString = patchString {
            patchValue = Int(unwrapedPatchString)
        }

        if patchValue != nil {
            parsedComponents.append(.patch(patchValue))
        } else {
            return Result.failure(location: scanner.scanLocation, failedComponent: .patch(nil), parsedComponents: parsedComponents)
        }

        if scanDelimeter(prereleaseDelimeter) {
            let prereleaseIdentifier = scanIdentifiers()
            let clearedPrereleaseIdentifier = prereleaseIdentifier.filter {$0.characters.count > 0}
            if clearedPrereleaseIdentifier.count > 0 {
                parsedComponents.append(.prereleaseIdentifier(clearedPrereleaseIdentifier))
            }

            if clearedPrereleaseIdentifier.count == 0 || clearedPrereleaseIdentifier.count != prereleaseIdentifier.count {
                return Result.failure(location: scanner.scanLocation, failedComponent: .prereleaseIdentifier(nil), parsedComponents: parsedComponents)
            }
        }

        if scanDelimeter(buildMetaDataDelimeter) {
            let BuildMetadataIdentifier = scanIdentifiers()
            let clearedBuildMetadataIdentifier = BuildMetadataIdentifier.filter {$0.characters.count > 0}
            if clearedBuildMetadataIdentifier.count > 0 {
                parsedComponents.append(.buildMetadataIdentifier(clearedBuildMetadataIdentifier))
            }

            if clearedBuildMetadataIdentifier.count == 0 || clearedBuildMetadataIdentifier.count != BuildMetadataIdentifier.count {
                return Result.failure(location: scanner.scanLocation, failedComponent: .buildMetadataIdentifier(nil), parsedComponents: parsedComponents)
            }

        }

        if scanner.isAtEnd {
            return Result.success(parsedComponents)
        } else {
            var next = Component.major(nil)
            switch parsedComponents.last {
            case .some(let component) where component ≈ .major(nil):
                next = .minor(nil)
            case .some(let component) where component ≈ .minor(nil):
                next = .patch(nil)
            case .some(let component) where component ≈ .patch(nil):
                next = .patch(nil) //.PrereleaseIdentifier(nil)
            case .some(let component) where component ≈ .prereleaseIdentifier(nil):
                next = .buildMetadataIdentifier(nil)
            case .some(let component) where component ≈ .buildMetadataIdentifier(nil):
                next = .buildMetadataIdentifier(nil)
            default:
                next = .major(nil)
            }
            print(next)
            return Result.failure(location: scanner.scanLocation, failedComponent: next, parsedComponents: parsedComponents)
        }
    }

    fileprivate func scanNumeric() -> String? {
        var string: NSString?
        self.scanner.scanCharacters(from: numericCharacterSet, into:&string)
        return string as String?
    }

    fileprivate func scanIdentifiers() -> [String] {
        var identifiers = [String]()
        repeat {
            var string: NSString?
            self.scanner.scanCharacters(from: indentifierCharacterSet, into:&string)
            if let identifier = string as String? {
                identifiers.append(identifier)
                if self.scanner.scanString(defaultDelimeter, into: nil) {
                    if self.scanner.isAtEnd { identifiers.append("") }
                    continue
                } else { break }
            } else { identifiers.append(""); break }
        } while (!self.scanner.isAtEnd)

        return identifiers
    }

    fileprivate func scanDelimeter(_ delimeter: String) -> Bool {
        var string: NSString?
        self.scanner.scanString(delimeter, into: &string)
        return (string as String?) == delimeter
    }

}

/**
*  Extension of SemanticVersion the conform to StringLiteralConvertible
*  so Versions can be initalized by assigning a String like:
*  `let version : SemanticVersion = "1.2.0"`
*/
extension Version: ExpressibleByStringLiteral {
    public init(_ versionString: String) {
        let version = Version(versionString, strict: false)
        if let version = version {
            self = version
        } else {
            self = Version(major: 0)
        }
    }

    /**
    Will try to initialize a SemanticVersion from a specified String
    
    - parameter versionString: String representing a version
    - parameter strict:   if true the initializer will fail if the version string is malformed / incomplete
                          if false a SemanticVersion will be returned even if the string was malformed / incompleted
                          this will contain the components that could be parsed and set the default for all others
                          (e.g. 0 for version numbers and nil for identifiers)
                          this is useful if you want to init with string like "1.1" which lacks the patch number or
                          even "2" wich lacks minor and patch numbers -
                          in both cases you'll get a valid SemanticVersion 1.1.0 / 2.0.0
    
    - returns: initialized SemanticVersion or nil if version string could not be parsed
    */
    public init?(_ versionString: String, strict: Bool) {
        let parser = SemanticVersionParser(versionString)
        let result = parser.parse()

        switch result {
        case .success(let components):
            self.init(parsedComponents: components)
        case .failure(_, _, let parsedComponents):
            if strict {
                return nil
            } else {
                self.init(parsedComponents: parsedComponents)
            }
        }
    }

    init(parsedComponents: [SemanticVersionParser.Component]) {
        self.init(major: 0)

        for component in parsedComponents {
            switch component {
            case .major(let major):
                self.major = major ?? 0
            case .minor(let minor):
                self.minor = minor ?? 0
            case .patch(let patch):
                self.patch = patch ?? 0
            case .prereleaseIdentifier(let identifer):
                if let prereleaseIdentifier = identifer {
                    self.preReleaseIdentifier = prereleaseIdentifier
                }
            case .buildMetadataIdentifier(let identifer):
                if let buildMetadataIdentifier = identifer {
                    self.buildMetadataIdentifier = buildMetadataIdentifier
                }
            }
        }
    }

    // MARK: StringLiteralConvertible

    public init(stringLiteral value: String) {
        self = Version(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self = Version(value)
    }

    public init(unicodeScalarLiteral value: String) {
        self = Version(value)
    }
}
