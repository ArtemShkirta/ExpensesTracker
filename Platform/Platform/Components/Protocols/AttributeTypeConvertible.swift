//
//  AttributeTypeConvertible.swift
//  Platform
//
//  Created by Artem Shkirta on 05.09.2021.
//

import enum CoreData.NSAttributeType

public protocol AttributeTypeConvertible {
  static var attributeType: NSAttributeType { get }
}

extension Int64: AttributeTypeConvertible { public static var attributeType: NSAttributeType { .integer64AttributeType } }
extension Int32: AttributeTypeConvertible { public static var attributeType: NSAttributeType { .integer32AttributeType } }
extension Int16: AttributeTypeConvertible { public static var attributeType: NSAttributeType { .integer16AttributeType } }
extension Decimal: AttributeTypeConvertible { public static var attributeType: NSAttributeType { .decimalAttributeType } }
extension Double: AttributeTypeConvertible { public static var attributeType: NSAttributeType { .doubleAttributeType } }
extension Date: AttributeTypeConvertible { public static var attributeType: NSAttributeType { .dateAttributeType } }
extension NSDate: AttributeTypeConvertible { public static var attributeType: NSAttributeType { .dateAttributeType } }
extension Float: AttributeTypeConvertible { public static var attributeType: NSAttributeType { .floatAttributeType } }
extension NSDecimalNumber: AttributeTypeConvertible { public static var attributeType: NSAttributeType { .decimalAttributeType } }
