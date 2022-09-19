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
    
    static func getRGBDelta(_ firstColor: UIColor, _ secondColor: UIColor) -> (CGFloat, CGFloat, CGFloat) {
        let firstRGB = firstColor.getRGB()
        let secondRGB = secondColor.getRGB()
        
        return (firstRGB.0 - secondRGB.0, firstRGB.1 - secondRGB.1, firstRGB.2 - secondRGB.2)
    }
    
    
    func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        guard let cpms = cgColor.components else {
            fatalError("rgb")
        }
        return (cpms[0] * 255, cpms[1] * 255, cpms[2] * 255)
    }
}
