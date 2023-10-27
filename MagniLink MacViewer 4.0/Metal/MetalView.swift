//
//  MetalView.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-20.
//

import Foundation
import MetalKit
import AVFoundation
import GLKit
import simd
import SwiftUI

protocol MetalViewDelegate {
    func recordImage(texture: MTLTexture)
}

class MetalView: MTKView
{
    let semaphore = DispatchSemaphore(value: 1)
    
    private var mAngle : Float = 0.0
    private var mScale : Float = 1.0
    private var mMirror : Float = 1.0
    private var mZoom : Float = 1.0
    private var mPan : CGPoint = CGPoint(x: 0, y: 0)
    
    private var pixelBuffer: CVPixelBuffer?
    private var mVideoStruct : VideoStruct?
    private var mTextureCache: CVMetalTextureCache?
    
    private var mUniformsRender = UniformsRender()
    private var mUniformBufferRender: MTLBuffer! = nil
    private var mVertexBuffer: MTLBuffer! = nil
    private var mRenderPipeline: MTLRenderPipelineState! = nil

    private var mUniformsRenderToTexture = UniformsRenderToTexture()
    private var mRenderToTextureRenderPassDescriptor : MTLRenderPassDescriptor! = nil
    //private var mRenderTargetTexture : MTLTexture! = nil
    private var mRenderTargetTextures = [MTLTexture]()
    private var mRenderTargetTexturesIndex = 0

    private var mUniformBufferRenderToTexture: MTLBuffer! = nil
    private var mRenderToTexturePipeline : MTLRenderPipelineState! = nil

    private var mFramePipeline: MTLRenderPipelineState! = nil
    private var framePositionsBuffer: MTLBuffer! = nil
    private var frameIndexBuffer: MTLBuffer! = nil
    private let mFrameThickness: Float = 10
    private var mUniformBufferFrame: MTLBuffer! = nil
    private var mUniformsFrame = UniformsFrame()
    
    private var mCommandQueue: MTLCommandQueue! = nil
    public var mLibrary: MTLLibrary?
    private var mMetalViewHelper : MetalViewHelper?
    
    private var mVideoWidth : Int = 1280;
    private var mVideoHeight : Int = 720;
    var inputTexture : MTLTexture?
    
    var myDelegate: MetalViewDelegate?
    var mDrawFrame = false;
    
    var mLastFrameTime : Date = Date.now
    var mFrameArrived = false
    private var mRecordImage: NSImageView! = nil
    private var mIsRecording = false
    
    func setup()
    {
        device = MTLCreateSystemDefaultDevice()
        guard let device = self.device else {
            fatalError("Unable to initialize GPU device")
        }
        mMetalViewHelper = MetalViewHelper(view: self, device: device)
        mTextureCache = mMetalViewHelper?.createTextureCache()
        
        //mUniformsRender = UniformsRender()
        
        loadAssets()
        
        (mRenderTargetTextures, mRenderToTextureRenderPassDescriptor) = mMetalViewHelper!.createRenderTexture(width: mVideoWidth, height: mVideoHeight, count: 4)
        
        (framePositionsBuffer, frameIndexBuffer) = mMetalViewHelper!.createFrame(aWidth: Float(mVideoWidth)*0.5, aHeight: Float(mVideoHeight)*0.5, aFrameThickness: mFrameThickness)
        
        framebufferOnly = false
        colorPixelFormat = .bgra8Unorm
    }
    
    func loadAssets()
    {
        guard let device = device else {
            return
        }
        
        (mCommandQueue, mLibrary) = mMetalViewHelper!.createCommandQueueAndLibrary()
        
        mRenderPipeline = mMetalViewHelper?.createRenderPipeline()
        
        mUniformBufferRender = device.makeBuffer(length: MemoryLayout<UniformsRender>.stride, options: [])
        mUniformBufferRender.label = "uniforms"

        mRenderToTexturePipeline = mMetalViewHelper?.createRenderToTexturePipeline()
        mUniformBufferRenderToTexture = device.makeBuffer(length: MemoryLayout<UniformsRenderToTexture>.stride, options: [])
        mUniformBufferRenderToTexture.label = "uniforms"

        mFramePipeline = mMetalViewHelper?.createFramePipeline()
        mUniformBufferFrame = device.makeBuffer(length: MemoryLayout<UniformsFrame>.stride, options: [])
        mUniformBufferFrame.label = "frameUniforms"
        
        mVertexBuffer = mMetalViewHelper?.createVertexBuffer(width: CGFloat(mVideoWidth), height: CGFloat(mVideoHeight))
        
        updateUniforms()
    }
    
    func updateUniforms()
    {
        updateUniformsRender()
        updateUniformsRenderToTexture()
        updateUniformsFrame()
    }
    
    func updateUniformsRender()
    {
        let size = self.bounds.size
        print("size: \(size)")
        
        let screenSize = NSScreen.screens.first?.frame.size
        
        let ortho = makeOrthographicMatrix(left: -Float(size.width), right: Float(size.width), bottom: -Float(size.height), top: Float(size.height), near: -1.0, far: 1.0)
        
        let ident = GLKMatrix4Identity
        
        let scaleM = GLKMatrix4Scale(ident, mScale, mScale, 1.0)
        print("mScale: \(mScale)")
        
        let scaleMatrix = simd_float4x4(matrix: scaleM)
                
        let rotmat = GLKMatrix4Rotate(ident, 0.0 , 0.0, 0.0, -1.0)
        let rotationMatrix = simd_float4x4.init(matrix: rotmat)
        
        mUniformsRender.projectionMatrix = ortho * scaleMatrix * rotationMatrix
        
        let uniforms = [mUniformsRender]
        memcpy(mUniformBufferRender.contents(), uniforms, MemoryLayout<UniformsRender>.size)
    }
    
    func updateUniformsRenderToTexture()
    {
        let ortho = makeOrthographicMatrix(left: -Float(mVideoWidth), right: Float(mVideoWidth), bottom: -Float(mVideoHeight), top: Float(mVideoHeight), near: -1.0, far: 1.0)
        
        let ident = GLKMatrix4Identity
        
        let rotmat = GLKMatrix4Rotate(ident, mAngle, 0.0, 0.0, -1.0)
        
        let scale = GLKMatrix4Scale(ident, mZoom * mMirror, mZoom, 1.0)
        
        let scaleMatrix = simd_float4x4(matrix: scale)
        
        let scaleL = calculateScale(screenSize: bounds.size, windowSize: bounds.size, videoSize: simd_float2(x: Float(mVideoWidth), y: Float(mVideoHeight)) , isLandscape: true, letterBox: true)
                
        let translate = GLKMatrix4Translate(ident, Float(mPan.x), Float(mPan.y), 0);
        
        let imageSize = CGSize(width: CGFloat(mVideoWidth), height: CGFloat(mVideoHeight))
        
        let translationMatrix2 = simd_float4x4.init(matrix: translate)
                
        let modelViewMatrix = simd_float4x4.init(diagonal: simd_float4(scaleL * mZoom, scaleL * mZoom, 1.0, 1.0));
        
        let result = ortho * translationMatrix2 * modelViewMatrix
        
//        let left : Float = -1.0 - (mAngleCorrection * 4.0)
//        let right : Float = 1.0 - (mAngleCorrection * 4.0)
//        let bottom : Float = -1.0 - (mAngleCorrection * 2.0)
//        let top : Float = 1.0 - (mAngleCorrection * 2.0)
//
//        let near : Float = 1.0 + (mAngleCorrection * 2.0)
//        let far : Float = 3.0
        
//        let frustum = GLKMatrix4MakeFrustum(left, right, bottom, top, near, far)
        
//        let look = GLKMatrix4MakeLookAt(0, 0, 1.0, 0, 0, 0, 0, 1.0, 0)

//        let rotationX = GLKMatrix4MakeXRotation(mAngleCorrection * 0.5)
        
//        let frustumMatrix = simd_float4x4.init(matrix: frustum)
        
//        let lookMatrix = simd_float4x4.init(matrix: look)
        
//        let rotationXMatrix = simd_float4x4.init(matrix: rotationX)
        
//        let resultMatrix = rotationXMatrix * lookMatrix * frustumMatrix
                
        let rotationMatrix = simd_float4x4.init(matrix: rotmat)
        
        //if mAngleCorrection != 0 {
        //    mUniformsRenderToTexture.projectionMatrix = resultMatrix * scaleMatrix * rotationMatrix
        //}
        //else {
            mUniformsRenderToTexture.projectionMatrix = ortho * translationMatrix2 * scaleMatrix * rotationMatrix
        //}
        let uniforms = [mUniformsRenderToTexture]
        memcpy(mUniformBufferRenderToTexture.contents(), uniforms, MemoryLayout<UniformsRenderToTexture>.stride)
    }
    
    func updateUniformsFrame()
    {
        let size = self.bounds.size
        
        if(framePositionsBuffer != nil){
            let frameData = createFramePositions(width: Float(size.width), height: Float(size.height), thickness: mFrameThickness)

            let dataSize = frameData.count * MemoryLayout<Float>.stride
            memcpy(framePositionsBuffer.contents(), frameData, dataSize)
        }
        
        let ortho = makeOrthographicMatrix(left: -Float(size.width), right: Float(size.width), bottom: -Float(size.height), top: Float(size.height), near: -1.0, far: 1.0)
        
        mUniformsFrame.projectionMatrix = ortho
        
        let uniforms = [mUniformsFrame]
        memcpy(mUniformBufferFrame.contents(), uniforms, MemoryLayout<UniformsFrame>.size)
    }
    
    func setPixelBuffer(pixelBuffer : CVPixelBuffer!)
    {
        //return
        semaphore.wait()
        self.pixelBuffer = pixelBuffer
        guard let pixelBuffer = self.pixelBuffer else {
            return
        }
        
        inputTexture = mMetalViewHelper?.createTextureFromBuffer(buffer: pixelBuffer)
                
        semaphore.signal()
    }
    
    func setVideoStruct(aVideo : VideoStruct)
    {
//        semaphore.wait()
        mFrameArrived = true
        mLastFrameTime = Date.now
        
        mVideoStruct = aVideo
        inputTexture = mMetalViewHelper?.createTextureFromStruct(aVideo: aVideo)
        
//        DispatchQueue.main.async {
//            self.setNeedsDisplay()
//        }
    }
    
    override func draw(_ rect: NSRect) {
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        autoreleasepool {
            if !rect.isEmpty {
                
                guard
                    var texture = inputTexture,
                    let device = device,
                    let commandBuffer = mCommandQueue?.makeCommandBuffer()
                else {
                    _ = semaphore.signal()
                    return
                }
                
                self.render()
            }
        }
    }
    
    private func render()
    {
        let commandBuffer = mCommandQueue.makeCommandBuffer()
        commandBuffer!.label = "Frame command buffer"

        guard let inputTexture = self.inputTexture else {
            semaphore.signal()
            return
        }
        
        guard let drawable: CAMetalDrawable = self.currentDrawable else
        {
            semaphore.signal()
            fatalError("Failed to create drawable")
        }
        
        if let renderPassDescriptor = self.mRenderToTextureRenderPassDescriptor
        {
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
            renderPassDescriptor.colorAttachments[0].texture = mRenderTargetTextures[mRenderTargetTexturesIndex]
            
            if let renderEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            {
                renderEncoder.label = "Offscreen Render Pass"
                renderEncoder.setRenderPipelineState(mRenderToTexturePipeline)
                renderEncoder.setVertexBuffer(mVertexBuffer, offset: 0, index: 0)
                renderEncoder.setVertexBuffer(mUniformBufferRenderToTexture, offset: 0, index: 1)
                renderEncoder.setFragmentBuffer(mUniformBufferRenderToTexture, offset: 0, index: 1)
                renderEncoder.setFragmentTexture(inputTexture, index:0);
                renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
                renderEncoder.endEncoding()
            }
        }
        
        if mIsRecording {
            myDelegate?.recordImage(texture: mRenderTargetTextures[mRenderTargetTexturesIndex])
        }
        
        if let renderPassDescriptor = self.currentRenderPassDescriptor
        {
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
            
            if let renderEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            {
                renderEncoder.label = "render encoder"
                renderEncoder.pushDebugGroup("draw")
                renderEncoder.setRenderPipelineState(mRenderPipeline)

                renderEncoder.setVertexBuffer(mVertexBuffer, offset: 0, index: 0)
                renderEncoder.setVertexBuffer(mUniformBufferRender, offset:0, index: 1)

                renderEncoder.setFragmentTexture(mRenderTargetTextures[mRenderTargetTexturesIndex], index:0)
                renderEncoder.setFragmentBuffer(mUniformBufferRender, offset: 0, index: 1)

                renderEncoder.drawPrimitives(type: .triangle,                                                          vertexStart: 0,                                                                              vertexCount: 6)
                
                if(mDrawFrame){
                    renderEncoder.setRenderPipelineState(mFramePipeline)

                    renderEncoder.setVertexBuffer(framePositionsBuffer, offset: 0,
                        index: 0)
                    renderEncoder.setVertexBuffer(mUniformBufferFrame, offset:0, index: 1)

                    renderEncoder.setFragmentBuffer(mUniformBufferFrame, offset:0, index: 0)

                    //renderEncoder.drawPrimitives(type: .triangle,                                                          vertexStart: 0,                                                                              vertexCount: 3)
                    renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: 24, indexType: .uint32, indexBuffer: frameIndexBuffer, indexBufferOffset: 0)
                }
                
                renderEncoder.popDebugGroup()
                renderEncoder.endEncoding()
            }
            commandBuffer?.addScheduledHandler({ [weak self] (buffer) in
                guard let unwrappedSelf = self else { return }
                unwrappedSelf.semaphore.signal()
            })
            
            commandBuffer!.present(drawable)
        }
        commandBuffer!.commit()
        self.inputTexture = nil
        mRenderTargetTexturesIndex = (mRenderTargetTexturesIndex + 1) % mRenderTargetTextures.count
    }
    
    func toggleRecording(/*audioSettings : [String : Any]?*/)
    {
        //mRecordImage.isHidden = !mRecordImage.isHidden
        mIsRecording = !mIsRecording
    }
    
    func setNatural(grayscale : Bool)
    {
        mUniformsRenderToTexture.grayscale = grayscale
        mUniformsRenderToTexture.artificial = false
        mUniformsRenderToTexture.reflineColor = simd_float3(x: 0.0, y: 0.0, z: 0.0)
        updateUniforms()
    }
    
    func setArtificial(backColor : Color, foreColor : Color)
    {
        mUniformsRenderToTexture.artificial = true
        mUniformsRenderToTexture.foreColor = simd_float3(Float(foreColor.components.red),Float(foreColor.components.green),Float(foreColor.components.blue))
        mUniformsRenderToTexture.backColor = simd_float3(Float(backColor.components.red),Float(backColor.components.green),Float(backColor.components.blue))
        mUniformsRenderToTexture.reflineColor = mUniformsRenderToTexture.foreColor
        updateUniforms()
    }
    
    func calculateScale(screenSize : CGSize, windowSize: CGSize, videoSize: simd_float2, isLandscape : Bool, letterBox : Bool ) -> Float
    {
        if(letterBox)
        {
            if isLandscape {
                return min(Float(windowSize.width) / videoSize.x, Float(windowSize.height) / videoSize.y);
            }
            else {
                return min(Float(windowSize.width) / videoSize.y, Float(windowSize.height) / videoSize.x);
            }
        }
        else
        {
            if isLandscape
            {
                return max(Float(screenSize.width) / videoSize.x, Float(screenSize.height) / videoSize.y);
            }
            else
            {
                return max(Float(screenSize.width) / videoSize.y, Float(screenSize.height) / videoSize.x);
            }
        }
    }
    
    override var acceptsFirstResponder: Bool
    {
        get{
            return true
        }
    }
    
    override func keyDown(with event: NSEvent) {
        print("Metal KeyDown")
        super.keyDown(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        print("Metal KeyUp")
        super.keyUp(with: event)
    }
    
}
