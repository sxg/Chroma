//
//  UIColor+Chroma.swift
//  Chroma
//
//  Created by Satyam Ghodasara on 2/4/16.
//  Copyright © 2016 Satyam Ghodasara. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(fromColor color: UIColor, saturation: Float) {
        var h: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getHue(&h, saturation: nil, brightness: &b, alpha: &a)
        
        self.init(hue: h, saturation: CGFloat(saturation), brightness: b, alpha: a)
    }
    
    public func isBlackOrWhite() -> Bool {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (r > 0.91 && g > 0.91 && b > 0.91) || (r < 0.09 && g < 0.09 && b < 0.09) {
            return true
        } else {
            return false
        }
    }
    
    public func isDark() -> Bool {
        return self.luminance() < 0.5 ? true : false
    }
    
    public func luminance() -> Float {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return Float(0.2126 * r + 0.7152 * g + 0.0722 * b)
    }
    
    public func isDistinct(from color: UIColor) -> Bool {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        var ro: CGFloat = 0
        var go: CGFloat = 0
        var bo: CGFloat = 0
        var ao: CGFloat = 0
        let threshold: CGFloat = 0.25
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        color.getRed(&ro, green: &go, blue: &bo, alpha: &ao)
        
        let rDiff: CGFloat = fabs(r - ro)
        let gDiff: CGFloat = fabs(g - go)
        let bDiff: CGFloat = fabs(b - bo)
        let aDiff: CGFloat = fabs(a - ao)
        
        if rDiff > threshold || gDiff > threshold || bDiff > threshold || aDiff > threshold {
            //  Check for grays
            if fabs(r - g) < 0.03 && fabs(r - b) < 0.03 && fabs(ro - go) < 0.03 && fabs(ro - bo) < 0.03 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
}
