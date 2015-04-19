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


class VersionIntegerLiteralConvertibleTests: XCTestCase
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
    
    
    func testCompareToIntegerLiterals()
    {
        let version = Version(major: 2, minor: 22)
        
        XCTAssert(version == 2, "version must equal 2")
        XCTAssert(version < 3, "version must be smaller then 3")
        XCTAssert(version > 1, "version must be bigger then 1")
        XCTAssert(version != 1, "version must not equal 1")
        XCTAssert(version >= 4, "version must be bigger or equal to 4")
    }
    
    func testGetFloatValue()
    {
        let versionA = Version(major: 8)
        let versionB = Version(major: 0, minor: 1002)
        let versionC = Version(major: 2, minor: 5431)

        
        XCTAssert(versionA.floatValue() == 8.0, "version must equal 8.0")
        XCTAssert(versionB.floatValue() >= 0.1002, "version must be bigger or equal then 0.1002")
        XCTAssert(versionC.floatValue() >= 2.5431, "version must be bigger or equal 2.5431")
    }
}
