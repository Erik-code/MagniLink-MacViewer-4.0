//
//  OCR.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

import Foundation
import AVFoundation
import Photos


class OCR : NSObject
{
    let ocrQueue = DispatchQueue(label: "lvi.ocr.queue")
    
    var ocrBitmap : OcrBitmap
    var ocrSettings = OcrSettings()
    
    override init()
    {
        ocrBitmap = OcrBitmap(settings: ocrSettings)
        
        super.init()
        OcrBase.initializeOcr()
    }
    
    func perform(image : NSImage, append : Bool, recognize : Bool = true)
    {
        ocrQueue.async { [self] in
            var ocrArguments = OcrArgument()
            ocrArguments.image = image
            ocrArguments.recognize = true
            
            ocrBitmap.performOCRImage(ocrArguments)
        }
    }
    
    func perform(file : NSString)
    {
        
    }
    
    func quit()
    {
        
    }
    
    var hasQuit : Bool {
        get{
            return false
        }
    }
}
