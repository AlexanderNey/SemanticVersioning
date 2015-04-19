//
//  SemanticVersioning+NSOperatingSystemVersion.swift
//  SemanticVersioning
//
//  Created by Alexander Ney on 29/03/2015.
//  Copyright (c) 2015 Alexander Ney. All rights reserved.
//

import Foundation


extension NSOperatingSystemVersion: SemanticVersion
{
    public var major: Int { return self.majorVersion }
    public var minor: Int { return self.minorVersion }
    public var patch: Int { return self.patchVersion }
    public var preReleaseIdentifier: [String] { return [] }
    public var buildMetadataIdentifier: [String] { return [] }
    public var isPrerelease: Bool { return false }

}

