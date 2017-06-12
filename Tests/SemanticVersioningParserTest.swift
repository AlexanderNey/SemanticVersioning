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


class VersioningParserTests: XCTestCase
{
    
    func testParserWithBasicVersion()
    {
        let parser = SemanticVersionParser("1.2.3")
        let result = parser.parse()
        
        switch result {
        case .success(let components):
            for component in components
            {
                switch component {
                case .major(let major):
                    XCTAssertNotNil(major)
                    XCTAssertEqual(major ?? -1, 1, "wrong major version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertNotNil(minor)
                    XCTAssertEqual(minor ?? -1, 2, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertNotNil(patch)
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch.debugDescription)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .failure(let location, let failedComponent, _):
            XCTFail("failed to scan at \(location) failed component \(failedComponent)")
        }
    }
    
    func testParserWithBasicPrereleaseVersion()
    {
        let parser = SemanticVersionParser("0.12.75-alpha1")
        let result = parser.parse()
        
        switch result {
        case .success(let parsedComponents):
            XCTAssert(parsedComponents.count == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 0, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 12, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 75, "wrong patch version \(patch.debugDescription)")
                case .prereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong number of prerelease identifier")
                    XCTAssert((identifier!).contains("alpha1"), "prerelase ifentifier should contain 'alpha1'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .failure(_, _, _):
            XCTFail("parsing should succeed")
        }
    }

    func testParserWithBasicPrereleaseVersionMultipleIdentifier()
    {
        let parser = SemanticVersionParser("0.0.1234-alpha.log-fix")
        let result = parser.parse()
        
        switch result {
        case .success(let parsedComponents):
            XCTAssert(parsedComponents.count == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 0, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 0, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 1234, "wrong patch version \(patch.debugDescription)")
                case .prereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 2, "wrong number of prerelease identifier")
                    XCTAssert((identifier!).contains("alpha"), "prerelase ifentifier should contain 'alpha'")
                    XCTAssert((identifier!).contains("log-fix"), "prerelase ifentifier should contain 'log-fix'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .failure(_, _, _):
            XCTFail("parsing should succeed")
        }
    }

    func testParserWithBasicVersionAndBuildMetadata()
    {
        let parser = SemanticVersionParser("1.0.6+staging")
        let result = parser.parse()
        
        switch result {
        case .success(let parsedComponents):
            XCTAssert(parsedComponents.count == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 0, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 6, "wrong patch version \(patch.debugDescription)")
                case .buildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong number of build metadata identifier")
                    XCTAssert((identifier!).contains("staging"), "prerelase ifentifier should contain 'staging'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .failure(_, _, _):
            XCTFail("parsing should succeed")
        }
    }
    
    func testParserWithBasicVersionAndMultipleBuildMetadata()
    {
        let parser = SemanticVersionParser("1.1234.6678+timestamp.1168336800")
        let result = parser.parse()
        
        switch result {
        case .success(let parsedComponents):
            XCTAssert(parsedComponents.count == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 1234, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 6678, "wrong patch version \(patch.debugDescription)")
                case .buildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 2, "wrong number of build metadata identifier")
                    XCTAssert((identifier!).contains("timestamp"), "prerelase ifentifier should contain 'timestamp'")
                    XCTAssert((identifier!).contains("1168336800"), "prerelase ifentifier should contain '1168336800'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .failure(_, _, _):
            XCTFail("parsing should succeed")
        }
    }
    
    func testParserWithBasicPrereleaseVersionAndMetadata()
    {
        let parser = SemanticVersionParser("0.12.75-alpha1+staging")
        let result = parser.parse()
        
        switch result {
        case .success(let parsedComponents):
            XCTAssert(parsedComponents.count == 5, "should have parsed 5 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 0, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 12, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 75, "wrong patch version \(patch.debugDescription)")
                case .prereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong number of prerelease identifier")
                    XCTAssert((identifier!).contains("alpha1"), "prerelase ifentifier should contain 'alpha1'")
                case .buildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong number of build metadata identifier")
                    XCTAssert((identifier!).contains("staging"), "metadata ifentifier should contain 'staging'")
                }
            }
        case .failure(_, _, _):
            XCTFail("parsing should succeed")
        }
    }

    func testParserWithBasicPrereleaseVersionMultipleIdentifierAndMultipleMetadataIndentifier()
    {
        let parser = SemanticVersionParser("0.0.7-alpha2.hotfix+staging.api7")
        let result = parser.parse()
        
        switch result {
        case .success(let parsedComponents):
            XCTAssert(parsedComponents.count == 5, "should have parsed 5 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 0, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 0, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 7, "wrong patch version \(patch.debugDescription)")
                case .prereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 2, "wrong number of prerelease identifier")
                    XCTAssert((identifier!).contains("alpha2"), "prerelase ifentifier should contain 'alpha2'")
                    XCTAssert((identifier!).contains("hotfix"), "prerelase ifentifier should contain 'hotfix'")
                case .buildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 2, "wrong number of build metadata identifier")
                    XCTAssert((identifier!).contains("staging"), "metadata ifentifier should contain 'staging'")
                    XCTAssert((identifier!).contains("api7"), "metadata ifentifier should contain 'api7'")
                }
            }
        case .failure(_, _, _):
            XCTFail("parsing should succeed")
        }
    }

    
    // MARK: Negatives
    
    func testParserFailWithOnlyMajorVersion()
    {
        let parser = SemanticVersionParser("4")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 1, "failure loaction should be 1")
            XCTAssert(failedComponent == SemanticVersionParser.Component.major(nil), "should have failed on parsing Major")
            XCTAssert(parsedComponents.first! == SemanticVersionParser.Component.major(4), "should have parsed Major version 4")
        }
    }
    
    func testParserFailWithOnlyMajorDelimeterVersion()
    {
        let parser = SemanticVersionParser("10.")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 3, "failure loaction should be 3")
            XCTAssert(failedComponent == SemanticVersionParser.Component.minor(nil), "should have failed on parsing Minor")
            XCTAssert(parsedComponents.first! == SemanticVersionParser.Component.major(10), "should have parsed Major version 10")
        }
    }
    
    func testParserFailWithOnlyMajorDelimeterMinor()
    {
        let parser = SemanticVersionParser("8.2")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 3, "failure loaction should be 3")
            XCTAssert(failedComponent == SemanticVersionParser.Component.minor(nil), "should have failed on parsing Minor")
            XCTAssert(parsedComponents.count == 2, "should have parsed 2 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 8, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 2, "wrong minor version \(minor.debugDescription)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }

    func testParserFailWithOnlyMajorDelimeterMinorDelimeter()
    {
        let parser = SemanticVersionParser("999.60.")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 7, "failure loaction should be 7")
            XCTAssert(failedComponent == SemanticVersionParser.Component.patch(nil), "should have failed on parsing Patch")
            XCTAssert(parsedComponents.count == 2, "should have parsed 2 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 999, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 60, "wrong minor version \(minor.debugDescription)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }
    
    func testParserFailWithOnlyMajorDelimeterMinorDelimeterPatchWrongDelimeter()
    {
        let parser = SemanticVersionParser("0.6.12.100")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 6, "failure loaction should be 6")
            XCTAssert(failedComponent == SemanticVersionParser.Component.patch(nil), "should have failed on parsing Patch")
            XCTAssert(parsedComponents.count == 3, "should have parsed 2 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 0, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 6, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 12, "wrong patch version \(patch.debugDescription)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }

    func testParserFailWithOnlyMajorDelimeterMinorDelimeterPatchPrereleaseDelimeter()
    {
        let parser = SemanticVersionParser("1.4.3-")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 6, "failure loaction should be 6")
            XCTAssert(failedComponent == SemanticVersionParser.Component.prereleaseIdentifier(nil), "should have failed on parsing PrereleaseIdentifier")
            XCTAssert(parsedComponents.count == 3, "should have parsed 2 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch.debugDescription)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }

    func testParserFailWithEmptyPrereleaseIdentifier()
    {
        let parser = SemanticVersionParser("1.4.3-beta..")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 11, "failure loaction should be 11")
            XCTAssert(failedComponent == SemanticVersionParser.Component.prereleaseIdentifier(nil), "should have failed on parsing PrereleaseIdentifier")
            XCTAssert(parsedComponents.count == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch.debugDescription)")
                case .prereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong count of prerelease identifier")
                    XCTAssert((identifier!).contains("beta"), "metadata ifentifier should contain 'beta'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }

    func testParserFailWithPrereleaseVersionMalformedBuildMetadata()
    {
        let parser = SemanticVersionParser("1.4.3-beta+")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 11, "failure loaction should be 11")
            XCTAssert(failedComponent == SemanticVersionParser.Component.buildMetadataIdentifier(nil), "should have failed on parsing BuildMetadataIdentifier")
            XCTAssert(parsedComponents.count == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch.debugDescription)")
                case .prereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong count of prerelease identifier")
                    XCTAssert((identifier!).contains("beta"), "metadata ifentifier should contain 'beta'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }
    
    func testParserFailWithPrereleaseVersionEmptyBuildMetadataIdentifier()
    {
        let parser = SemanticVersionParser("1.4.3-beta+test1..test2")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 17, "failure loaction should be 11")
            XCTAssert(failedComponent == SemanticVersionParser.Component.buildMetadataIdentifier(nil), "should have failed on parsing BuildMetadataIdentifier")
            XCTAssert(parsedComponents.count == 5, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch.debugDescription)")
                case .prereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong count of prerelease identifier")
                    XCTAssert((identifier!).contains("beta"), "prerelease ifentifier should contain 'beta'")
                case .buildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong count of buildmetadata identifier")
                    XCTAssert((identifier!).contains("test1"), "metadata ifentifier should contain 'test1'")
                }
            }
        }
    }
    
    func testParserFailWithPrereleaseVersionEndsWithDelimeter()
    {
        let parser = SemanticVersionParser("1.4.3-beta.")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 11, "failure loaction should be 11")
            XCTAssert(failedComponent == SemanticVersionParser.Component.prereleaseIdentifier(nil), "should have failed on parsing PrereleaseIdentifier")
            XCTAssert(parsedComponents.count == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch.debugDescription)")
                case .prereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong count of prerelease identifier")
                    XCTAssert((identifier!).contains("beta"), "prerelease ifentifier should contain 'beta'")
                case .buildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong count of buildmetadata identifier")
                    XCTAssert((identifier!).contains("test1"), "metadata ifentifier should contain 'test1'")
                }
            }
        }
    }


    func testParserFailWithBuildMetadataEndsWithDelimeter()
    {
        let parser = SemanticVersionParser("1.4.3+meta.")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 11, "failure loaction should be 11")
            XCTAssert(failedComponent == SemanticVersionParser.Component.buildMetadataIdentifier(nil), "should have failed on parsing BuildMetadataIdentifier")
            XCTAssert(parsedComponents.count == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch.debugDescription)")
                case .buildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual((identifier!).count, 1, "wrong count of buildmetadata identifier")
                    XCTAssert((identifier!).contains("meta"), "metadata ifentifier should contain 'meta'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }

    // MARK: Malformed

    func testParserWithMalformedMajorVersionA()
    {
        let parser = SemanticVersionParser("+1.2.3")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 0, "failure loaction should be 0")
            XCTAssert(failedComponent == SemanticVersionParser.Component.major(nil), "should have failed on parsing Major")
            XCTAssert(parsedComponents.count == 0, "should have parsed 0 components")
            for component in parsedComponents
            {
                switch component {
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }
    
    func testParserWithMalformedMajorVersionB()
    {
        let parser = SemanticVersionParser("1b.2.3")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 1, "failure loaction should be 1")
            XCTAssert(failedComponent == SemanticVersionParser.Component.major(nil), "should have failed on parsing Major")
            XCTAssert(parsedComponents.count == 1, "should have parsed 1 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }

    func testParserWithMalformedMinorVersionA()
    {
        let parser = SemanticVersionParser("1.-2.3")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 2, "failure loaction should be 2")
            XCTAssert(failedComponent == SemanticVersionParser.Component.minor(nil), "should have failed on parsing Minor")
            XCTAssert(parsedComponents.count == 1, "should have parsed 1 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }

    func testParserWithMalformedMinorVersionB()
    {
        let parser = SemanticVersionParser("1.2b.3")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 3, "failure loaction should be 3")
            XCTAssert(failedComponent == SemanticVersionParser.Component.minor(nil), "should have failed on parsing Minor")
            XCTAssert(parsedComponents.count == 2, "should have parsed 1 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 2, "wrong minor version \(minor.debugDescription)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }
    
    func testParserWithMalformedPatchVersionA()
    {
        let parser = SemanticVersionParser("1.2.patch3")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 4, "failure loaction should be 4")
            XCTAssert(failedComponent == SemanticVersionParser.Component.patch(nil), "should have failed on parsing Minor")
            XCTAssert(parsedComponents.count == 2, "should have parsed 1 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 2, "wrong minor version \(minor.debugDescription)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }

    func testParserWithMalformedPatchVersionB()
    {
        let parser = SemanticVersionParser("1.2.3alpha")
        let result = parser.parse()
        
        switch result {
        case .success(_):
            XCTFail("parser should fail")
        case .failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 5, "failure loaction should be 5")
            XCTAssert(failedComponent == SemanticVersionParser.Component.patch(nil), "should have failed on parsing Patch")
            XCTAssert(parsedComponents.count == 3, "should have parsed 1 components")
            for component in parsedComponents
            {
                switch component {
                case .major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong major version \(major.debugDescription)")
                case .minor(let minor):
                    XCTAssertEqual(minor ?? -1, 2, "wrong minor version \(minor.debugDescription)")
                case .patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch.debugDescription)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
    }

    // MARK: Comparsion
    
    func testComparsionOfVersionFromStrings()
    {
        let versions: [Version] = ["1.0.0", "2.0.0", "2.1.0", "2.1.1"]
        
        var previousVersion: Version?
        for version in versions
        {
            if let previousVersion = previousVersion
            {
                XCTAssert(previousVersion < version, "\(previousVersion) musst be less then \(version)")
            }
            previousVersion = version
        }
    }

    
    func testComparsionOfPrereleaseVersionFromStrings()
    {
        let versions: [Version] = ["1.0.0-alpha", "1.0.0-alpha.1", "1.0.0-alpha.beta", "1.0.0-beta", "1.0.0-beta.2", "1.0.0-beta.11", "1.0.0-rc.1", "1.0.0"]
        
        var previousVersion: Version?
        for version in versions
        {
            if let previousVersion = previousVersion
            {
                XCTAssert(previousVersion < version, "\(previousVersion) musst be less then \(version)")
            }
            previousVersion = version
        }
    }

    // MARK: Performance
    
    func testPerformance()
    {
        let parseVersions = ["1.2.3", "2312.2123.455676", "0.4.5-alpha.stage+release.nightly.test", "12.2.malformed test", "12.100203.222233322"]
        self.measure() {
            for _ in 0...1000
            {
                for versionString in parseVersions
                {
                    let _: Version = Version(stringLiteral: versionString)
                }
            }
        }
    }

}
