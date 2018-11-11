//
//  VersioningTests.swift
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

// swiftlint:disable identifier_name

import XCTest
import SemanticVersioning

class VersioningTests: XCTestCase {

    func testBasicInitialisationWithMajor() {
        let ver = Version(major: 2)
        XCTAssertEqual(ver.major, 2)
        XCTAssertEqual(ver.minor, 0)
        XCTAssertEqual(ver.patch, 0)

        XCTAssertFalse(ver.isPrerelease)
        XCTAssertTrue(ver.preReleaseIdentifier.isEmpty)

        XCTAssertTrue(ver.buildMetadataIdentifier.isEmpty)
        XCTAssertEqual(ver.description, "2.0.0")
    }

    func testBasicInitialisationWithMajorMinor() {
        let ver = Version(major: 1, minor: 3)
        XCTAssertEqual(ver.major, 1)
        XCTAssertEqual(ver.minor, 3)
        XCTAssertEqual(ver.patch, 0)

        XCTAssertFalse(ver.isPrerelease)
        XCTAssertTrue(ver.preReleaseIdentifier.isEmpty)

        XCTAssertTrue(ver.buildMetadataIdentifier.isEmpty)
        XCTAssertEqual(ver.description, "1.3.0")
    }

    func testBasicInitialisationWithMajorMinorPatch() {
        let ver = Version(major: 0, minor: 22, patch: 300)
        XCTAssertEqual(ver.major, 0)
        XCTAssertEqual(ver.minor, 22)
        XCTAssertEqual(ver.patch, 300)

        XCTAssertFalse(ver.isPrerelease)
        XCTAssertTrue(ver.preReleaseIdentifier.isEmpty)

        XCTAssertTrue(ver.buildMetadataIdentifier.isEmpty)
        XCTAssertEqual(ver.description, "0.22.300")
    }

    func testBasicInitialisationWithMajorMinorPatchPrerelase() {
        let ver = Version(major: 1, preReleaseIdentifier: ["alpha", "2"])
        XCTAssertEqual(ver.major, 1)
        XCTAssertEqual(ver.minor, 0)
        XCTAssertEqual(ver.patch, 0)

        XCTAssertTrue(ver.isPrerelease)
        XCTAssertEqual(ver.preReleaseIdentifier, ["alpha", "2"])

        XCTAssertTrue(ver.buildMetadataIdentifier.isEmpty)
        XCTAssertEqual(ver.description, "1.0.0-alpha.2")
    }

    func testBasicInitialisationWithMajorMinorPatchBuildMetadata() {
        let ver = Version(major: 1, patch: 3, buildMetadataIdentifier: ["build12", "meta"])
        XCTAssertEqual(ver.major, 1)
        XCTAssertEqual(ver.minor, 0)
        XCTAssertEqual(ver.patch, 3)

        XCTAssertFalse(ver.isPrerelease)
        XCTAssertTrue(ver.preReleaseIdentifier.isEmpty)

        XCTAssertEqual(ver.buildMetadataIdentifier, ["build12", "meta"])
        XCTAssertEqual(ver.description, "1.0.3+build12.meta")
    }

    func testBasicInitialisationWithMajorMinorPatchPrereleaseBuildMetadata() {
        let ver = Version(major: 0, preReleaseIdentifier: ["prerelease"], buildMetadataIdentifier: ["meta"])
        XCTAssertEqual(ver.major, 0)
        XCTAssertEqual(ver.minor, 0)
        XCTAssertEqual(ver.patch, 0)

        XCTAssertTrue(ver.isPrerelease)
        XCTAssertEqual(ver.preReleaseIdentifier, ["prerelease"])

        XCTAssertEqual(ver.buildMetadataIdentifier, ["meta"])
        XCTAssertEqual(ver.description, "0.0.0-prerelease+meta")
    }

    // MARK: comparison

    func testEqualityOfMajor() {
        let a = Version(major: 1)
        let b = Version(major: 2)
        let c = Version(major: 1)

        XCTAssertEqual(a, c)
        XCTAssertFalse(a < c)
        XCTAssertLessThan(a, b)
        XCTAssertNotEqual(a, b)
        XCTAssertEqual(c, c)
    }

    func testEqualityOfMajorMinor() {
        let a = Version(major: 1, minor: 1)
        let b = Version(major: 1, minor: 10)
        let c = Version(major: 1, minor: 1)

        XCTAssertEqual(a, c)
        XCTAssertFalse(a < c)
        XCTAssertLessThan(a, b)
        XCTAssertNotEqual(a, b)
        XCTAssertEqual(c, c)
    }

    func testEqualityOfMajorMinorPatch() {
        let a = Version(major: 0, minor: 1, patch: 2)
        let b = Version(major: 0, minor: 1, patch: 3)
        let c = Version(major: 0, minor: 1, patch: 2)

        XCTAssertEqual(a, c)
        XCTAssertFalse(a < c)
        XCTAssertLessThan(a, b)
        XCTAssertNotEqual(a, b)
        XCTAssertEqual(c, c)
    }

    func testEqualityOfPrereleaseVersion() {
        let a = Version(major: 1, preReleaseIdentifier: ["alpha", "1"])
        let b = Version(major: 1, preReleaseIdentifier: ["beta"])
        let c = Version(major: 1, preReleaseIdentifier: ["alpha", "1"])
        let d = Version(major: 1, preReleaseIdentifier: ["alpha", "1", "nightly"])

        XCTAssertEqual(a, c)
        XCTAssertFalse(a < c)
        XCTAssertLessThan(a, b)
        XCTAssertNotEqual(a, b)
        XCTAssertEqual(c, c)
        XCTAssertLessThan(a, d)
        XCTAssertNotEqual(a, d)
    }

    func testEqualityOfPrereleaseVersionStrings() {
        let a = Version(major: 1, preReleaseIdentifier: ["alpha", "1"])
        let c = Version(major: 1, preReleaseIdentifier: ["alpha", "1"])

        XCTAssertEqual(a, c)
        XCTAssertFalse(a < c)
        XCTAssertLessThan(a, "1.0.0-beta")
        XCTAssertEqual(a, "1.0.0-alpha.1")
        XCTAssertEqual(c, c)
        XCTAssertLessThan(a, "1.0.0-alpha.1.nightly")
        XCTAssertNotEqual(a, "1.0.0-alpha.1.nightly")
    }

}
