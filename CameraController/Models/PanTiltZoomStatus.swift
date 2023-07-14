//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-26.
//

import Foundation

@objcMembers public class PanTiltZoomStatus : NSObject {
    public private(set) var isPanningOrTilting: Bool
    public private(set) var isZooming: Bool
    public private(set) var x: Float
    public private(set) var y: Float
    public private(set) var zoom: Float
    
    private override init() {
        self.isPanningOrTilting = false
        self.isZooming = false
        self.x = 0
        self.y = 0
        self.zoom = 0
        
        super.init()
    }
    
    public convenience init(isPanningOrTilting: Bool, isZooming: Bool, x: Float, y: Float, zoom: Float) {
        self.init()
        
        self.isPanningOrTilting = isPanningOrTilting
        self.isZooming = isZooming
        self.x = x
        self.y = y
        self.zoom = zoom
    }
}
