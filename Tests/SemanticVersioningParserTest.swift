//
//  SemanticVersioningParserTest.swift
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


class SemanticVersioningParserTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParserWithBasicVersion()
    {
        let parser = SemanticVersionParser(versionString: "1.2.3")
        let result = parser.parse()
        
        switch result {
        case .Success(let components):
            for component in components
            {
                switch component {
                case .Major(let major):
                    XCTAssertNotNil(major)
                    XCTAssertEqual(major ?? -1, 1, "wrong major version \(major)")
                case .Minor(let minor):
                    XCTAssertNotNil(minor)
                    XCTAssertEqual(minor ?? -1, 2, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertNotNil(patch)
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTFail("failed to scan at \(location) failed component \(failedComponent)")
        }
        
        XCTAssert(true, "Pass")
    }
    
    func testParserWithBasicPrereleaseVersion()
    {
        let parser = SemanticVersionParser(versionString: "0.12.75-alpha1")
        let result = parser.parse()
        
        switch result {
        case .Success(let parsedComponents):
            XCTAssert(count(parsedComponents) == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 0, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 12, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 75, "wrong patch version \(patch)")
                case .PrereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong number of prerelease identifier")
                    XCTAssert(contains(identifier!,"alpha1"), "prerelase ifentifier should contain 'alpha1'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTFail("parse should succeed")
        }
        
        XCTAssert(true, "Pass")
    }

    func testParserWithBasicPrereleaseVersionMultipleIdentifier()
    {
        let parser = SemanticVersionParser(versionString: "0.0.1234-alpha.log-fix")
        let result = parser.parse()
        
        switch result {
        case .Success(let parsedComponents):
            XCTAssert(count(parsedComponents) == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 0, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 0, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 1234, "wrong patch version \(patch)")
                case .PrereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 2, "wrong number of prerelease identifier")
                    XCTAssert(contains(identifier!,"alpha"), "prerelase ifentifier should contain 'alpha'")
                    XCTAssert(contains(identifier!,"log-fix"), "prerelase ifentifier should contain 'log-fix'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTFail("parse should succeed")
        }
        
        XCTAssert(true, "Pass")
    }

    func testParserWithBasicVersionAndBuildMetadata()
    {
        let parser = SemanticVersionParser(versionString: "1.0.6+staging")
        let result = parser.parse()
        
        switch result {
        case .Success(let parsedComponents):
            XCTAssert(count(parsedComponents) == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 0, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 6, "wrong patch version \(patch)")
                case .BuildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong number of build metadata identifier")
                    XCTAssert(contains(identifier!,"staging"), "prerelase ifentifier should contain 'staging'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTFail("parse should succeed")
        }
        
        XCTAssert(true, "Pass")
    }
    
    func testParserWithBasicVersionAndMultipleBuildMetadata()
    {
        let parser = SemanticVersionParser(versionString: "1.1234.6678+timestamp.1168336800")
        let result = parser.parse()
        
        switch result {
        case .Success(let parsedComponents):
            XCTAssert(count(parsedComponents) == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 1234, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 6678, "wrong patch version \(patch)")
                case .BuildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 2, "wrong number of build metadata identifier")
                    XCTAssert(contains(identifier!,"timestamp"), "prerelase ifentifier should contain 'timestamp'")
                    XCTAssert(contains(identifier!,"1168336800"), "prerelase ifentifier should contain '1168336800'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTFail("parse should succeed")
        }
        
        XCTAssert(true, "Pass")
    }
    
    func testParserWithBasicPrereleaseVersionAndMetadata()
    {
        let parser = SemanticVersionParser(versionString: "0.12.75-alpha1+staging")
        let result = parser.parse()
        
        switch result {
        case .Success(let parsedComponents):
            XCTAssert(count(parsedComponents) == 5, "should have parsed 5 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 0, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 12, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 75, "wrong patch version \(patch)")
                case .PrereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong number of prerelease identifier")
                    XCTAssert(contains(identifier!,"alpha1"), "prerelase ifentifier should contain 'alpha1'")
                case .BuildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong number of build metadata identifier")
                    XCTAssert(contains(identifier!,"staging"), "metadata ifentifier should contain 'staging'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTFail("parse should succeed")
        }
        
        XCTAssert(true, "Pass")
    }

    func testParserWithBasicPrereleaseVersionMultipleIdentifierAndMultipleMetadataIndentifier()
    {
        let parser = SemanticVersionParser(versionString: "0.0.7-alpha2.hotfix+staging.api7")
        let result = parser.parse()
        
        switch result {
        case .Success(let parsedComponents):
            XCTAssert(count(parsedComponents) == 5, "should have parsed 5 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 0, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 0, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 7, "wrong patch version \(patch)")
                case .PrereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 2, "wrong number of prerelease identifier")
                    XCTAssert(contains(identifier!,"alpha2"), "prerelase ifentifier should contain 'alpha2'")
                    XCTAssert(contains(identifier!,"hotfix"), "prerelase ifentifier should contain 'hotfix'")
                case .BuildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 2, "wrong number of build metadata identifier")
                    XCTAssert(contains(identifier!,"staging"), "metadata ifentifier should contain 'staging'")
                    XCTAssert(contains(identifier!,"api7"), "metadata ifentifier should contain 'api7'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTFail("parse should succeed")
        }
        
        XCTAssert(true, "Pass")
    }

    
    // MARK: Negatives
    
    func testParserFailWithOnlyMajorVersion()
    {
        let parser = SemanticVersionParser(versionString: "4")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 1, "failure loaction should be 1")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Major(nil), "should have failed on parsing Major")
            XCTAssert(parsedComponents.first! == SemanticVersionParser.Component.Major(4), "should have parsed Major version 4")
        }
        
        XCTAssert(true, "Pass")
    }
    
    func testParserFailWithOnlyMajorDelimeterVersion()
    {
        let parser = SemanticVersionParser(versionString: "10.")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 3, "failure loaction should be 3")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Minor(nil), "should have failed on parsing Minor")
            XCTAssert(parsedComponents.first! == SemanticVersionParser.Component.Major(10), "should have parsed Major version 10")
        }
        
        XCTAssert(true, "Pass")
    }
    
    func testParserFailWithOnlyMajorDelimeterMinor()
    {
        let parser = SemanticVersionParser(versionString: "8.2")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 3, "failure loaction should be 3")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Minor(nil), "should have failed on parsing Minor")
            XCTAssert(count(parsedComponents) == 2, "should have parsed 2 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 8, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 2, "wrong minor version \(minor)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }

    func testParserFailWithOnlyMajorDelimeterMinorDelimeter()
    {
        let parser = SemanticVersionParser(versionString: "999.60.")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 7, "failure loaction should be 7")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Patch(nil), "should have failed on parsing Patch")
            XCTAssert(count(parsedComponents) == 2, "should have parsed 2 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 999, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 60, "wrong minor version \(minor)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }
    
    func testParserFailWithOnlyMajorDelimeterMinorDelimeterPatchWrongDelimeter()
    {
        let parser = SemanticVersionParser(versionString: "0.6.12.100")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 6, "failure loaction should be 6")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Patch(nil), "should have failed on parsing Patch")
            XCTAssert(count(parsedComponents) == 3, "should have parsed 2 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 0, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 6, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 12, "wrong patch version \(patch)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }

    func testParserFailWithOnlyMajorDelimeterMinorDelimeterPatchPrereleaseDelimeter()
    {
        let parser = SemanticVersionParser(versionString: "1.4.3-")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 6, "failure loaction should be 6")
            XCTAssert(failedComponent == SemanticVersionParser.Component.PrereleaseIdentifier(nil), "should have failed on parsing PrereleaseIdentifier")
            XCTAssert(count(parsedComponents) == 3, "should have parsed 2 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }

    func testParserFailWithEmptyPrereleaseIdentifier()
    {
        let parser = SemanticVersionParser(versionString: "1.4.3-beta..")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 11, "failure loaction should be 11")
            XCTAssert(failedComponent == SemanticVersionParser.Component.PrereleaseIdentifier(nil), "should have failed on parsing PrereleaseIdentifier")
            XCTAssert(count(parsedComponents) == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch)")
                case .PrereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong count of prerelease identifier")
                    XCTAssert(contains(identifier!,"beta"), "metadata ifentifier should contain 'beta'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }

    func testParserFailWithPrereleaseVersionMalformedBuildMetadata()
    {
        let parser = SemanticVersionParser(versionString: "1.4.3-beta+")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 11, "failure loaction should be 11")
            XCTAssert(failedComponent == SemanticVersionParser.Component.BuildMetadataIdentifier(nil), "should have failed on parsing BuildMetadataIdentifier")
            XCTAssert(count(parsedComponents) == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch)")
                case .PrereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong count of prerelease identifier")
                    XCTAssert(contains(identifier!,"beta"), "metadata ifentifier should contain 'beta'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }

        XCTAssert(true, "Pass")
    }
    
    func testParserFailWithPrereleaseVersionEmptyBuildMetadataIdentifier()
    {
        let parser = SemanticVersionParser(versionString: "1.4.3-beta+test1..test2")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 17, "failure loaction should be 11")
            XCTAssert(failedComponent == SemanticVersionParser.Component.BuildMetadataIdentifier(nil), "should have failed on parsing BuildMetadataIdentifier")
            XCTAssert(count(parsedComponents) == 5, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch)")
                case .PrereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong count of prerelease identifier")
                    XCTAssert(contains(identifier!,"beta"), "prerelease ifentifier should contain 'beta'")
                case .BuildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong count of buildmetadata identifier")
                    XCTAssert(contains(identifier!,"test1"), "metadata ifentifier should contain 'test1'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }
    
    func testParserFailWithPrereleaseVersionEndsWithDelimeter()
    {
        let parser = SemanticVersionParser(versionString: "1.4.3-beta.")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 11, "failure loaction should be 11")
            XCTAssert(failedComponent == SemanticVersionParser.Component.PrereleaseIdentifier(nil), "should have failed on parsing PrereleaseIdentifier")
            XCTAssert(count(parsedComponents) == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch)")
                case .PrereleaseIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong count of prerelease identifier")
                    XCTAssert(contains(identifier!,"beta"), "prerelease ifentifier should contain 'beta'")
                case .BuildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong count of buildmetadata identifier")
                    XCTAssert(contains(identifier!,"test1"), "metadata ifentifier should contain 'test1'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }


    func testParserFailWithBuildMetadataEndsWithDelimeter()
    {
        let parser = SemanticVersionParser(versionString: "1.4.3+meta.")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 11, "failure loaction should be 11")
            XCTAssert(failedComponent == SemanticVersionParser.Component.BuildMetadataIdentifier(nil), "should have failed on parsing BuildMetadataIdentifier")
            XCTAssert(count(parsedComponents) == 4, "should have parsed 4 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 4, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch)")
                case .BuildMetadataIdentifier(let identifier):
                    XCTAssertNotNil(identifier, "identifier must not be nil")
                    XCTAssertEqual(count(identifier!), 1, "wrong count of buildmetadata identifier")
                    XCTAssert(contains(identifier!,"meta"), "metadata ifentifier should contain 'meta'")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }


    
    // MARK: Malformed
    

    func testParserWithMalformedMajorVersionA()
    {
        let parser = SemanticVersionParser(versionString: "+1.2.3")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 0, "failure loaction should be 0")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Major(nil), "should have failed on parsing Major")
            XCTAssert(count(parsedComponents) == 0, "should have parsed 0 components")
            for component in parsedComponents
            {
                switch component {
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }
    
    func testParserWithMalformedMajorVersionB()
    {
        let parser = SemanticVersionParser(versionString: "1b.2.3")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 1, "failure loaction should be 1")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Major(nil), "should have failed on parsing Major")
            XCTAssert(count(parsedComponents) == 1, "should have parsed 1 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }

    func testParserWithMalformedMinorVersionA()
    {
        let parser = SemanticVersionParser(versionString: "1.-2.3")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 2, "failure loaction should be 2")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Minor(nil), "should have failed on parsing Minor")
            XCTAssert(count(parsedComponents) == 1, "should have parsed 1 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }

    func testParserWithMalformedMinorVersionB()
    {
        let parser = SemanticVersionParser(versionString: "1.2b.3")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 3, "failure loaction should be 3")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Minor(nil), "should have failed on parsing Minor")
            XCTAssert(count(parsedComponents) == 2, "should have parsed 1 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 2, "wrong minor version \(minor)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }
    
    func testParserWithMalformedPatchVersionA()
    {
        let parser = SemanticVersionParser(versionString: "1.2.patch3")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 4, "failure loaction should be 4")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Patch(nil), "should have failed on parsing Minor")
            XCTAssert(count(parsedComponents) == 2, "should have parsed 1 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong minor version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 2, "wrong minor version \(minor)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }

    func testParserWithMalformedPatchVersionB()
    {
        let parser = SemanticVersionParser(versionString: "1.2.3alpha")
        let result = parser.parse()
        
        switch result {
        case .Success(_):
            XCTFail("parser should fail")
        case .Failure(let location, let failedComponent, let parsedComponents):
            XCTAssertEqual(location, 5, "failure loaction should be 5")
            XCTAssert(failedComponent == SemanticVersionParser.Component.Patch(nil), "should have failed on parsing Patch")
            XCTAssert(count(parsedComponents) == 3, "should have parsed 1 components")
            for component in parsedComponents
            {
                switch component {
                case .Major(let major):
                    XCTAssertEqual(major ?? -1, 1, "wrong major version \(major)")
                case .Minor(let minor):
                    XCTAssertEqual(minor ?? -1, 2, "wrong minor version \(minor)")
                case .Patch(let patch):
                    XCTAssertEqual(patch ?? -1, 3, "wrong patch version \(patch)")
                default:
                    XCTFail("unexpected component parsed")
                }
            }
        }
        
        XCTAssert(true, "Pass")
    }

    // MARK: Comparsion
    
    func testComparsionOfVersionFromStrings()
    {
        let versions: [SemanticVersion] = ["1.0.0", "2.0.0", "2.1.0", "2.1.1"]
        
        var previousVersion: SemanticVersion?
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
        let versions: [SemanticVersion] = ["1.0.0-alpha", "1.0.0-alpha.1", "1.0.0-alpha.beta", "1.0.0-beta", "1.0.0-beta.2", "1.0.0-beta.11", "1.0.0-rc.1", "1.0.0"]
        
        var previousVersion: SemanticVersion?
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
        self.measureBlock() {
            for i in 0...1000
            {
                for versionString in parseVersions
                {
                    let version: SemanticVersion = SemanticVersion(stringLiteral: versionString)
                }
            }
        }
    }

}