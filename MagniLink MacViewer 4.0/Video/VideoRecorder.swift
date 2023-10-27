//
//  VideoRecorder.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-26.
//

import Foundation
import AVFoundation
import Photos

class VideoRecorder {
    var isRecording = false
    var recordingStartTime = TimeInterval(0)

    private var assetWriter: AVAssetWriter
    private var assetWriterVideoInput: AVAssetWriterInput
    private var assetWriterPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor
    
    private var assetWriterAudioInput: AVAssetWriterInput?
    private var videoTransform: CGAffineTransform
    
    var mRecordAudio = false
    private var mAudioSettings : [String: Any]? = nil
    var hasReceivedAudioBuffer = false
        
    init?(outputURL url: URL, size: CGSize, audioSettings : [String : Any]?, transform : CGAffineTransform) {
        do {
            videoTransform = transform
            assetWriter = try AVAssetWriter(outputURL: url, fileType: .mov)
        } catch {
            return nil
        }

        let outputSettings: [String: Any] = [ AVVideoCodecKey : AVVideoCodecType.hevc,
            AVVideoWidthKey : size.width,
            AVVideoHeightKey : size.height ]

        assetWriterVideoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: outputSettings)
        assetWriterVideoInput.expectsMediaDataInRealTime = true
        assetWriterVideoInput.transform = transform

        let sourcePixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as String : size.width,
            kCVPixelBufferHeightKey as String : size.height ]
        
        assetWriterPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: assetWriterVideoInput,                             sourcePixelBufferAttributes: sourcePixelBufferAttributes)

        if audioSettings != nil {
            mAudioSettings = audioSettings!
            mRecordAudio = true
            assetWriterAudioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: mAudioSettings)
            assetWriterAudioInput?.expectsMediaDataInRealTime = true
            assetWriter.add(assetWriterAudioInput!)
        }
        
        assetWriter.add(assetWriterVideoInput)
    }

    func startRecording(startTime : CMTime) {
        if isRecording == false
        {
            assetWriter.startWriting()
            assetWriter.startSession(atSourceTime: startTime)
            
            recordingStartTime = CACurrentMediaTime()
            isRecording = true
        }
    }

    func endRecording(_ completionHandler: @escaping () -> ()) {
        isRecording = false

        assetWriterVideoInput.markAsFinished()
        assetWriter.finishWriting {
            if self.assetWriter.status != .failed && self.assetWriter.status == .completed
            {
                completionHandler()
                print("completed")
            }
            else
            {
                print("error \(String(describing: self.assetWriter.error))")
            }
        }
    }
    
    func deepCopyPixelBuffer(_ sourcePixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        // Get pixel buffer attributes from the source buffer
        let width = CVPixelBufferGetWidth(sourcePixelBuffer)
        let height = CVPixelBufferGetHeight(sourcePixelBuffer)
        let pixelFormat = CVPixelBufferGetPixelFormatType(sourcePixelBuffer)
        
        // Create a pixel buffer options dictionary (if any)
        let options: NSDictionary = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ]
        
        // Create a new pixel buffer
        var destinationPixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(nil, width, height, pixelFormat, options, &destinationPixelBuffer)
        
        // Check if pixel buffer creation was successful
        guard status == kCVReturnSuccess, let destinationPixelBuffer = destinationPixelBuffer else {
            print("Error: Failed to create destination pixel buffer")
            return nil
        }
        
        // Lock the base address of the source and destination pixel buffers
        CVPixelBufferLockBaseAddress(sourcePixelBuffer, .readOnly)
        CVPixelBufferLockBaseAddress(destinationPixelBuffer, [])

        // Get the base addresses of the source and destination pixel buffers
        if let srcBaseAddress = CVPixelBufferGetBaseAddress(sourcePixelBuffer),
           let dstBaseAddress = CVPixelBufferGetBaseAddress(destinationPixelBuffer) {
            // Calculate bytes per row for both buffers
            let srcBytesPerRow = CVPixelBufferGetBytesPerRow(sourcePixelBuffer)
            let dstBytesPerRow = CVPixelBufferGetBytesPerRow(destinationPixelBuffer)
            
            // Copy the pixel data from the source buffer to the destination buffer
            for y in 0..<height {
                memcpy(dstBaseAddress.advanced(by: y * dstBytesPerRow),
                       srcBaseAddress.advanced(by: y * srcBytesPerRow),
                       srcBytesPerRow)
            }
        }
        
        // Unlock the base addresses of the source and destination pixel buffers
        CVPixelBufferUnlockBaseAddress(sourcePixelBuffer, .readOnly)
        CVPixelBufferUnlockBaseAddress(destinationPixelBuffer, [])
        
        return destinationPixelBuffer
    }

    func writeFrame(forTexture texture: MTLTexture, time : CMTime) {
        if !isRecording {
            return
        }

        while !assetWriterVideoInput.isReadyForMoreMediaData {}

        var maybePixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(texture.width), Int(texture.height), kCVPixelFormatType_32BGRA, nil, &maybePixelBuffer)
        
//        let status  = CVPixelBufferPoolCreatePixelBuffer(nil, pixelBufferPool, &maybePixelBuffer)
        if status != kCVReturnSuccess {
            print("Could not get pixel buffer from asset writer input; dropping frame...")
            return
        }

        guard let pixelBuffer = maybePixelBuffer else { return }

        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        let pixelBufferBytes = CVPixelBufferGetBaseAddress(pixelBuffer)!

        // Use the bytes per row value from the pixel buffer since its stride may be rounded up to be 16-byte aligned
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)

        texture.getBytes(pixelBufferBytes, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
   
        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])

        assetWriterPixelBufferInput.append(pixelBuffer, withPresentationTime: time)
    }
    
    func recordAudio(sampleBuffer: CMSampleBuffer)
    {
        self.hasReceivedAudioBuffer = true
        guard isRecording && mRecordAudio,
        
            self.assetWriter.status == .writing,
            let input = assetWriterAudioInput,
            input.isReadyForMoreMediaData else {
                return
        }
        input.append(sampleBuffer)
    }
}
