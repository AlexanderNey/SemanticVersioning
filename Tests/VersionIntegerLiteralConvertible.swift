//
//  VersionNumberLiteralConvertibleTests.swift
//  SemanticVersioning
//
//  Created by Alexander Ney on 12/04/2015.
//  Copyright (c) 2015 Alexander Ney. All rights reserved.
//

import Foundation
import XCTest
import SemanticVersioning

class VersionIntegerLiteralConvertibleTests: XCTestCase {

    func testIntegerLiteralConvertible() {
        let version: Version = 2

        XCTAssertEqual(version.major, 2, "major must be 2")
        XCTAssertEqual(version.minor, 0, "major must be 0")
        XCTAssertEqual(version.patch, 0, "major must be 0")
        XCTAssert(version.isPrerelease == false, "must be no prerelease")
        XCTAssert(version.preReleaseIdentifier.isEmpty, "must have no prerelease identifier")
        XCTAssert(version.buildMetadataIdentifier.isEmpty, "must have no metadata identifier")
    }

    func testCompareToIntegerLiterals() {
        let version = Version(major: 2, minor: 22)

        XCTAssert(version.major == 2, "version must equal 2")
        XCTAssert(version < 3, "version must be smaller then 3")
        XCTAssert(version > 1, "version must be bigger then 1")
        XCTAssert(version != 1, "version must not equal 1")
        XCTAssert(version <= 4, "version must be smaller or equal to 4")

        let versionB = Version(major: 2)
        XCTAssert(versionB == 2, "version must equal 2")
    }
}
