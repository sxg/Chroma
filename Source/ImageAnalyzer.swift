//
//  ImageAnalyzer.swift
//  Chroma
//
//  Created by Satyam Ghodasara on 1/31/16.
//  Copyright © 2016 Satyam Ghodasara. All rights reserved.
//

import UIKit

public class ImageAnalyzer {
    
    public let image: UIImage
    public let colors: Array<UIColor>
    public let backgroundColor: UIColor
    
    public init(image: UIImage) {
        self.image = image
        self.colors = ImageAnalyzer.colorsFor(image: self.image)
        self.backgroundColor = ImageAnalyzer.backgroundColorFor(colors: self.colors)
    }
    
    private static func colorsFor(image image: UIImage) -> Array<UIColor> {
        var colors = [UIColor]()
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        for x in 0..<Int(image.size.width) {
            for y in 0..<1 {//<Int(image.size.height) {
                
                let pixel: Int = ((Int(image.size.width) * y) + x) * 4
                
                let r = round(100 * CGFloat(data[pixel]) / CGFloat(255.0)) / 100
                let g = round(100 * CGFloat(data[pixel + 1]) / CGFloat(255.0)) / 100
                let b = round(100 * CGFloat(data[pixel + 2]) / CGFloat(255.0)) / 100
                let a = round (100 * CGFloat(data[pixel + 3]) / CGFloat(255.0)) / 100

                colors.append(UIColor(red: r, green: g, blue: b, alpha: a))
            }
        }
        
        return colors
    }
    
    private static func backgroundColorFor(colors colors: Array<UIColor>) -> UIColor {
        var colorCounts = [UIColor: Int]()
        
        for color in colors {
            if let colorCount = colorCounts[color] {
                colorCounts[color] = colorCount + 1
            } else {
                colorCounts[color] = 1
            }
        }
        
        let sortedColors = colorCounts.keys.sort {
            return colorCounts[$0] > colorCounts[$1]
        }
        
        var backgroundColor = sortedColors.first!
        for color in sortedColors {
            if ImageAnalyzer.isBlackOrWhite(color: backgroundColor) {
                if Float(colorCounts[backgroundColor]!) / Float(colorCounts[color]!) > 0.3 && !ImageAnalyzer.isBlackOrWhite(color: color) {
                    backgroundColor = color
                    break
                }
            }
        }
        
        return backgroundColor
    }
    
    private static func isBlackOrWhite(color color: UIColor) -> Bool {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (r > 0.91 && g > 0.91 && b > 0.91) || (r < 0.09 && g < 0.09 && b < 0.09) {
            return true
        } else {
            return false
        }
    }
    
    private static func isDark(color color: UIColor) -> Bool {
        return luminance(color: color) < 0.5 ? true : false
    }
    
    private static func luminance(color color: UIColor) -> Float {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return Float(0.2126 * r + 0.7152 * g + 0.0722 * b)
    }
    
}
