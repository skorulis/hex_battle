//
//  Color+Extensions.swift
//  HexColor
//
//  Created by Alexander Skorulis on 9/3/21.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct RGB {
    let red: Double
    let green: Double
    let blue: Double
    
    static var zero: RGB {
        return RGB(red: 0, green: 0, blue: 0)
    }
    
    var normalized: RGB {
        let length = sqrt( (red * red) + (green * green) + (blue * blue) )
        return RGB(red: red/length, green: green/length, blue: blue/length)
    }
}

extension Color {
    
    static func mixed(colors: [Color]) -> Color {
        let rgbs = colors.map { $0.rgb }
        let combined = rgbs.reduce(RGB.zero) { (result, rgb) -> RGB in
            return RGB(red: result.red + rgb.red, green: result.green + rgb.green, blue: result.blue + rgb.blue)
        }
        
        let normal = combined.normalized
        return Color(.sRGB, red: normal.red, green: normal.green, blue: normal.blue, opacity: 1)
    }
    
    var rgb: RGB {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif
        
        let native = NativeColor(self)

        let r: CGFloat = native.redComponent
        let g: CGFloat = native.greenComponent
        let b: CGFloat = native.blueComponent
                    
        return RGB(red: Double(r), green: Double(g), blue: Double(b))
    }
    
    static func from(rgb: Int) -> Color {
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        return Color(RGBColorSpace.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
    
}
