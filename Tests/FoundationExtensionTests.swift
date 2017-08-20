//
//  FoundationExtensionTests.swift
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
import UIKit
import XCTest
import SemanticVersioning

class FoundationExtensionTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testNSOperatingSystemVersion() {
        let version = OperatingSystemVersion(majorVersion: 8, minorVersion: 2, patchVersion: 1)

        XCTAssertEqual(version.major, 8)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 1)
        XCTAssertFalse(version.isPrerelease)
        XCTAssertTrue(version.preReleaseIdentifier.isEmpty)
        XCTAssertTrue(version.buildMetadataIdentifier.isEmpty)
    }

    func testNSBundleVersion() {
        let selfType = type(of: self)
        let bundle = Bundle(for: selfType)
        let version = bundle.version!

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 1)
        XCTAssertEqual(version.patch, 0)
        XCTAssertFalse(version.isPrerelease)
        XCTAssertTrue(version.preReleaseIdentifier.isEmpty)
        XCTAssertEqual(version.buildMetadataIdentifier, ["unittests"])
    }

    func testUIDeviceSystemVersion() {
        let version = UIDevice.current.operatingSystemVersion

        // really depends on the test environment - limited test here
        XCTAssertNotNil(version)
        XCTAssertGreaterThan(version!.major, 0)
        XCTAssertFalse(version!.isPrerelease)
        XCTAssertTrue(version!.preReleaseIdentifier.isEmpty)
        XCTAssertTrue(version!.buildMetadataIdentifier.isEmpty)
    }
}
