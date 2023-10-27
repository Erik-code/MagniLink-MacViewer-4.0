//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation
import SWXMLHash

public struct ImagingOptions : XMLObjectDeserialization {
    public let brightness: FloatRange?
    public let saturation: FloatRange?
    public let contrast: FloatRange?
    public let sharpness: FloatRange?
    public let focus: FocusOptions?
    
    public static func deserialize(_ node: XMLIndexer) throws -> ImagingOptions {
        return try ImagingOptions(
            brightness: node["Brightness"].value(),
            saturation: node["ColorSaturation"].value(),
            contrast: node["Contrast"].value(),
            sharpness: node["Sharpness"].value(),
            focus: node["Focus"].value()
        )
    }
}

/*
 <?xml version="1.0" encoding="UTF-8"?>
 <Envelope>
    <Body>
       <GetOptionsResponse>
          <ImagingOptions>
             <BacklightCompensation>
                <Mode>OFF</Mode>
                <Mode>ON</Mode>
             </BacklightCompensation>
             <Brightness>
                <Min>0</Min>
                <Max>100</Max>
             </Brightness>
             <ColorSaturation>
                <Min>0</Min>
                <Max>100</Max>
             </ColorSaturation>
             <Contrast>
                <Min>0</Min>
                <Max>100</Max>
             </Contrast>
             <Exposure>
                <Mode>MANUAL</Mode>
                <Mode>AUTO</Mode>
                <MinExposureTime>
                   <Min>33</Min>
                   <Max>33</Max>
                </MinExposureTime>
                <MaxExposureTime>
                   <Min>33333</Min>
                   <Max>33333</Max>
                </MaxExposureTime>
                <MinGain>
                   <Min>0</Min>
                   <Max>0</Max>
                </MinGain>
                <MaxGain>
                   <Min>0</Min>
                   <Max>100</Max>
                </MaxGain>
                <MinIris>
                   <Min>-22</Min>
                   <Max>-22</Max>
                </MinIris>
                <MaxIris>
                   <Min>0</Min>
                   <Max>0</Max>
                </MaxIris>
                <ExposureTime>
                   <Min>33</Min>
                   <Max>33333</Max>
                </ExposureTime>
                <Gain>
                   <Min>0</Min>
                   <Max>100</Max>
                </Gain>
                <Iris>
                   <Min>-22</Min>
                   <Max>0</Max>
                </Iris>
             </Exposure>
             <Focus>
                <AutoFocusModes>AUTO</AutoFocusModes>
                <AutoFocusModes>MANUAL</AutoFocusModes>
                <DefaultSpeed>
                   <Min>1</Min>
                   <Max>1</Max>
                </DefaultSpeed>
                <NearLimit>
                   <Min>10</Min>
                   <Max>2000</Max>
                </NearLimit>
                <FarLimit>
                   <Min>0</Min>
                   <Max>0</Max>
                </FarLimit>
             </Focus>
             <IrCutFilterModes>ON</IrCutFilterModes>
             <IrCutFilterModes>OFF</IrCutFilterModes>
             <IrCutFilterModes>AUTO</IrCutFilterModes>
             <Sharpness>
                <Min>0</Min>
                <Max>100</Max>
             </Sharpness>
             <WideDynamicRange>
                <Mode>ON</Mode>
                <Mode>OFF</Mode>
                <Level>
                   <Min>0</Min>
                   <Max>100</Max>
                </Level>
             </WideDynamicRange>
             <WhiteBalance>
                <Mode>AUTO</Mode>
                <Mode>MANUAL</Mode>
                <YrGain>
                   <Min>0</Min>
                   <Max>255</Max>
                </YrGain>
                <YbGain>
                   <Min>0</Min>
                   <Max>255</Max>
                </YbGain>
             </WhiteBalance>
             <Extension>
                <ImageStabilization>
                   <Mode>ON</Mode>
                   <Mode>OFF</Mode>
                </ImageStabilization>
                <Extension>
                   <Extension>
                      <DefoggingOptions>
                         <Mode>OFF</Mode>
                         <Mode>ON</Mode>
                         <Level>false</Level>
                      </DefoggingOptions>
                      <NoiseReductionOptions>
                         <Level>true</Level>
                      </NoiseReductionOptions>
                   </Extension>
                </Extension>
             </Extension>
          </ImagingOptions>
       </GetOptionsResponse>
    </Body>
 </Envelope>
 */
