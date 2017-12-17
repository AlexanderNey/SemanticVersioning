//
//  VersioningParserTest.swift
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
import XCTest
import SemanticVersioning

// swiftlint:disable:next type_body_length
class VersioningParserTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testParserWithBasicVersion() throws {
        let parser = SemanticVersionParser("1.2.3")
        let result = assertNoThrow(try parser.parse())

        XCTAssertEqual(result.major, 1)
        XCTAssertEqual(result.minor, 2)
        XCTAssertEqual(result.patch, 3)
        XCTAssertNil(result.prereleaseIdentifiers)
        XCTAssertNil(result.buildMetadataIdentifiers)
    }

    func testParserWithBasicPrereleaseVersion() throws {
        let parser = SemanticVersionParser("0.12.75-alpha1")
        let result = assertNoThrow(try parser.parse())

        XCTAssertEqual(result.major, 0)
        XCTAssertEqual(result.minor, 12)
        XCTAssertEqual(result.patch, 75)
        XCTAssertNotNil(result.prereleaseIdentifiers)
        XCTAssertEqual(result.prereleaseIdentifiers!, ["alpha1"])
        XCTAssertNil(result.buildMetadataIdentifiers)
    }

    func testParserWithBasicPrereleaseVersionMultipleIdentifier() throws {
        let parser = SemanticVersionParser("0.0.1234-alpha.log-fix")
        let result = assertNoThrow(try parser.parse())

        XCTAssertEqual(result.major, 0)
        XCTAssertEqual(result.minor, 0)
        XCTAssertEqual(result.patch, 1234)
        XCTAssertNotNil(result.prereleaseIdentifiers)
        XCTAssertEqual(result.prereleaseIdentifiers!, ["alpha", "log-fix"])
        XCTAssertNil(result.buildMetadataIdentifiers)
    }

    func testParserWithBasicVersionAndBuildMetadata() throws {
        let parser = SemanticVersionParser("1.0.6+staging")
        let result = assertNoThrow(try parser.parse())

        XCTAssertEqual(result.major, 1)
        XCTAssertEqual(result.minor, 0)
        XCTAssertEqual(result.patch, 6)
        XCTAssertNil(result.prereleaseIdentifiers)
        XCTAssertNotNil(result.buildMetadataIdentifiers)
        XCTAssertEqual(result.buildMetadataIdentifiers!, ["staging"])
    }

    func testParserWithBasicVersionAndMultipleBuildMetadata() throws {
        let parser = SemanticVersionParser("1.1234.6678+timestamp.1168336800")
        let result = assertNoThrow(try parser.parse())

        XCTAssertEqual(result.major, 1)
        XCTAssertEqual(result.minor, 1234)
        XCTAssertEqual(result.patch, 6678)
        XCTAssertNil(result.prereleaseIdentifiers)
        XCTAssertNotNil(result.buildMetadataIdentifiers)
        XCTAssertEqual(result.buildMetadataIdentifiers!, ["timestamp", "1168336800"])
    }

    func testParserWithBasicPrereleaseVersionAndMetadata() throws {
        let parser = SemanticVersionParser("0.12.75-alpha1+staging")
        let result = assertNoThrow(try parser.parse())

        XCTAssertEqual(result.major, 0)
        XCTAssertEqual(result.minor, 12)
        XCTAssertEqual(result.patch, 75)
        XCTAssertNotNil(result.prereleaseIdentifiers)
        XCTAssertEqual(result.prereleaseIdentifiers!, ["alpha1"])
        XCTAssertNotNil(result.buildMetadataIdentifiers)
        XCTAssertEqual(result.buildMetadataIdentifiers!, ["staging"])
    }

    func testParserWithBasicPrereleaseVersionMultipleIdentifierAndMultipleMetadataIndentifier() throws {
        let parser = SemanticVersionParser("0.0.7-alpha2.hotfix+staging.api7")
        let result = assertNoThrow(try parser.parse())

        XCTAssertEqual(result.major, 0)
        XCTAssertEqual(result.minor, 0)
        XCTAssertEqual(result.patch, 7)
        XCTAssertNotNil(result.prereleaseIdentifiers)
        XCTAssertEqual(result.prereleaseIdentifiers!, ["alpha2", "hotfix"])
        XCTAssertNotNil(result.buildMetadataIdentifiers)
        XCTAssertEqual(result.buildMetadataIdentifiers!, ["staging", "api7"])
    }

    // MARK: Negatives

    func testParserFailWithOnlyMajorVersion() throws {
        let parser = SemanticVersionParser("4")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 1)
            XCTAssertEqual(error.failedComponent, .major)
        }
    }

    func testParserFailWithOnlyMajorDelimeterVersion() {
        let parser = SemanticVersionParser("10.")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 3)
            XCTAssertEqual(error.failedComponent, .minor)
        }
    }

    func testParserPartialWithOnlyMajorDelimeterMinor() throws {
        let parser = SemanticVersionParser("8.2")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 3)
            XCTAssertEqual(error.failedComponent, .minor)

            let result = error.result
            XCTAssertEqual(result.major, 8)
            XCTAssertEqual(result.minor, 2)
            XCTAssertNil(result.patch)
            XCTAssertNil(result.prereleaseIdentifiers)
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    func testParserFailWithOnlyMajorDelimeterMinorDelimeter() {
        let parser = SemanticVersionParser("999.60.")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 7)
            XCTAssertEqual(error.failedComponent, .patch)

            let result = error.result
            XCTAssertEqual(result.major, 999)
            XCTAssertEqual(result.minor, 60)
            XCTAssertNil(result.patch)
            XCTAssertNil(result.prereleaseIdentifiers)
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    func testParserFailWithOnlyMajorDelimeterMinorDelimeterPatchWrongDelimeter() {
        let parser = SemanticVersionParser("0.6.12.100")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 6)
            XCTAssertEqual(error.failedComponent, .patch)

            let result = error.result
            XCTAssertEqual(result.major, 0)
            XCTAssertEqual(result.minor, 6)
            XCTAssertEqual(result.patch, 12)
            XCTAssertNil(result.prereleaseIdentifiers)
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    func testParserFailWithOnlyMajorDelimeterMinorDelimeterPatchPrereleaseDelimeter() {
        let parser = SemanticVersionParser("1.4.3-")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 6)
            XCTAssertEqual(error.failedComponent, .prereleaseIdentifiers)

            let result = error.result
            XCTAssertEqual(result.major, 1)
            XCTAssertEqual(result.minor, 4)
            XCTAssertEqual(result.patch, 3)
            XCTAssertNotNil(result.prereleaseIdentifiers)
            XCTAssertEqual(result.prereleaseIdentifiers!, [])
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    func testParserFailWithEmptyPrereleaseIdentifier() {
        let parser = SemanticVersionParser("1.4.3-beta..")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 11)
            XCTAssertEqual(error.failedComponent, .prereleaseIdentifiers)

            let result = error.result
            XCTAssertEqual(result.major, 1)
            XCTAssertEqual(result.minor, 4)
            XCTAssertEqual(result.patch, 3)
            XCTAssertNotNil(result.prereleaseIdentifiers)
            XCTAssertEqual(result.prereleaseIdentifiers!, ["beta"])
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    func testParserFailWithPrereleaseVersionMalformedBuildMetadata() {
        let parser = SemanticVersionParser("1.4.3-beta+")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 11)
            XCTAssertEqual(error.failedComponent, .buildMetadataIdentifiers)

            let result = error.result
            XCTAssertEqual(result.major, 1)
            XCTAssertEqual(result.minor, 4)
            XCTAssertEqual(result.patch, 3)
            XCTAssertNotNil(result.prereleaseIdentifiers)
            XCTAssertEqual(result.prereleaseIdentifiers!, ["beta"])
            XCTAssertNotNil(result.buildMetadataIdentifiers)
            XCTAssertEqual(result.buildMetadataIdentifiers!, [])
        }
    }

    func testParserFailWithPrereleaseVersionEmptyBuildMetadataIdentifier() {
        let parser = SemanticVersionParser("1.4.3-beta+test1..test2")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 17)
            XCTAssertEqual(error.failedComponent, .buildMetadataIdentifiers)

            let result = error.result
            XCTAssertEqual(result.major, 1)
            XCTAssertEqual(result.minor, 4)
            XCTAssertEqual(result.patch, 3)
            XCTAssertNotNil(result.prereleaseIdentifiers)
            XCTAssertEqual(result.prereleaseIdentifiers!, ["beta"])
            XCTAssertNotNil(result.buildMetadataIdentifiers)
            XCTAssertEqual(result.buildMetadataIdentifiers!, ["test1"])
        }
    }

    func testParserFailWithBuildMetadataEndsWithDelimeter() {
        let parser = SemanticVersionParser("1.4.3+meta.")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 11)
            XCTAssertEqual(error.failedComponent, .buildMetadataIdentifiers)

            let result = error.result
            XCTAssertEqual(result.major, 1)
            XCTAssertEqual(result.minor, 4)
            XCTAssertEqual(result.patch, 3)
            XCTAssertNil(result.prereleaseIdentifiers)
            XCTAssertNotNil(result.buildMetadataIdentifiers)
            XCTAssertEqual(result.buildMetadataIdentifiers!, ["meta"])
        }
    }

    // MARK: Malformed

    func testParserWithMalformedMajorVersionA() {
        let parser = SemanticVersionParser("+1.2.3")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 0)
            XCTAssertEqual(error.failedComponent, .major)

            let result = error.result
            XCTAssertNil(result.major)
            XCTAssertNil(result.minor)
            XCTAssertNil(result.patch)
            XCTAssertNil(result.prereleaseIdentifiers)
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    func testParserWithMalformedMajorVersionB() {
        let parser = SemanticVersionParser("1b.2.3")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 1)
            XCTAssertEqual(error.failedComponent, .major)

            let result = error.result
            XCTAssertEqual(result.major, 1)
            XCTAssertNil(result.minor)
            XCTAssertNil(result.patch)
            XCTAssertNil(result.prereleaseIdentifiers)
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    func testParserWithMalformedMinorVersionA() {
        let parser = SemanticVersionParser("1.-2.3")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 2)
            XCTAssertEqual(error.failedComponent, .minor)

            let result = error.result
            XCTAssertEqual(result.major, 1)
            XCTAssertNil(result.minor)
            XCTAssertNil(result.patch)
            XCTAssertNil(result.prereleaseIdentifiers)
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    func testParserWithMalformedMinorVersionB() {
        let parser = SemanticVersionParser("1.2b.3")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 3)
            XCTAssertEqual(error.failedComponent, .minor)

            let result = error.result
            XCTAssertEqual(result.major, 1)
            XCTAssertEqual(result.minor, 2)
            XCTAssertNil(result.patch)
            XCTAssertNil(result.prereleaseIdentifiers)
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    func testParserWithMalformedPatchVersionA() {
        let parser = SemanticVersionParser("1.2.patch3")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 4)
            XCTAssertEqual(error.failedComponent, .patch)

            let result = error.result
            XCTAssertEqual(result.major, 1)
            XCTAssertEqual(result.minor, 2)
            XCTAssertNil(result.patch)
            XCTAssertNil(result.prereleaseIdentifiers)
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    func testParserWithMalformedPatchVersionB() {
        let parser = SemanticVersionParser("1.2.3alpha")

        XCTAssertThrowsError(try parser.parse()) { error in
            guard let error = error as? SemanticVersionParser.ParsingError else { XCTFail(); return }
            XCTAssertEqual(error.location, 5)
            XCTAssertEqual(error.failedComponent, .patch)

            let result = error.result
            XCTAssertEqual(result.major, 1)
            XCTAssertEqual(result.minor, 2)
            XCTAssertEqual(result.patch, 3)
            XCTAssertNil(result.prereleaseIdentifiers)
            XCTAssertNil(result.buildMetadataIdentifiers)
        }
    }

    // MARK: Comparsion

    func testComparsionOfVersionFromStrings() {
        let versions: [Version] = ["1.0.0",
                                   "2.0.0",
                                   "2.1.0",
                                   "2.1.1"]

        var previousVersionState: Version?
        for version in versions {
            guard let previousVersion = previousVersionState else { continue }
            XCTAssertLessThan(previousVersion, version, "\(previousVersion) musst be less then \(version)")
            previousVersionState = version
        }
    }

    func testComparsionOfPrereleaseVersionFromStrings() {
        let versions: [Version] = ["1.0.0-alpha",
                                   "1.0.0-alpha.1",
                                   "1.0.0-alpha.beta",
                                   "1.0.0-beta",
                                   "1.0.0-beta.2",
                                   "1.0.0-beta.11",
                                   "1.0.0-rc.1",
                                   "1.0.0"]

        var previousVersion: Version?
        for version in versions {
            if let previousVersion = previousVersion {
                XCTAssert(previousVersion < version, "\(previousVersion) musst be less then \(version)")
            }
            previousVersion = version
        }
    }

    // MARK: Performance

    func testPerformance() {
        let parseVersions = ["1.2.3", "2312.2123.455676",
                             "0.4.5-alpha.stage+release.nightly.test",
                             "12.2.malformed test",
                             "12.100203.222233322"]
        self.measure {
            for _ in 0...1000 {
                for versionString in parseVersions {
                    let _: Version = Version(stringLiteral: versionString)
                }
            }
        }
    }

    // MARK: Helpers

    public func assertNoThrow<T>(_ expression: @autoclosure () throws -> T,
                                 file: StaticString = #file,
                                 line: UInt = #line) -> T {

        do {
            return try expression()
        } catch let error {
            XCTFail("expression expected not to throw but threw `\(error)`", file: file, line: line)
            fatalError()
        }
    }
    // swiftlint:disable:next file_length
}
