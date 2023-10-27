//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation
import SWXMLHash

public struct VideoEncoderConfigurationOptions : XMLObjectDeserialization {
    public let qualityRange: IntRange
    public let h264: H264Options?
    public let videoEncoderOptionsExtension: VideoEncoderOptionsExtension?
    
    public static func deserialize(_ node: XMLIndexer) throws -> VideoEncoderConfigurationOptions {
        return try VideoEncoderConfigurationOptions(
            qualityRange: node["QualityRange"].value(),
            h264: node["H264"].value(),
            videoEncoderOptionsExtension: node["Extension"].value()
        )
    }
}


/*
 
 <Envelope>
    <Body>
       <GetVideoEncoderConfigurationOptionsResponse>
          <Options>
             <QualityRange>
                <Min>0</Min>
                <Max>5</Max>
             </QualityRange>
             <H264>
                <ResolutionsAvailable>
                   <Width>1280</Width>
                   <Height>720</Height>
                </ResolutionsAvailable>
                <ResolutionsAvailable>
                   <Width>1280</Width>
                   <Height>960</Height>
                </ResolutionsAvailable>
                <ResolutionsAvailable>
                   <Width>1920</Width>
                   <Height>1080</Height>
                </ResolutionsAvailable>
                <GovLengthRange>
                   <Min>1</Min>
                   <Max>400</Max>
                </GovLengthRange>
                <FrameRateRange>
                   <Min>1</Min>
                   <Max>60</Max>
                </FrameRateRange>
                <EncodingIntervalRange>
                   <Min>1</Min>
                   <Max>1</Max>
                </EncodingIntervalRange>
                <H264ProfilesSupported>Baseline</H264ProfilesSupported>
                <H264ProfilesSupported>Main</H264ProfilesSupported>
                <H264ProfilesSupported>High</H264ProfilesSupported>
             </H264>
             <Extension>
                <H264>
                   <ResolutionsAvailable>
                      <Width>1280</Width>
                      <Height>720</Height>
                   </ResolutionsAvailable>
                   <ResolutionsAvailable>
                      <Width>1280</Width>
                      <Height>960</Height>
                   </ResolutionsAvailable>
                   <ResolutionsAvailable>
                      <Width>1920</Width>
                      <Height>1080</Height>
                   </ResolutionsAvailable>
                   <GovLengthRange>
                      <Min>1</Min>
                      <Max>400</Max>
                   </GovLengthRange>
                   <FrameRateRange>
                      <Min>1</Min>
                      <Max>60</Max>
                   </FrameRateRange>
                   <EncodingIntervalRange>
                      <Min>1</Min>
                      <Max>1</Max>
                   </EncodingIntervalRange>
                   <H264ProfilesSupported>Baseline</H264ProfilesSupported>
                   <H264ProfilesSupported>Main</H264ProfilesSupported>
                   <H264ProfilesSupported>High</H264ProfilesSupported>
                   <BitrateRange>
                      <Min>32</Min>
                      <Max>16384</Max>
                   </BitrateRange>
                </H264>
             </Extension>
          </Options>
       </GetVideoEncoderConfigurationOptionsResponse>
    </Body>
 </Envelope>
 
 */
