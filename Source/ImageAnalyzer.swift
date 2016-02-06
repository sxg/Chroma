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
    public let textColors: Array<UIColor>
    
    public init(image: UIImage) {
        self.image = image
        self.colors = ImageAnalyzer.colorsFor(image: self.image)
        self.backgroundColor = ImageAnalyzer.backgroundColorFor(colors: self.colors)
        self.textColors = ImageAnalyzer.textColorsFor(colors: self.colors, backgroundColor: self.backgroundColor)
    }
    
    private static func colorsFor(image image: UIImage) -> Array<UIColor> {
        var colors = [UIColor]()
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        for x in 0..<Int(image.size.width) {
            for y in 0..<Int(image.size.height) {
                
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
            if backgroundColor.isBlackOrWhite() {
                if Float(colorCounts[backgroundColor]!) / Float(colorCounts[color]!) > 0.3 && !color.isBlackOrWhite() {
                    backgroundColor = color
                    break
                }
            }
        }
        
        return backgroundColor
    }
    
    private static func textColorsFor(colors colors: Array<UIColor>, backgroundColor: UIColor) -> Array<UIColor> {
        var textColors = [UIColor]()
        var colorCounts = [UIColor: Int]()
        let findDark = !backgroundColor.isDark()
        
        for aColor in colors {
            let color = UIColor(fromColor: aColor, saturation: 0.15)
            
            if color.isDark() == findDark {
                if let colorCount = colorCounts[color] {
                    colorCounts[color] = colorCount + 1
                } else {
                    colorCounts[color] = 1
                }
            }
        }
        
        let sortedColors = colorCounts.keys.sort {
            return colorCounts[$0] > colorCounts[$1]
        }
        
        for color in sortedColors {
            if textColors.count == 0 {
                if color.isContrasting(on: backgroundColor) {
                    textColors.append(color)
                }
            } else if textColors.count == 1 {
                let primaryColor = textColors[0]
                if primaryColor.isDistinct(from: color) && color.isContrasting(on: backgroundColor) {
                    textColors.append(color)
                }
            } else if textColors.count == 2 {
                let primaryColor = textColors[0]
                let secondaryColor = textColors[1]
                if secondaryColor.isDistinct(from: color) && primaryColor.isDistinct(from: color) && color.isContrasting(on: backgroundColor) {
                    textColors.append(color)
                    return textColors
                }
            }
        }
        
        return textColors
    }
    
}
