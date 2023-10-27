//
//  MetalViewHelper.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-20.
//

import Foundation
import Cocoa
import simd

struct UniformsFrame {
    init() {
        projectionMatrix = simd_float4x4(1.0)
        frameColor = simd_float3(1.0, 0.5, 0.0)
    }
    var projectionMatrix:simd_float4x4
    var frameColor:simd_float3
}

struct UniformsRender {
    init() {
        projectionMatrix = simd_float4x4(1.0)
    }
    var projectionMatrix:simd_float4x4
}

struct UniformsRenderToTexture {
    init() {
        projectionMatrix = simd_float4x4(1.0)
        gain = 4.0
        pn = (1 - 1 / gain) * 0.5
        contrast = 0.0
        brightness = 0.0
        backColor = simd_float3(1.0, 1.0, 1.0)
        foreColor = simd_float3(0.0, 0.0, 0.0)
        artificial = false
        grayscale = false
        reflineWidth = 0.01
        reflinePosition = 0
        reflineType = 0
        reflineColor = simd_float3(0.0, 0.0, 0.0)
    }
    var projectionMatrix:simd_float4x4
    var backColor:simd_float3
    var gain:simd_float1
    var foreColor:simd_float3
    var pn:simd_float1
    var brightness:simd_float1
    var contrast:simd_float1
    var artificial:simd_bool
    var grayscale:simd_bool
    var reflineWidth:simd_float1
    var reflinePosition:simd_float1
    var reflineType:simd_int1
    var reflineColor:simd_float3
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
    
    func createTexture(size : CGSize) -> MTLTexture
    {
        let textureDescriptor = MTLTextureDescriptor()

        textureDescriptor.pixelFormat = .bgra8Unorm
        textureDescriptor.textureType = .type2D
        // Set the pixel dimensions of the texture
        textureDescriptor.width = Int(size.width)
        textureDescriptor.height = Int(size.height)

        //textureDescriptor.usage = MTLTextureUsage(rawValue: MTLTextureUsage.shaderWrite)
        
        let texture = mDevice.makeTexture(descriptor: textureDescriptor)
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
    
    func createRenderToTexturePipeline() -> MTLRenderPipelineState
    {
        let vertexProgram = mLibrary?.makeFunction(name: "render_to_texture_vertex")!
        
        let fragmentProgram = mLibrary?.makeFunction(name: "render_to_texture_fragment")!
        fragmentProgram!.label = "render to texture"
        
        let fragmentPipeline = createPipeline(vertex: vertexProgram!, fragment: fragmentProgram!)!
        
        return fragmentPipeline
    }
    
    func createFramePipeline() -> MTLRenderPipelineState
    {
        let vertexProgram = mLibrary?.makeFunction(name: "color_vertex")!
        vertexProgram!.label = "vertex"
        
        
        let colorProgram = mLibrary?.makeFunction(name: "color_fragment")!
        colorProgram!.label = "color"
        
        let colorPipeline = createPipeline(vertex: vertexProgram!, fragment: colorProgram!)!
        
        return colorPipeline
    }
    
    func createRenderTexture(width : Int, height : Int, count : Int) -> ([MTLTexture], MTLRenderPassDescriptor)
    {
        let textureDescriptor = MTLTextureDescriptor();

        // Indicate that each pixel has a blue, green, red, and alpha channel, where each channel is
        // an 8-bit unsigned normalized value (i.e. 0 maps to 0.0 and 255 maps to 1.0)
        //textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
        textureDescriptor.pixelFormat = .bgra8Unorm
        textureDescriptor.textureType = .type2D
        // Set the pixel dimensions of the texture
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.usage = MTLTextureUsage(rawValue: MTLTextureUsage.renderTarget.rawValue | MTLTextureUsage.shaderRead.rawValue)

        var textures = [MTLTexture]()
        
        for _ in 0..<count 
        {
            textures.append(mDevice.makeTexture(descriptor: textureDescriptor)!)
        }
        // Create the texture from the device by using the descriptor
        
        var renderToTextureRenderPassDescriptor = MTLRenderPassDescriptor()
        renderToTextureRenderPassDescriptor.colorAttachments[0].texture = textures[0]
        
        renderToTextureRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1)

        renderToTextureRenderPassDescriptor.colorAttachments[0].storeAction = .store
        
        return (textures, renderToTextureRenderPassDescriptor)
    }
    
    func createFrame(aWidth : Float, aHeight : Float, aFrameThickness : Float) -> (MTLBuffer, MTLBuffer)
    {
        let frameData = createFramePositions(width: aWidth, height: aHeight, thickness: aFrameThickness)

//        let frameData = createFramePositionsTest(width: aWidth, height: aHeight)

        // Layout memory and set up vertex buffers
        var dataSize = frameData.count * MemoryLayout<Float>.stride
        var framePositionsBuffer = mDevice.makeBuffer(bytes: frameData, length: dataSize, options: [])
//        framePositionsBuffer?.label = "vertices"
        print("CREATE frame")
        
        let frameIndices = createFrameIndices()
        
        dataSize = frameIndices.count * MemoryLayout<UInt32>.stride
        var frameIndexBuffer = mDevice.makeBuffer(bytes: frameIndices, length: dataSize, options: [])
//        frameIndexBuffer?.label = "indices"
        print("CREATE indices")

        return (framePositionsBuffer!, frameIndexBuffer!)
    }
    
    func createRenderTexture(width : Int, height : Int) -> (MTLTexture, MTLRenderPassDescriptor)
    {
        let textureDescriptor = MTLTextureDescriptor();

        // Indicate that each pixel has a blue, green, red, and alpha channel, where each channel is
        // an 8-bit unsigned normalized value (i.e. 0 maps to 0.0 and 255 maps to 1.0)
        //textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
        textureDescriptor.pixelFormat = .bgra8Unorm
        textureDescriptor.textureType = .type2D
        // Set the pixel dimensions of the texture
        textureDescriptor.width = width
        textureDescriptor.height = height
        textureDescriptor.usage = MTLTextureUsage(rawValue: MTLTextureUsage.renderTarget.rawValue | MTLTextureUsage.shaderRead.rawValue)

        // Create the texture from the device by using the descriptor
        var renderTargetTexture = mDevice.makeTexture(descriptor: textureDescriptor);
        
        var renderToTextureRenderPassDescriptor = MTLRenderPassDescriptor()
        renderToTextureRenderPassDescriptor.colorAttachments[0].texture = renderTargetTexture
        
        renderToTextureRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1)

        renderToTextureRenderPassDescriptor.colorAttachments[0].storeAction = .store
        
        return (renderTargetTexture!, renderToTextureRenderPassDescriptor)
    }
    
    
}
