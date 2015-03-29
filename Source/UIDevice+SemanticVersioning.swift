//
//  UIDevice+SemanticVersioning.swift
//  SemanticVersioning
//
//  Created by Alexander Ney on 29/03/2015.
//  Copyright (c) 2015 Alexander Ney. All rights reserved.
//

#if os(iOS)
    
import Foundation
import UIKit

    
public extension UIDevice
{
    public var systemSemanticVersion: Version { return Version(self.systemVersion) }
}

#endif
