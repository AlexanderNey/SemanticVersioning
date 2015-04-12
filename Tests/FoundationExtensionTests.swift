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

class FoundationExtensionTests: XCTestCase
{
    
    func testNSOperatingSystemVersion()
    {
        let version = NSOperatingSystemVersion(majorVersion: 8, minorVersion: 2, patchVersion: 1)
        
        XCTAssertEqual(version.major, 8, "major must be 8")
        XCTAssertEqual(version.minor, 2, "major must be 2")
        XCTAssertEqual(version.patch, 1, "major must be 1")
        XCTAssert(version.isPrerelease == false, "must be no prerelease")
        XCTAssert(version.preReleaseIdentifier.isEmpty, "must have no prerelease identifier")
        XCTAssert(version.buildMetadataIdentifier.isEmpty, "must have no metadata identifier")
    }
    
    func testNSBundleVersion()
    {
        let bundle = NSBundle(forClass: self.dynamicType)
        let version = bundle.version!
        
        XCTAssertEqual(version.major, 1, "major must be 1")
        XCTAssertEqual(version.minor, 0, "major must be 0")
        XCTAssertEqual(version.patch, 0, "major must be 0")
        XCTAssert(version.isPrerelease == false, "must be no prerelease")
        XCTAssert(version.preReleaseIdentifier.isEmpty, "must have no prerelease identifier")
        XCTAssert(contains(version.buildMetadataIdentifier, "unittests"), "must contain 'unittests' identifier as build metadata")
    }
    
    func testUIDeviceSystemVersion()
    {
        let version = UIDevice.currentDevice().operatingSystemVersion
        
        // really depends on the test environment - limited test here
        XCTAssert(version.major > 0, "major must be something bigger then 0")
        XCTAssert(version.isPrerelease == false, "must be no prerelease")
        XCTAssert(version.preReleaseIdentifier.isEmpty, "must have no prerelease identifier")
        XCTAssert(version.buildMetadataIdentifier.isEmpty, "must have no prerelease identifier")
    }
}