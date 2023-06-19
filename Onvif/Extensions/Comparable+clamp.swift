//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-22.
//

import Foundation

extension Comparable
{
    func clamp<T: Comparable>(_ lower: T, _ upper: T) -> T {
        return min(max(self as! T, lower), upper)
    }
}
