//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-22.
//

import Foundation

struct PanTiltZoomDirections : OptionSet {
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }

    static let Left = PanTiltZoomDirections(rawValue: 1)
    static let Right = PanTiltZoomDirections(rawValue: 2)
    static let Up = PanTiltZoomDirections(rawValue: 4)
    static let Down = PanTiltZoomDirections(rawValue: 8)
    static let In = PanTiltZoomDirections(rawValue: 16)
    static let Out = PanTiltZoomDirections(rawValue: 32)
}
