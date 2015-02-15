//
//  SemanticVersioningTests.swift
//  SemanticVersioningTests
//
//  Created by Alexander Ney on 05/02/2015.
//  Copyright (c) 2015 Alexander Ney. All rights reserved.
//

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
        XCTAssertNil(ver.preReleaseIdentifier, "prerelase identifiers should be nil")
        
        XCTAssertNil(ver.buildMetadataIdentifier, "build meta data identifiers should be nil")
    }
    
    func testBasicInitialisationWithMajorMinor()
    {
        let ver = SemanticVersion(major: 1, minor: 3)
        XCTAssertEqual(ver.major, 1, "major should be 1")
        XCTAssertEqual(ver.minor, 3, "minor should be 3")
        XCTAssertEqual(ver.patch, 0, "patch should be 0")
        
        XCTAssertEqual(ver.isPrerelease, false, "sould not be a prerelase version")
        XCTAssertNil(ver.preReleaseIdentifier, "prerelase identifiers should be nil")
        
        XCTAssertNil(ver.buildMetadataIdentifier, "build meta data identifiers should be nil")
    }
    
    func testBasicInitialisationWithMajorMinorPatch()
    {
        let ver = SemanticVersion(major: 0, minor: 22, patch: 300)
        XCTAssertEqual(ver.major, 0, "major should be 0")
        XCTAssertEqual(ver.minor, 22, "minor should be 22")
        XCTAssertEqual(ver.patch, 300, "patch should be 300")
        
        XCTAssertEqual(ver.isPrerelease, false, "sould not be a prerelase version")
        XCTAssertNil(ver.preReleaseIdentifier, "prerelase identifiers should be nil")
        
        XCTAssertNil(ver.buildMetadataIdentifier, "build meta data identifiers should be nil")
    }
    
    func testBasicInitialisationWithMajorMinorPatchPrerelase()
    {
        let ver = SemanticVersion(major: 1, preReleaseIdentifier: ["alpha", "2"])
        XCTAssertEqual(ver.major, 1, "major should be 1")
        XCTAssertEqual(ver.minor, 0, "minor should be 0")
        XCTAssertEqual(ver.patch, 0, "patch should be 0")
        
        XCTAssertEqual(ver.isPrerelease, true, "sould be a prerelase version")
        XCTAssertNotNil(ver.preReleaseIdentifier, "prerelease identifiers should not be nil")
        let hasAllPreRelease = contains(ver.preReleaseIdentifier!, "alpha") && contains(ver.preReleaseIdentifier!, "2")
        XCTAssert(hasAllPreRelease, "prerelease identifiers should contain 'alpha' and '2'")
        
        XCTAssertNil(ver.buildMetadataIdentifier, "build meta data identifiers should be nil")
    }
    
    func testBasicInitialisationWithMajorMinorPatchBuildMetadata()
    {
        let ver = SemanticVersion(major: 1, patch: 3, buildMetadataIdentifier: ["build12", "meta"])
        XCTAssertEqual(ver.major, 1, "major should be 1")
        XCTAssertEqual(ver.minor, 0, "minor should be 0")
        XCTAssertEqual(ver.patch, 3, "patch should be 3")
        
        XCTAssertEqual(ver.isPrerelease, false, "sould not be a prerelase version")
        XCTAssertNil(ver.preReleaseIdentifier, "prerelase identifiers should be nil")
        
        XCTAssertNotNil(ver.buildMetadataIdentifier , "prerelase identifiers should be nil")
        let hasAllMetadata = contains(ver.buildMetadataIdentifier!, "build12") && contains(ver.buildMetadataIdentifier!, "meta")
        XCTAssert(hasAllMetadata, "build meta data should contain 'build12' and 'meta'")
    }

    func testBasicInitialisationWithMajorMinorPatchPrereleaseBuildMetadata()
    {
        let ver = SemanticVersion(major: 0, preReleaseIdentifier: ["prerelease"], buildMetadataIdentifier: ["meta"])
        XCTAssertEqual(ver.major, 0, "major should be 0")
        XCTAssertEqual(ver.minor, 0, "minor should be 0")
        XCTAssertEqual(ver.patch, 00, "patch should be 0")
        
        XCTAssertEqual(ver.isPrerelease, true, "sould be a prerelase version")
        XCTAssertNotNil(ver.preReleaseIdentifier, "prerelease identifiers should not be nil")
        let hasAllPreRelease = contains(ver.preReleaseIdentifier!, "prerelease")
        XCTAssert(hasAllPreRelease, "prerelease identifiers should contain 'prerelease'")
        
        XCTAssertNotNil(ver.buildMetadataIdentifier , "prerelase identifiers should be nil")
        let hasAllMetadata = contains(ver.buildMetadataIdentifier!, "meta")
        XCTAssert(hasAllMetadata, "build meta data should contain 'meta'")
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
