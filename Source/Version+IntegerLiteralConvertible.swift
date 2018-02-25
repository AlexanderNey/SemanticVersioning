//
//  Versionin+IntegerLiteralConvertible.swift
//  SemanticVersioning
//
//  Created by Alexander Ney on 12/04/2015.
//  Copyright (c) 2015 Alexander Ney. All rights reserved.
//

import Foundation
import Darwin

extension Version {
    public func floatValue() -> Float {
        let minorLenght = self.minor > 0 ? floor(log10(Float(self.minor)) + 1.0) : 0
        let minorSummand = Float(self.minor) / 10.0 * minorLenght

        return Float(self.major) + minorSummand
    }
}

extension Version: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(major: max(0, value))
    }

}
