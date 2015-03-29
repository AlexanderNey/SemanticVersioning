//
//  SemanticVersion.swift
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

public protocol SemanticVersion: Comparable
{
    var major: Int { get }
    var minor: Int { get }
    var patch: Int { get }
    var preReleaseIdentifier: [String] { get }
    var buildMetadataIdentifier: [String] { get }
    var isPrerelease: Bool { get }
}

/**
*  Implements Sematic Version specification 2.0.0
*/
public struct Version: SemanticVersion, Printable
{
    public var major: Int
    public var minor: Int
    public var patch: Int
    public var preReleaseIdentifier: [String]
    public var buildMetadataIdentifier: [String]
    public var isPrerelease: Bool { return !self.preReleaseIdentifier.isEmpty }
    
    /**
    :returns: returns a SemanticVersion defining the specification that is implemented (http://semver.org/spec/v2.0.0.html)
    */
    public static var specification: Version {
        return Version(major: 2, minor: 0, patch: 0)
    }
    
    public var description: String {
        var versionString = "\(self.major).\(self.minor).\(self.patch)"
        
        if !self.preReleaseIdentifier.isEmpty
        {
            versionString += "-" + ".".join(self.preReleaseIdentifier)
        }
        
        if !self.buildMetadataIdentifier.isEmpty
        {
            versionString += "+" + ".".join(self.buildMetadataIdentifier)
        }
        
        return versionString
    }
    
    public init(major: Int, minor: Int = 0, patch: Int = 0, preReleaseIdentifier: [String] = [], buildMetadataIdentifier: [String] = [])
    {
        self.major = major
        self.minor = minor
        self.patch = patch
        
        self.preReleaseIdentifier = preReleaseIdentifier
        self.buildMetadataIdentifier = buildMetadataIdentifier
    }
    
    private init()
    {
        self = Version(major: 0)
    }
}

// MARK: comparison

infix operator ≈ { associativity left precedence 140 }
func ≈ <T: SemanticVersion>(left: T, right: T) -> Bool
{
    return  (left.major == right.major) &&
            (left.minor == right.minor) &&
            (left.patch == right.patch)
}

infix operator !≈ { associativity left precedence 140 }
func !≈ <T: SemanticVersion>(left: T, right: T) -> Bool
{
    return  !(left ≈ right)
}

public func == <T: SemanticVersion>(left: T, right: T) -> Bool
{
    return  left ≈ right &&
            (left.preReleaseIdentifier == right.preReleaseIdentifier)
}


public func < <T: SemanticVersion>(left: T, right: T) -> Bool
{
    if left.major < right.major
    {
        return true
    }
    else if left.major == right.major
    {
        if left.minor < right.minor
        {
            return true
        }
        else if left.minor == right.minor
        {
            if left.patch < right.patch
            {
                return true
            }
            else if left.patch == right.patch
            {
                if left.isPrerelease && !right.isPrerelease
                {
                    return true
                }
                else if left.isPrerelease && right.isPrerelease
                {
                    // Compare prerelease identifier
                    let identifiers = Zip2(left.preReleaseIdentifier, right.preReleaseIdentifier)
                    for pair in identifiers
                    {
                        let numericLeft = pair.0.toInt()
                        let numericRight = pair.1.toInt()
                        
                        if let numericLeft = numericLeft, numericRight = numericRight where numericLeft != numericRight
                        {
                            // identifiers consisting of only digits are compared numerically
                            return numericLeft < numericRight
                        }
                        else if numericLeft != nil && numericRight == nil
                        {
                            return true // Numeric identifiers always have lower precedence than non-numeric identifiers
                        }
                        else if numericLeft == nil && numericRight != nil
                        {
                            return false
                        }
                        else if pair.0 != pair.1
                        {
                            // identifiers with letters or hyphens are compared lexically in ASCII sort order
                            return pair.0 < pair.1
                        }
                    }
                    
                    // A larger set of pre-release fields has a higher precedence than a smaller set, if all of the preceding identifiers are equal
                    return count(left.preReleaseIdentifier) < count(right.preReleaseIdentifier)
                }
            }
            else { return false }
        }
        else { return false }
    }
    
    return false
}


