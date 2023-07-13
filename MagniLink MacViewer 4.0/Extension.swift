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
