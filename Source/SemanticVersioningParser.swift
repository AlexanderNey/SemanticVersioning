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


private let DefaultDelimeter = "."
private let PrereleaseDelimeter = "-"
private let BuildMetaDataDelimeter = "+"

private let NumericCharacterSet = NSCharacterSet.decimalDigitCharacterSet()
private let IndentifierCharacterSet: NSCharacterSet = {
    var characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
    characterSet.addCharactersInString("-")
    return characterSet
}()


/**
 compares two ParseComponent
 returns true if the enumeration value incl. the associated value equals on both sides
*/
public func == (left: SemanticVersionParser.Component, right: SemanticVersionParser.Component) -> Bool
{
    func compareIdentifier(a: [String]?, b: [String]?) -> Bool
    {
        switch (a, b)
        {
        case (let a, let b) where a != nil && b != nil:
            return a! == b!
        case (let a, let b) where a == nil && b == nil:
            return true
        default:
            return false
        }
    }
        
    switch(left, right)
    {
    case (.Major(let majorLeft), .Major(let majorRight)) where majorLeft == majorRight:
        return true
    case (.Minor(let minorLeft), .Minor(let minorRight)) where minorLeft == minorRight:
        return true
    case (.Patch(let patchLeft), .Patch(let patchRight)) where patchLeft == patchRight:
        return true
    case (.PrereleaseIdentifier(let identiferLeft), .PrereleaseIdentifier(let identiferRight)):
        return compareIdentifier(identiferLeft, identiferRight)
    case (.BuildMetadataIdentifier(let identiferLeft), .BuildMetadataIdentifier(let identiferRight)):
        return compareIdentifier(identiferLeft, identiferRight)
    default:
        return false
    }
}

/**
compares two ParseComponent
returns true if only the enumeration value equals on both sides - ignores the associated value
*/
infix operator ≈ { associativity left precedence 140 }
public func ≈ (left: SemanticVersionParser.Component, right: SemanticVersionParser.Component) -> Bool
{
    switch(left, right)
    {
    case (.Major(_), .Major(_)):
        return true
    case (.Minor(_), .Minor(_)):
        return true
    case (.Patch(_), .Patch(_)):
        return true
    case (.PrereleaseIdentifier(_), .PrereleaseIdentifier(_)):
        return true
    case (.BuildMetadataIdentifier(_), .BuildMetadataIdentifier(_)):
        return true
    default:
        return false
    }
}

/**
* SemanticVersionParser parses a semantic version string and returns the parsed compoentns
*/
public class SemanticVersionParser
{
    private let scanner: NSScanner
    
    /**
    Represents the result of the string parsing
    
    - Success: Success case with an array of sucessfully parsed components
    - Failure: Failure case with the location in the original string, the failed component and the already successful parsed components
    */
    public enum Result {
        case Success([Component])
        case Failure(location: Int, failedComponent: Component, parsedComponents: [Component])
    }
    
    /**
    Represents the components of a Semantic Version
    
    - Major:                   Major version number
    - Minor:                   Minor version number
    - Patch:                   Patch number
    - PrereleaseIdentifier:    Array of prerelease identifier
    - BuildMetadataIdentifier: Array of build meta data identifer
    */
    public enum Component: Printable {
        case Major(Int?), Minor(Int?), Patch(Int?), PrereleaseIdentifier([String]?), BuildMetadataIdentifier([String]?)
         public var description : String {
            switch self {
            case .Major(let major): return "Major(\(major))"
            case .Minor(let minor): return "Minor(\(minor))"
            case .Patch(let patch): return "Patch(\(patch))"
            case .PrereleaseIdentifier(let identifer):  return "PrereleaseIdentifier(\(identifer))"
            case .BuildMetadataIdentifier(let identifer):  return "BuildMetadataIdentifier(\(identifer))"
            }
        }
    }
    
    /**
    Default initializer
    
    :param: versionString String representing the version
    
    :returns: valid SemanticVersionParser
    */
    public init(_ versionString: String)
    {
        self.scanner = NSScanner(string: versionString)
    }
    
    /**
    starts parsing the version string
    
    :returns: Result object represeting the success of the parsing operation
    */
    public func parse() -> Result
    {
        self.scanner.scanLocation = 0
        var parsedComponents = [Component]()
       
        var majorString = scanNumeric()
        var majorValue = majorString?.toInt()
        var majorDelimeterScanned = scanDelimeter(DefaultDelimeter)
        
        if majorValue != nil
        {
            parsedComponents.append(.Major(majorValue))
        }
            
        if !majorDelimeterScanned
        {
            return Result.Failure(location: scanner.scanLocation, failedComponent: .Major(nil), parsedComponents: parsedComponents)
        }
        
        var minorString = scanNumeric()
        var minorValue = minorString?.toInt()
        var minorDelimeterScanned = scanDelimeter(DefaultDelimeter)
        
        if minorValue != nil
        {
            parsedComponents.append(.Minor(minorValue))
        }
        
        if !minorDelimeterScanned
        {
            return Result.Failure(location: scanner.scanLocation, failedComponent: .Minor(nil), parsedComponents: parsedComponents)
        }
        
        var patchString = scanNumeric()
        var patchValue = patchString?.toInt()
        if patchValue != nil
        {
            parsedComponents.append(.Patch(patchValue))
        }
        else
        {
            return Result.Failure(location: scanner.scanLocation, failedComponent: .Patch(nil), parsedComponents: parsedComponents)
        }

        if scanDelimeter(PrereleaseDelimeter)
        {
            var prereleaseIdentifier = scanIdentifiers()
            var clearedPrereleaseIdentifier = prereleaseIdentifier.filter {count($0) > 0}
            if count(clearedPrereleaseIdentifier) > 0
            {
                parsedComponents.append(.PrereleaseIdentifier(clearedPrereleaseIdentifier))
            }
                
            if count(clearedPrereleaseIdentifier) == 0 || count(clearedPrereleaseIdentifier) != count(prereleaseIdentifier)
            {
                return Result.Failure(location: scanner.scanLocation, failedComponent: .PrereleaseIdentifier(nil), parsedComponents: parsedComponents)
            }
        }
        
        if scanDelimeter(BuildMetaDataDelimeter)
        {
            var BuildMetadataIdentifier = scanIdentifiers()
            var clearedBuildMetadataIdentifier = BuildMetadataIdentifier.filter {count($0) > 0}
            if count(clearedBuildMetadataIdentifier) > 0
            {
                parsedComponents.append(.BuildMetadataIdentifier(clearedBuildMetadataIdentifier))
            }
            
            if count(clearedBuildMetadataIdentifier) == 0 || count(clearedBuildMetadataIdentifier) != count(BuildMetadataIdentifier)
            {
                return Result.Failure(location: scanner.scanLocation, failedComponent: .BuildMetadataIdentifier(nil), parsedComponents: parsedComponents)
            }

        }
        
        if scanner.atEnd
        {
            return Result.Success(parsedComponents)
        }
        else
        {
            var next = Component.Major(nil)
            switch parsedComponents.last
            {
            case .Some(let component) where component ≈ .Major(nil):
                next = .Minor(nil)
            case .Some(let component) where component ≈ .Minor(nil):
                next = .Patch(nil)
            case .Some(let component) where component ≈ .Patch(nil):
                next = .Patch(nil) //.PrereleaseIdentifier(nil)
            case .Some(let component) where component ≈ .PrereleaseIdentifier(nil):
                next = .BuildMetadataIdentifier(nil)
            case .Some(let component) where component ≈ .BuildMetadataIdentifier(nil):
                next = .BuildMetadataIdentifier(nil)
            default:
                next = .Major(nil)
            }
            println(next)
            return Result.Failure(location: scanner.scanLocation, failedComponent: next, parsedComponents: parsedComponents)
        }
    }

    private func scanNumeric() -> String?
    {
        var string:  NSString?
        self.scanner.scanCharactersFromSet(NumericCharacterSet, intoString:&string)
        return string as? String
    }
    
    private func scanIdentifiers() -> [String]
    {
        var identifiers = [String]()
        do
        {
            var string:  NSString?
            self.scanner.scanCharactersFromSet(IndentifierCharacterSet, intoString:&string)
            if let identifier = string as? String
            {
                identifiers.append(identifier)
                if self.scanner.scanString(DefaultDelimeter, intoString: nil)
                {
                    if self.scanner.atEnd { identifiers.append("") }
                    continue
                }
                else { break }
            }
            else { identifiers.append(""); break }
        } while (!self.scanner.atEnd)
        

        return identifiers
    }
    
    private func scanDelimeter(delimeter: String) -> Bool
    {
        var string:  NSString?
        self.scanner.scanString(delimeter, intoString: &string)
        return string == delimeter
    }

}

/**
*  Extension of SemanticVersion the conform to StringLiteralConvertible
*  so Versions can be initalized by assigning a String like:
*  `let version : SemanticVersion = "1.2.0"`
*/
extension Version: StringLiteralConvertible
{
    public init(_ versionString: String)
    {
        let version = Version(versionString, strict: false)
        if let version = version
        {
            self = version
        }
        else
        {
            self = Version(major: 0)
        }
    }
    
    /**
    Will try to initialize a SemanticVersion from a specified String
    
    :param: versionString String representing a version
    :param: strict        if true the initializer will fail if the version string is malformed / incomplete
                          if false a SemanticVersion will be returned even if the string was malformed / incompleted this will contain the
                          components that could be parsed and set the default for all others (e.g. 0 for version numbers and nil for identifiers)
                          this is useful if you want to init with string like "1.1" which lacks the patch number or even "2" wich lacks minor and patch numbers - in both cases you'll get a valid SemanticVersion 1.1.0 / 2.0.0
    
    :returns: initialized SemanticVersion or nil if version string could not be parsed
    */
    public init?(_ versionString: String, strict: Bool)
    {
        let parser = SemanticVersionParser(versionString)
        let result = parser.parse()
        
        switch result {
        case .Success(let components):
            self.init(parsedComponents: components)
        case .Failure(let location, let failedComponent, let parsedComponents):
            if strict
            {
                return nil
            }
            else
            {
                self.init(parsedComponents: parsedComponents)
            }
        }
    }
    
    init(parsedComponents: [SemanticVersionParser.Component])
    {
        self.init(major: 0)
        
        for component in parsedComponents
        {
            switch component {
            case .Major(let major):
                self.major = major ?? 0
            case .Minor(let minor):
                self.minor = minor ?? 0
            case .Patch(let patch):
                self.patch = patch ?? 0
            case .PrereleaseIdentifier(let identifer):
                if let prereleaseIdentifier = identifer
                {
                    self.preReleaseIdentifier = prereleaseIdentifier
                }
            case .BuildMetadataIdentifier(let identifer):
                if let buildMetadataIdentifier = identifer
                {
                    self.buildMetadataIdentifier = buildMetadataIdentifier
                }
            }
        }
    }
    
    // MARK: StringLiteralConvertible
    
    public init(stringLiteral value: String)
    {
        self = Version(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String)
    {
        self = Version(value)
    }
    
    public init(unicodeScalarLiteral value: String)
    {
        self = Version(value)
    }
}