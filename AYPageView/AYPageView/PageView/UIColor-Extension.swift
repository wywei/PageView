//
//  UIColor-Extension.swift
//  AYPageView
//
//  Created by Andy on 2022/9/18.
//

import UIKit

extension UIColor {
    
   convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green:  g / 255.0, blue:  b / 255.0, alpha: a)
    }
    
    static func arc4randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
}
