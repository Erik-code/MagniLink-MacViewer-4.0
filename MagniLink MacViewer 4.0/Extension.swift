//
//  Extension.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Foundation

import Cocoa

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