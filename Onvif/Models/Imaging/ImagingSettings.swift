//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation
import SWXMLHash

public struct ImagingSettings : XMLIndexerDeserializable {
    public let brightness: Float?
    public let saturation: Float?
    public let contrast: Float?
    public let sharpness: Float?
    public let focus: FocusConfiguration?
    public let imagingSettingsExtension: ImagingSettingsExtension?
    
    public static func deserialize(_ node: XMLIndexer) throws -> ImagingSettings {
        return try ImagingSettings(
            brightness: node["Brightness"].value(),
            saturation: node["ColorSaturation"].value(),
            contrast: node["Contrast"].value(),
            sharpness: node["Sharpness"].value(),
            focus: node["Focus"].value(),
            imagingSettingsExtension: node["Extension"].value()
        )
    }
}



/*
 <?xml version="1.0" encoding="UTF-8"?>
 <Envelope>
    <Body>
       <GetImagingSettingsResponse>
          <ImagingSettings>
             <BacklightCompensation>
                <Mode>OFF</Mode>
             </BacklightCompensation>
             <Brightness>50</Brightness>
             <ColorSaturation>50</ColorSaturation>
             <Contrast>50</Contrast>
             <Exposure>
                <Mode>AUTO</Mode>
                <MinExposureTime>33</MinExposureTime>
                <MaxExposureTime>33333</MaxExposureTime>
                <MinGain>0</MinGain>
                <MaxGain>0</MaxGain>
                <MinIris>-22</MinIris>
                <MaxIris>0</MaxIris>
             </Exposure>
             <Focus>
                <AutoFocusMode>AUTO</AutoFocusMode>
                <NearLimit>10</NearLimit>
                <FarLimit>0</FarLimit>
             </Focus>
             <IrCutFilter>AUTO</IrCutFilter>
             <Sharpness>50</Sharpness>
             <WideDynamicRange>
                <Mode>OFF</Mode>
             </WideDynamicRange>
             <WhiteBalance>
                <Mode>AUTO</Mode>
             </WhiteBalance>
             <Extension>
                <ImageStabilization>
                   <Mode>OFF</Mode>
                </ImageStabilization>
                <Extension>
                   <Extension>
                      <Defogging>
                         <Mode>OFF</Mode>
                      </Defogging>
                      <NoiseReduction>
                         <Level>0.500000</Level>
                      </NoiseReduction>
                   </Extension>
                </Extension>
             </Extension>
          </ImagingSettings>
       </GetImagingSettingsResponse>
    </Body>
 </Envelope>
 */
