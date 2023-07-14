//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation

internal extension ImagingOptions {
    func toCameraSettings(imagingSettings: ImagingSettings, moveOptions: MoveOptions) -> CameraSettings {
        let brightness = FloatSetting(value: imagingSettings.brightness ?? 0, min: self.brightness?.min ?? 0, max: self.brightness?.max ?? 0)
        
        let contrast = FloatSetting(value: imagingSettings.contrast ?? 0, min: self.contrast?.min ?? 0, max: self.contrast?.max ?? 0)
        
        let saturation = FloatSetting(value: imagingSettings.saturation ?? 0, min: self.saturation?.min ?? 0, max: self.saturation?.max ?? 0);
        
        let sharpness = FloatSetting(value: imagingSettings.sharpness ?? 0, min: self.sharpness?.min ?? 0, max: self.sharpness?.max ?? 0)
        
        let focus = FocusSetting(focusMode: imagingSettings.focus?.focusMode ?? "AUTO", supportedFocusModes: self.focus?.focusModes ?? [String](), minSpeed: moveOptions.continuous?.speed.min ?? 0, maxSpeed: moveOptions.continuous?.speed.max ?? 0)
        
        return CameraSettings(brightness: brightness, contrast: contrast, saturation: saturation, sharpness: sharpness, focus: focus)
    }
}
