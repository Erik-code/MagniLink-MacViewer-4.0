//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-26.
//

import Foundation

internal extension PTZStatus {
    func toPanTiltZoomStatus() -> PanTiltZoomStatus {
        let isPanningOrTilting = self.moveStatus?.panTilt == "MOVING"
        let isZooming = self.moveStatus?.zoom == "MOVING"
        
        let x = self.position?.panTilt.x ?? 0
        let y = self.position?.panTilt.y ?? 0
        let zoom = self.position?.zoom.x ?? 0
        
        return PanTiltZoomStatus(isPanningOrTilting: isPanningOrTilting, isZooming: isZooming, x: x, y: y, zoom: zoom)
    }
}
