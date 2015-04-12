//
//  VersionNumberLiteralConvertibleTests.swift
//  SemanticVersioning
//
//  Created by Alexander Ney on 12/04/2015.
//  Copyright (c) 2015 Alexander Ney. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import SemanticVersioning


class VersionNumberLiteralConvertibleTests: XCTestCase
{
    
    func testIntegerLiteralConvertible()
    {
        let version: Version = 2
        
        XCTAssertEqual(version.major, 2, "major must be 2")
        XCTAssertEqual(version.minor, 0, "major must be 0")
        XCTAssertEqual(version.patch, 0, "major must be 0")
        XCTAssert(version.isPrerelease == false, "must be no prerelease")
        XCTAssert(version.preReleaseIdentifier.isEmpty, "must have no prerelease identifier")
        XCTAssert(version.buildMetadataIdentifier.isEmpty, "must have no metadata identifier")
    }
    
    func testFloatLiteralConvertible()
    {
        let versionA: Version = 1.0
        let versionB: Version = 3.12
        let versionC: Version = 8.5001
        let versionD: Version = 0.71
        
        XCTAssertEqual(versionA.major, 1, "major must be 1")
        XCTAssertEqual(versionA.minor, 0, "major must be 0")
        XCTAssertEqual(versionA.patch, 0, "major must be 0")
        XCTAssert(versionA.isPrerelease == false, "must be no prerelease")
        XCTAssert(versionA.preReleaseIdentifier.isEmpty, "must have no prerelease identifier")
        XCTAssert(versionA.buildMetadataIdentifier.isEmpty, "must have no metadata identifier")
        
        XCTAssertEqual(versionB.major, 3, "major must be 3")
        XCTAssertEqual(versionB.minor, 12, "major must be 12")
        XCTAssertEqual(versionB.patch, 0, "major must be 0")
        XCTAssert(versionB.isPrerelease == false, "must be no prerelease")
        XCTAssert(versionB.preReleaseIdentifier.isEmpty, "must have no prerelease identifier")
        XCTAssert(versionB.buildMetadataIdentifier.isEmpty, "must have no metadata identifier")
        
        XCTAssertEqual(versionC.major, 8, "major must be 8")
        XCTAssertEqual(versionC.minor, 5001, "major must be 5001")
        XCTAssertEqual(versionC.patch, 0, "major must be 0")
        XCTAssert(versionC.isPrerelease == false, "must be no prerelease")
        XCTAssert(versionC.preReleaseIdentifier.isEmpty, "must have no prerelease identifier")
        XCTAssert(versionC.buildMetadataIdentifier.isEmpty, "must have no metadata identifier")
        
        XCTAssertEqual(versionD.major, 0, "major must be 0")
        XCTAssertEqual(versionD.minor, 71, "major must be 71")
        XCTAssertEqual(versionD.patch, 0, "major must be 0")
        XCTAssert(versionD.isPrerelease == false, "must be no prerelease")
        XCTAssert(versionD.preReleaseIdentifier.isEmpty, "must have no prerelease identifier")
        XCTAssert(versionD.buildMetadataIdentifier.isEmpty, "must have no metadata identifier")
    }
    
    func testCompareToFloatLiterals()
    {
        let version = Version(major: 2, minor: 22)
        
        XCTAssert(version == 2.22, "version must equal 2.22")
        XCTAssert(version < 2.23, "version must be smaller then 2.23")
        XCTAssert(version > 2.21, "version must be bigger then 2.21")
        XCTAssert(version < 3, "version must be smaller then3")
        XCTAssert(version > 1, "version must be bigger then 1")
    }
}
