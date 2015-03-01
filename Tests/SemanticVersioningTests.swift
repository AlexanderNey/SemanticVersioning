//
//  SemanticVersioningTests.swift
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

import UIKit
import XCTest
import SemanticVersioning


class SemanticVersioningTests: XCTestCase
{
    
    func testBasicInitialisationWithMajor()
    {
        let ver = SemanticVersion(major: 2)
        XCTAssertEqual(ver.major, 2, "major should be 2")
        XCTAssertEqual(ver.minor, 0, "minor should be 0")
        XCTAssertEqual(ver.patch, 0, "patch should be 0")
        
        XCTAssertEqual(ver.isPrerelease, false, "sould not be a prerelase version")
        XCTAssert(ver.preReleaseIdentifier.isEmpty, "prerelase identifiers should be empty")
        
        XCTAssert(ver.buildMetadataIdentifier.isEmpty, "build meta data identifiers should be empty")
        XCTAssertEqual(ver.description, "2.0.0", "printable version should match")
    }
    
    func testBasicInitialisationWithMajorMinor()
    {
        let ver = SemanticVersion(major: 1, minor: 3)
        XCTAssertEqual(ver.major, 1, "major should be 1")
        XCTAssertEqual(ver.minor, 3, "minor should be 3")
        XCTAssertEqual(ver.patch, 0, "patch should be 0")
        
        XCTAssertEqual(ver.isPrerelease, false, "sould not be a prerelase version")
        XCTAssert(ver.preReleaseIdentifier.isEmpty, "prerelase identifiers should be empty")
        
        XCTAssert(ver.buildMetadataIdentifier.isEmpty, "build meta data identifiers should be empty")
        XCTAssertEqual(ver.description, "1.3.0", "printable version should match")
    }
    
    func testBasicInitialisationWithMajorMinorPatch()
    {
        let ver = SemanticVersion(major: 0, minor: 22, patch: 300)
        XCTAssertEqual(ver.major, 0, "major should be 0")
        XCTAssertEqual(ver.minor, 22, "minor should be 22")
        XCTAssertEqual(ver.patch, 300, "patch should be 300")
        
        XCTAssertEqual(ver.isPrerelease, false, "sould not be a prerelase version")
        XCTAssert(ver.preReleaseIdentifier.isEmpty, "prerelase identifiers should be empty")
        
        XCTAssert(ver.buildMetadataIdentifier.isEmpty, "build meta data identifiers should be empty")
        XCTAssertEqual(ver.description, "0.22.300", "printable version should match")
    }
    
    func testBasicInitialisationWithMajorMinorPatchPrerelase()
    {
        let ver = SemanticVersion(major: 1, preReleaseIdentifier: ["alpha", "2"])
        XCTAssertEqual(ver.major, 1, "major should be 1")
        XCTAssertEqual(ver.minor, 0, "minor should be 0")
        XCTAssertEqual(ver.patch, 0, "patch should be 0")
        
        XCTAssertEqual(ver.isPrerelease, true, "sould be a prerelase version")
        let hasAllPreRelease = contains(ver.preReleaseIdentifier, "alpha") && contains(ver.preReleaseIdentifier, "2")
        XCTAssert(hasAllPreRelease, "prerelease identifiers should contain 'alpha' and '2'")
        
        XCTAssert(ver.buildMetadataIdentifier.isEmpty, "build meta data identifiers should be empty")
        XCTAssertEqual(ver.description, "1.0.0-alpha.2", "printable version should match")
    }
    
    func testBasicInitialisationWithMajorMinorPatchBuildMetadata()
    {
        let ver = SemanticVersion(major: 1, patch: 3, buildMetadataIdentifier: ["build12", "meta"])
        XCTAssertEqual(ver.major, 1, "major should be 1")
        XCTAssertEqual(ver.minor, 0, "minor should be 0")
        XCTAssertEqual(ver.patch, 3, "patch should be 3")
        
        XCTAssertEqual(ver.isPrerelease, false, "sould not be a prerelase version")
        XCTAssert(ver.preReleaseIdentifier.isEmpty, "prerelase identifiers should be empty")
        
        let hasAllMetadata = contains(ver.buildMetadataIdentifier, "build12") && contains(ver.buildMetadataIdentifier, "meta")
        XCTAssert(hasAllMetadata, "build meta data should contain 'build12' and 'meta'")
        XCTAssertEqual(ver.description, "1.0.3+build12.meta", "printable version should match")
    }

    func testBasicInitialisationWithMajorMinorPatchPrereleaseBuildMetadata()
    {
        let ver = SemanticVersion(major: 0, preReleaseIdentifier: ["prerelease"], buildMetadataIdentifier: ["meta"])
        XCTAssertEqual(ver.major, 0, "major should be 0")
        XCTAssertEqual(ver.minor, 0, "minor should be 0")
        XCTAssertEqual(ver.patch, 0, "patch should be 0")
        
        XCTAssertEqual(ver.isPrerelease, true, "sould be a prerelase version")
        let hasAllPreRelease = contains(ver.preReleaseIdentifier, "prerelease")
        XCTAssert(hasAllPreRelease, "prerelease identifiers should contain 'prerelease'")
        
        let hasAllMetadata = contains(ver.buildMetadataIdentifier, "meta")
        XCTAssert(hasAllMetadata, "build meta data should contain 'meta'")
        XCTAssertEqual(ver.description, "0.0.0-prerelease+meta", "printable version should match")
    }

    // MARK: comparison
    
    func testEqualityOfMajor()
    {
        let a = SemanticVersion(major: 1)
        let b = SemanticVersion(major: 2)
        let c = SemanticVersion(major: 1)
        
        XCTAssert(a == c, "a must equal c")
        XCTAssertFalse(a < c, "a must not be smaller than c")
        XCTAssert(a < b, "a must be less than b")
        XCTAssert(a != b, "a must not equal b")
        XCTAssert(c == c, "c must equal c")
    }
    
    func testEqualityOfMajorMinor()
    {
        let a = SemanticVersion(major: 1, minor: 1)
        let b = SemanticVersion(major: 1, minor: 10)
        let c = SemanticVersion(major: 1, minor: 1)
        
        XCTAssert(a == c, "a must equal c")
        XCTAssertFalse(a < c, "a must not be smaller than c")
        XCTAssert(a < b, "a must be less than b")
        XCTAssert(a != b, "a must not equal b")
        XCTAssert(c == c, "c must equal c")
    }
    
    func testEqualityOfMajorMinorPatch()
    {
        let a = SemanticVersion(major: 0, minor: 1, patch: 2)
        let b = SemanticVersion(major: 0, minor: 1, patch: 3)
        let c = SemanticVersion(major: 0, minor: 1, patch: 2)
        
        XCTAssert(a == c, "a must equal c")
        XCTAssertFalse(a < c, "a must not be smaller than c")
        XCTAssert(a < b, "a must be less than b")
        XCTAssert(a != b, "a must not equal b")
        XCTAssert(c == c, "c must equal c")
    }
    
    func testEqualityOfPrereleaseVersion()
    {
        let a = SemanticVersion(major: 1, preReleaseIdentifier: ["alpha", "1"])
        let b = SemanticVersion(major: 1, preReleaseIdentifier: ["beta"])
        let c = SemanticVersion(major: 1, preReleaseIdentifier: ["alpha", "1"])
        let d = SemanticVersion(major: 1, preReleaseIdentifier: ["alpha", "1", "nightly"])
        
        XCTAssert(a == c, "a must equal c")
        XCTAssertFalse(a < c, "a must not be smaller than c")
        XCTAssert(a < b, "a must be less than b")
        XCTAssert(a != b, "a must not equal b")
        XCTAssert(c == c, "c must equal c")
        XCTAssert(a < d, "a must be less than d")
        XCTAssert(a != d, "a must not equal d")
    }
    
}
