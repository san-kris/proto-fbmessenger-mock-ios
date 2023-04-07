//
//  ColorTransformer.swift
//  proto-fbmessenger-mock-ios
//
//  Created by Santosh Krishnamurthy on 4/6/23.
//

import UIKit

class ColorTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
            [UIColor.self]
        }

        static func register() {
            let className = String(describing: ColorTransformer.self)
            let name = NSValueTransformerName(className)

            let transformer = ColorTransformer()
            ValueTransformer.setValueTransformer(
                transformer, forName: name)
        }
}
