//
//  SemanticVersion.swift
//
//  Created by Alexander Ney on 05/02/2015.
//  Copyright (c) 2015 Alexander Ney. All rights reserved.
//

import Foundation

/**
*  Implements Sematic Version specification 2.0.0
*/
public struct SemanticVersion: Comparable, Printable
{
    public var major: Int
    public var minor: Int
    public var patch: Int
    public var preReleaseIdentifier: [String]?
    public var buildMetadataIdentifier: [String]?
    
    public var isPrerelease: Bool {
        if let indentifier = self.preReleaseIdentifier
        {
            return !indentifier.isEmpty
        }
        else { return false }
    }
    
    /**
    :returns: returns a SemanticVersion defining the specification that is implemented (http://semver.org/spec/v2.0.0.html)
    */
    public static var specification: SemanticVersion {
        return SemanticVersion(major: 2, minor: 0, patch: 0)
    }
    
    public var description: String {
        var versionString = "\(self.major).\(self.minor).\(self.patch)"
        if let indetifier = self.preReleaseIdentifier
        {
            versionString += "-" + ".".join(indetifier)
        }
        
        if let indetifier = self.buildMetadataIdentifier
        {
            versionString += "=" + ".".join(indetifier)
        }
        
        return versionString
    }
    
    public init(major: Int, minor: Int = 0, patch: Int = 0, preReleaseIdentifier: [String]? = nil, buildMetadataIdentifier: [String]? = nil)
    {
        self.major = major
        self.minor = minor
        self.patch = patch
        
        self.preReleaseIdentifier = preReleaseIdentifier
        self.buildMetadataIdentifier = buildMetadataIdentifier
    }
    
    public init()
    {
        self.major = 0
        self.minor = 0
        self.patch = 0
    }
}

// MARK: comparison

infix operator ≈ { associativity left precedence 140 }
func ≈ (left: SemanticVersion, right: SemanticVersion) -> Bool
{
    return  (left.major == right.major) &&
            (left.minor == right.minor) &&
            (left.patch == right.patch)
}

infix operator ≉ { associativity left precedence 140 }
func ≉ (left: SemanticVersion, right: SemanticVersion) -> Bool
{
    return  !(left ≈ right)
}

public func == (left: SemanticVersion, right: SemanticVersion) -> Bool
{
    return  left ≈ right &&
            (left.preReleaseIdentifier ==? right.preReleaseIdentifier)
}


public func < (left: SemanticVersion, right: SemanticVersion) -> Bool
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
                    return left.preReleaseIdentifier! < right.preReleaseIdentifier!
                }
            }
            else { return false }
        }
        else { return false }
    }
    
    return false
}

// MARK: private comparison operators

infix operator ==? { associativity left precedence 140 }
private func ==? <T: Comparable>(a: [T]?, b: [T]?) -> Bool
{
    switch (a, b) {
    case (let a, let b) where a != nil && b != nil:
        return a! == b!
    case (let a, let b) where a == nil && b == nil:
        return true
    default: return false
    }
}

private func < (left: [String], right: [String]) -> Bool
{
    for i in 0..<count(left)
    {
        let leftFragment = left[i]
        let rightFragment: String? = Int(i) < count(right) ? right[i] : nil
        
        if leftFragment <? rightFragment
        {
            return true
        }
        else if leftFragment == rightFragment
        {
            continue
        }
        else
        {
            return false
        }
    }
    
    // A larger set of pre-release fields has a higher precedence than a smaller set, if all of the preceding identifiers are equal
    return count(left) < count(right)
}

infix operator <? { associativity left}
private func <? (left: String, optionalRight: String?) -> Bool
{
    if let right = optionalRight
    {
        let numericLeft = left.toInt()
        let numericRight = right.toInt()
        
        if let numericLeft = numericLeft, numericRight = numericRight
        {
            return numericLeft < numericRight // identifiers consisting of only digits are compared numerically
        }
        else if numericLeft != nil && numericRight == nil
        {
            return true // Numeric identifiers always have lower precedence than non-numeric identifiers
        }
        else if numericLeft == nil && numericRight != nil
        {
            return false
        }
        else
        {
            return left < right // identifiers with letters or hyphens are compared lexically in ASCII sort order
        }
    }
    else { return false } // Optional value have lower precedence
}
