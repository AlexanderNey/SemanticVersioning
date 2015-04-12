//
//  Versionin+NumberLiteralConvertible.swift
//  SemanticVersioning
//
//  Created by Alexander Ney on 12/04/2015.
//  Copyright (c) 2015 Alexander Ney. All rights reserved.
//

import Foundation


extension Version : IntegerLiteralConvertible
{
    public init(integerLiteral value: IntegerLiteralType)
    {
        value < 0 ? self.init(major: 0) : self.init(major: value)
    }
}

extension Version : FloatLiteralConvertible
{
    private static let MaxMinorVersionPrecision = 5

    public init(floatLiteral value: FloatLiteralType)
    {
        /* Converts the float literal to a String first and splits the fraction digits form the integer ones
         * This imporves precision but is not the fastest implementation
         */
        let formatter = NSNumberFormatter()
        formatter.groupingSeparator = nil
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = Version.MaxMinorVersionPrecision
        
        if let stringValue = formatter.stringFromNumber(NSNumber(double: value)),
               valueComponents = split(stringValue, isSeparator: { $0 == "."}) as [String]?,
               integer = valueComponents.first?.toInt()
            where value > 0
        {
            var restFraction = 0
            if let fraction = valueComponents.last?.toInt() where count(valueComponents) > 1
            {
                restFraction = fraction
            }
            
            self.init(major: Int(integer), minor: restFraction)
        }
        else
        {
            self.init(major: 0)
        }
    }
}