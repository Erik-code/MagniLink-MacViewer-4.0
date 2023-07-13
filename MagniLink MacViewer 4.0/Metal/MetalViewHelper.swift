//
//  MetalViewHelper.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-20.
//

import Foundation
import Cocoa
import simd

struct UniformsRender {
    init() {
        projectionMatrix = simd_float4x4(1.0)
    }
    var projectionMatrix:simd_float4x4
}

class MetalViewHelper
{
    private var mView : MetalView
    private var mDevice : MTLDevice
    private var mLibrary : MTLLibrary?
    private var mTextureCache: CVMetalTextureCache?
    
    init(view : MetalView, device : MTLDevice)
    {
        mView = view
        mDevice = device
    }
    
    func createTextureCache() -> CVMetalTextureCache?
    {
        var textCache: CVMetalTextureCache?
        if CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, mDevice, nil, &textCache) != kCVReturnSuccess {
            fatalError("Unable to allocate texture cache.")
        }
        mTextureCache = textCache
        return textCache
    }
    
    func createTextureFromStruct(aVideo : VideoStruct) -> MTLTexture
    {
        let textureDescriptor = MTLTextureDescriptor()

        textureDescriptor.pixelFormat = MTLPixelFormat.bgra8Unorm

        textureDescriptor.width = Int(aVideo.width)
        textureDescriptor.height = Int(aVideo.height)

        let texture = mDevice.makeTexture(descriptor: textureDescriptor)

        let region = MTLRegion(origin: MTLOrigin(x: 0, y: 0, z: 0), size: MTLSize(width: textureDescriptor.width, height: textureDescriptor.height, depth: 1))

        texture?.replace(region: region, mipmapLevel: 0, withBytes: aVideo.data, bytesPerRow: Int(aVideo.stride))

        return texture!
    }
    
    func createTextureFromBuffer(buffer : CVPixelBuffer) -> MTLTexture
    {
        var cvTextureOut: CVMetalTexture?
        let width = CVPixelBufferGetWidth(buffer)
        let height = CVPixelBufferGetHeight(buffer)
        
        let ret = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, mTextureCache!, buffer, nil, .bgra8Unorm, width, height, 0, &cvTextureOut)
        
        //print("ret \(ret)")
        
        guard let cvTexture = cvTextureOut else {
            fatalError("Failed to create metal textures")
        }
        
        let texture = CVMetalTextureGetTexture(cvTexture)
        
        return texture!
    }
    
    func createPipeline(vertex : MTLFunction, fragment : MTLFunction) -> MTLRenderPipelineState?
    {
        var result : MTLRenderPipelineState
        
        // Create render pipeline descriptor
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertex
        pipelineStateDescriptor.fragmentFunction = fragment
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.mView.colorPixelFormat
        pipelineStateDescriptor.sampleCount = self.mView.sampleCount
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true;
        pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add;
        pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add;
        pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha;
        pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha;
        pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha;
        pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha;
        
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].format = MTLVertexFormat.float2 // position
        vertexDescriptor.attributes[1].offset = 8
        vertexDescriptor.attributes[1].format = MTLVertexFormat.float2 // texCoord
        vertexDescriptor.layouts[0].stride = 16
        
        pipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        pipelineStateDescriptor.label = fragment.label

        do {
            try result = mDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
            return result
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
        }
        
        return nil;
    }
    
    func createCommandQueueAndLibrary() -> (MTLCommandQueue, MTLLibrary)
    {
        let commandQueue = mDevice.makeCommandQueue()
        commandQueue?.label = "main command queue"

        // Create library for project
        mLibrary = mDevice.makeDefaultLibrary()!
        
        return (commandQueue!, mLibrary!)
    }
    
    func createVertexBuffer(width : CGFloat, height : CGFloat) -> MTLBuffer
    {
        let data = createSquareData(size: CGSize(width: width, height: height))
        
        let dataSize = data.count * MemoryLayout<Float>.size
        let vertexBuffer = mDevice.makeBuffer(bytes: data, length: dataSize, options: [])
        vertexBuffer!.label = "vertices"
        
        return vertexBuffer!
    }
    
    func createRenderPipeline() -> MTLRenderPipelineState
    {
        let vertexProgram = mLibrary?.makeFunction(name: "render_vertex")!
        
        let fragmentProgram = mLibrary?.makeFunction(name: "render_fragment")!
        fragmentProgram!.label = "natural"
        
        let renderPipeline = createPipeline(vertex: vertexProgram!, fragment: fragmentProgram!)!
        
        return renderPipeline
    }
    
    
}
