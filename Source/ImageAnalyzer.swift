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
    
    public init(image: UIImage) {
        self.image = image
        self.colors = ImageAnalyzer.colorsFor(image: image)
    }
    
    private static func colorsFor(image image: UIImage) -> Array<UIColor> {
        var colors: Array<UIColor> = []
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        for x in 0..<Int(image.size.width) {
            for y in 0..<Int(image.size.height) {
                
                let pixel: Int = ((Int(image.size.width) * y) + x) * 4
                
                let r = CGFloat(data[pixel]) / CGFloat(255.0)
                let g = CGFloat(data[pixel + 1]) / CGFloat(255.0)
                let b = CGFloat(data[pixel + 2]) / CGFloat(255.0)
                let a = CGFloat(data[pixel + 3]) / CGFloat(255.0)

                colors.append(UIColor(red: r, green: g, blue: b, alpha: a))
            }
        }
        
        return colors
    }
    
}
