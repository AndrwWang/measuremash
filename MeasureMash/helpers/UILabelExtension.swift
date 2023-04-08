//
//  UILabelExtension.swift
//  MeasureMash
//
//  Created by Frank Gao on 4/7/23.
//

import UIKit

extension UILabel {
    func setFontSize(_ size: Double) {
        self.font =  UIFont(name: self.font.fontName, size: size)!
        sizeToFit()
    }
}
