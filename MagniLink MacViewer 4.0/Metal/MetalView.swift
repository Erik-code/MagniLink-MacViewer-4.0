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

class MetalView: MTKView
{
    let semaphore = DispatchSemaphore(value: 1)
    
    private var pixelBuffer: CVPixelBuffer?
    
    private var mVideoStruct : VideoStruct?
    
    private var mTextureCache: CVMetalTextureCache?
    private var mUniformsRender = UniformsRender()
    private var mCommandQueue: MTLCommandQueue! = nil
    public var mLibrary: MTLLibrary?
    private var mMetalViewHelper : MetalViewHelper?
    private var mScale : Float = 1.0
    private var mUniformBufferRender: MTLBuffer! = nil
    private var mVertexBuffer: MTLBuffer! = nil
    private var mVideoWidth : Int = 1280;
    private var mVideoHeight : Int = 720;
    private var mRenderPipeline: MTLRenderPipelineState! = nil
    var inputTexture : MTLTexture?
    
    var mLastFrameTime : Date = Date.now
    var mFrameArrived = false
    
    func setup()
    {
        device = MTLCreateSystemDefaultDevice()
        guard let device = self.device else {
            fatalError("Unable to initialize GPU device")
        }
        mMetalViewHelper = MetalViewHelper(view: self, device: device)
        mTextureCache = mMetalViewHelper?.createTextureCache()
        
        mUniformsRender = UniformsRender()
        
        loadAssets()
        
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

        mVertexBuffer = mMetalViewHelper?.createVertexBuffer(width: CGFloat(mVideoWidth), height: CGFloat(mVideoHeight))
        
        updateUniforms()
    }
    
    func updateUniforms()
    {
        updateUniformsRender()
    }
    
    func updateUniformsRender()
    {
        let size = self.bounds.size
        print("size: \(size)")
        
        let screenSize = NSScreen.screens.first?.frame.size
        
        let ortho = makeOrthographicMatrix(left: -Float(size.width), right: Float(size.width), bottom: -Float(size.height), top: Float(size.height), near: -1.0, far: 1.0)
        
        let ident = GLKMatrix4Identity
        
//        let scale = calculateScale(ipadSize: screenSize, windowSize: size, videoSize: simd_float2(Float(mVideoWidth), Float(mVideoHeight)), isLandscape: true, letterBox: mWhole)
//
        
        let scaleM = GLKMatrix4Scale(ident, mScale, mScale, 1.0)
        print("mScale: \(mScale)")
        
        let scaleMatrix = simd_float4x4(matrix: scaleM)
                
        let rotmat = GLKMatrix4Rotate(ident, 0.0 , 0.0, 0.0, -1.0)
        let rotationMatrix = simd_float4x4.init(matrix: rotmat)
        
        mUniformsRender.projectionMatrix = ortho * scaleMatrix * rotationMatrix
        
        let uniforms = [mUniformsRender]
        memcpy(mUniformBufferRender.contents(), uniforms, MemoryLayout<UniformsRender>.size)
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

//        if let renderPassDescriptor = self.mRenderToTextureRenderPassDescriptor
//        {
//            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
//            renderPassDescriptor.colorAttachments[0].loadAction = .clear
//
//            if let renderEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
//            {
//                renderEncoder.label = "Offscreen Render Pass"
//                renderEncoder.setRenderPipelineState(mRenderToTexturePipeline)
//                renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
//                renderEncoder.setVertexBuffer(mUniformBufferRenderToTexture, offset: 0, index: 1)
//                renderEncoder.setFragmentBuffer(mUniformBufferRenderToTexture, offset: 0, index: 1)
//                renderEncoder.setFragmentTexture(inputTexture, index:0);
//                renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
//                renderEncoder.endEncoding()
//            }
//        }
//
//        if mRecordImage.isHidden == false {
//            myDelegate?.recordImage(texture: mRenderTargetTexture)
//        }
        
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

                renderEncoder.setFragmentTexture(inputTexture, index:0)
                renderEncoder.setFragmentBuffer(mUniformBufferRender, offset: 0, index: 1)

                renderEncoder.drawPrimitives(type: .triangle,                                                          vertexStart: 0,                                                                              vertexCount: 6)
                                
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
    }
    
    func setNatural(grayscale : Bool)
    {
        //mUniformsRenderToTexture.grayscale = grayscale
        //mUniformsRenderToTexture.artificial = false
        //mUniformsRenderToTexture.reflineColor = simd_float3(x: 0.0, y: 0.0, z: 0.0)
        updateUniforms()
    }
    
    func setArtificial(backColor : Color, foreColor : Color)
    {
//        mUniformsRenderToTexture.artificial = true
//        mUniformsRenderToTexture.foreColor = simd_float3(Float(foreColor.components.red),Float(foreColor.components.green),Float(foreColor.components.blue))
//        mUniformsRenderToTexture.backColor = simd_float3(Float(backColor.components.red),Float(backColor.components.green),Float(backColor.components.blue))
//        mUniformsRenderToTexture.reflineColor = mUniformsRenderToTexture.foreColor
        updateUniforms()
    }
}
