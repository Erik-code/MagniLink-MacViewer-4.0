//
//  Extension.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Foundation
import simd
import Cocoa
import GLKit
import SwiftUI

extension NSView {
    typealias AnimationCompletion = () -> Void
    
    static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void, completion: AnimationCompletion? = nil) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            animations()
            
        }, completionHandler: {
            completion?()
        })
    }
}

extension String {
    
    var length: Int {
        return count
    }

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String? {
        
        guard r.startIndex >= 0 && r.endIndex <= length else {
            return nil
        }
        
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func beginsWith(_ string : String) -> Bool
    {
        if string.count > count {
            return false
        }
        
        return substring(to: string.count) == string
        
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

extension simd_float4x4 {
    init(matrix: GLKMatrix4) {
        self.init(columns: (float4(x: matrix.m00, y: matrix.m01, z: matrix.m02, w: matrix.m03),
                            float4(x: matrix.m10, y: matrix.m11, z: matrix.m12, w: matrix.m13),
                            float4(x: matrix.m20, y: matrix.m21, z: matrix.m22, w: matrix.m23),
                            float4(x: matrix.m30, y: matrix.m31, z: matrix.m32, w: matrix.m33)))
    }
}

extension Color {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    init(color : Int){
        
        let blue : Double = Double(color & 0xFF) / 0xFF
        let green : Double = Double((color >> 8) & 0xFF) / 0xFF
        let red : Double = Double((color >> 16) & 0xFF) / 0xFF

        self.init(red: red, green: green, blue: blue)
    }
    
    init(fromMagnilink : UInt32){
        
        let blue : Double = Double(fromMagnilink >> 24) / 0xFF
        let green : Double = Double((fromMagnilink >> 16) & 0xFF) / 0xFF
        let red : Double = Double((fromMagnilink >> 8) & 0xFF) / 0xFF

        self.init(red: red, green: green, blue: blue)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {

        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o)
        
        return (r, g, b, o)
    }
    
    var intValue : Int
    {
        get
        {
            let blue = Int(components.blue * 255)
            let green = Int(components.green * 255)
            let red = Int(components.red * 255)

            return red << 16 | green << 8 | blue
        }
    }
    
    var magiLinkValue : UInt32
    {
        get
        {
            let blue = Int(components.blue * 255)
            let green = Int(components.green * 255)
            let red = Int(components.red * 255)

            return UInt32(blue << 24 | green << 16 | red << 8)
        }
    }
}

extension Character
{
    var isEndOfSentence : Bool
    {
        get{
            return self == "." || self == "?" || self == "!"
        }
    }
}

extension NSColor
{
    convenience init(_ color : Color)
    {
        self.init(red: color.components.red, green: color.components.green, blue: color.components.blue, alpha: 1.0)
//        self.init(red: color.components.red, green: color.components.green, blue: color.components.blue)
    }
}
