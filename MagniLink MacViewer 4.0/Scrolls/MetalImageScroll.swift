//
//  MetalImageScroll.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

import Foundation
import MetalKit
import simd
import GLKit

struct UniformsScroll
{
    init() {
        gain = 4.0
        pn = (1 - 1 / gain) * 0.5
        contrast = 1.0
        brightness = 0.0
        backColor = simd_float3(1.0, 1.0, 1.0)
        foreColor = simd_float3(0.0, 0.0, 0.0)
        artificial = true
        grayscale = false
        projectionMatrix = simd_float4x4(1.0)
        frameColor = simd_float3(1.0, 0.5, 0.0)
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
    var frameColor:simd_float3
}

protocol MetalImageScrollDelegate
{
    func valueChanged(text : String)
    func wordTouched(position : Int)
}

class MetalImageScroll: MTKView
{
    private var commandQueue: MTLCommandQueue! = nil
    public var mLibrary: MTLLibrary?
    
    private var vertexBuffer: MTLBuffer! = nil
    private var vertexBufferBlocks: MTLBuffer! = nil
    private var indexBufferblocks: MTLBuffer! = nil
    private var indexBufferLength = 0

    private var vertexBufferSelected: MTLBuffer! = nil
    private var mSelectedCount = 0

    private var uniformBuffer: MTLBuffer! = nil

    private var uniform = UniformsScroll()
    private var uniformFrame = UniformsFrame()
    private var inputTexture : MTLTexture?
    private var mTextureCache: CVMetalTextureCache?
    //private var mPage : OCRPage?
    
    private var mNaturalPipeline: MTLRenderPipelineState! = nil
    private var mColorPipeline: MTLRenderPipelineState! = nil
    private var mFrameUniformBuffer: MTLBuffer! = nil
    
    var metalDelegate : MetalImageScrollDelegate?
    
    var mZoom : Float = 1.0
    var mPan : CGPoint = CGPoint(x: 0, y: 0)
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        
        super.init(frame: frameRect, device: device)
        setup()
    }
    
    required init(coder: NSCoder) {
        
        super.init(coder: coder)
        setup()
    }
    
    func setup()
    {
        device = MTLCreateSystemDefaultDevice()
        
        guard let device = self.device else {
            fatalError("Unable to initialize GPU device")
        }
        
        var textCache: CVMetalTextureCache?
        if CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &textCache) != kCVReturnSuccess {
            fatalError("Unable to allocate texture cache.")
        }
        else {
            mTextureCache = textCache
        }
        
        isPaused = true
        enableSetNeedsDisplay = true
        
        clearColor = MTLClearColor.init(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        uniform = UniformsScroll()
        
        uniformFrame = UniformsFrame()
        
        framebufferOnly = false
                
        loadAssets()
    }
    
    func loadAssets()
    {
        guard let device = device else {
            return
        }
        commandQueue = device.makeCommandQueue()
        commandQueue.label = "main command queue"

        // Create library for project
        let defaultLibrary = device.makeDefaultLibrary()!
        mLibrary = defaultLibrary
        
        let vertexProgram = defaultLibrary.makeFunction(name: "scroll_vertex")!

        let naturalProgram = defaultLibrary.makeFunction(name: "scroll_fragment")!
        naturalProgram.label = "natural"
        
        mNaturalPipeline = createPipeline(vertex: vertexProgram, fragment: naturalProgram)
        
        let colorProgram = defaultLibrary.makeFunction(name: "color_fragment")!
        colorProgram.label = "color"

        mColorPipeline = createPipeline(vertex: vertexProgram, fragment: colorProgram)
    
        mFrameUniformBuffer = device.makeBuffer(length: MemoryLayout<UniformsFrame>.size, options: [])
        mFrameUniformBuffer.label = "frameUniforms"
        
        uniformBuffer = device.makeBuffer(length: MemoryLayout<UniformsScroll>.size, options: [])
        uniformBuffer.label = "uniforms"
                     
        let data = createSquareData(size: CGSize(width: 1920, height: 1080))
        
        let dataSize = data.count * MemoryLayout<Float>.size
        vertexBuffer = device.makeBuffer(bytes: data, length: dataSize, options: [])
        vertexBuffer.label = "vertices"
        
        let rectData = createBlocksData(rects: [CGRect(),CGRect()], size: CGSize(width: 1920, height: 1080))
        let rectDataSize = rectData.count * MemoryLayout<Float>.size

        vertexBufferSelected = device.makeBuffer(bytes:rectData, length: rectDataSize, options: [])
        vertexBufferSelected.label = "selected vertices"

        updateUniforms()
    }
    
    func createPipeline(vertex : MTLFunction, fragment : MTLFunction) -> MTLRenderPipelineState?
    {
        var result : MTLRenderPipelineState
        
        // Create render pipeline descriptor
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertex
        pipelineStateDescriptor.fragmentFunction = fragment
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.colorPixelFormat
        pipelineStateDescriptor.sampleCount = self.sampleCount
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
            try result = device!.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
            return result
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
        }
        
        return nil;
    }
    
    func setZoom(aZoom : Float)
    {
        mZoom = aZoom
        setPan(aPan: mPan)
    }
    
    func setPan(aPan : CGPoint)
    {
        var pan = aPan
        let imageSize = CGSize(width: inputTexture?.width ?? 1920, height: inputTexture?.height ?? 1080)
        let (maxX,maxY) = calculateMaxPan(magnification: mZoom, imageSize: imageSize, viewSize: self.bounds.size)
        
        if pan.x > maxX{
            pan.x = maxX
        }
        if pan.x < -maxX{
            pan.x = -maxX
        }
        if pan.y > maxY {
            pan.y = maxY
        }
        if pan.y < -maxY{
            pan.y = -maxY
        }
        mPan = pan
    }
    
    func updateUniforms()
    {
        let size = self.frame.size
        
        let ortho = makeOrthographicMatrix(left: -Float(size.width), right: Float(size.width), bottom: -Float(size.height), top: Float(size.height), near: -1.0, far: 1.0)
          
        let videoSize = simd_float2(Float(inputTexture?.width ?? 1920), Float(inputTexture?.height ?? 1080))
        
        let scaleL = calculateScale(ipadSize: bounds.size, windowSize: bounds.size, videoSize: videoSize, isLandscape: true, letterBox: true)
        
        let ident = GLKMatrix4Identity
        
        let translate = GLKMatrix4Translate(ident, Float(mPan.x), Float(mPan.y), 0);
        
        let imageSize = CGSize(width: CGFloat(videoSize.x), height: CGFloat(videoSize.y))
                
        let translationMatrix2 = simd_float4x4.init(matrix: translate)
                
        let modelViewMatrix = simd_float4x4.init(diagonal: simd_float4(scaleL * mZoom, scaleL * mZoom, 1.0, 1.0));
        
        let result = ortho * translationMatrix2 * modelViewMatrix
        
        uniform.projectionMatrix = result

        uniform.frameColor = simd_float3(x: 1.0, y: 0.0, z: 0.0)
        
        let uniforms = [uniform]
        memcpy(uniformBuffer.contents(), uniforms, MemoryLayout<UniformsScroll>.size)
        
        uniformFrame.frameColor = uniform.foreColor
        
        let uniformsFrame = [uniformFrame]
        memcpy(mFrameUniformBuffer.contents(), uniformsFrame, MemoryLayout<UniformsFrame>.size)
    }
    
    private func transformPoint(point : CGPoint) -> CGPoint
    {
        let x = Float(-1 + 2 * point.x / self.frame.width)
        let y = Float(1 - 2 * point.y / self.frame.height)

        let transposeMatrix : simd_float4x4 = uniform.projectionMatrix.transpose

        let inverseMatrix = transposeMatrix.inverse
//        let inverseMatrix : simd_float4x4 = (uniform?.projectionMatrix.inverse)!
        
        let pin = simd_float4(x: x, y: y, z: 0, w: 1)
        
        let pout : simd_float4 = matrix_multiply(pin, inverseMatrix)
        
        print("transformPoint \(pout.x) \(pout.y) \(pout.z) \(pout.w)")
        
        let outX = (CGFloat(pout.x) + CGFloat(inputTexture!.width)) / 2
        let outY = CGFloat(inputTexture!.height) - ((CGFloat(pout.y) + CGFloat(inputTexture!.height)) / 2)

        return CGPoint(x: outX, y: outY)
        //let p = inverseMatrix * point
    }
    
    override func draw(_ rect: CGRect) {
        autoreleasepool {
            if !rect.isEmpty {
                self.render()
            }
        }
    }
    
    func drawBlankAndWait(_ mtkView: MTKView) {
        mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let commandBuffer = commandQueue.makeCommandBuffer()!
        guard let renderPassDescriptor = mtkView.currentRenderPassDescriptor else { return }
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.endEncoding()
        let drawable = mtkView.currentDrawable!
        commandBuffer.present(drawable)
        commandBuffer.commit()
        commandBuffer.waitUntilScheduled()
    }

    private func render() {
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer!.label = "Frame command buffer"

        guard let inputTexture = self.inputTexture else {
            return
        }
        
        guard let drawable: CAMetalDrawable = self.currentDrawable else { fatalError("Failed to create drawable") }

        if let renderPassDescriptor = self.currentRenderPassDescriptor
        {
            renderPassDescriptor.colorAttachments[0].clearColor = clearColor

            if let renderEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            {
                renderEncoder.label = "render encoder"

                renderEncoder.pushDebugGroup("draw")
                renderEncoder.setRenderPipelineState(mNaturalPipeline)

                renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
                renderEncoder.setVertexBuffer(uniformBuffer, offset:0, index: 1)

                renderEncoder.setFragmentTexture(inputTexture, index:0);

                renderEncoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 1)

                renderEncoder.drawPrimitives(type: .triangle,
                                             vertexStart: 0,
                                             vertexCount: 6)
                
                renderEncoder.setRenderPipelineState(mColorPipeline)
                
                //Draw blocks
                if indexBufferLength > 0 {
                    renderEncoder.setVertexBuffer(vertexBufferBlocks, offset: 0, index: 0)
                    renderEncoder.setFragmentBuffer(mFrameUniformBuffer, offset: 0, index: 0)
                    
                    renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indexBufferLength, indexType: .uint32, indexBuffer: indexBufferblocks, indexBufferOffset: 0)
                }
                if mSelectedCount > 0
                {
                    renderEncoder.setVertexBuffer(vertexBufferSelected, offset: 0, index: 0)
                    renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: mSelectedCount * 24, indexType: .uint32, indexBuffer: indexBufferblocks, indexBufferOffset: 0)
                }
                
                renderEncoder.popDebugGroup()
                renderEncoder.endEncoding()
            }
            commandBuffer!.present(drawable)
        }
        commandBuffer!.commit()
    }
    
    func clearPage()
    {
        inputTexture = nil
        drawBlankAndWait(self )
//        self.setNeedsDisplay()
    }
    
    func setPage(/*page : OCRPage*/)
    {
//        mPage = page
//        mSelectedCount = 0
//        let cgimg = getCGImage(from: page.mImage!)
//        inputTexture = getMTLTexture(from: cgimg!)
//        
//        createVertexBuffers(page: page)
//        
//        self.updateUniforms()
//        
//        self.setNeedsDisplay()
    }
    
    func createVertexBuffers(/*page : OCRPage*/)
    {
//        let data = createSquareData(size: CGSize(width: inputTexture!.width, height: inputTexture!.height))
//        let dataSize = data.count * MemoryLayout<Float>.size
//        memcpy(vertexBuffer.contents(), data, dataSize)
//        
//        let blockData = createBlocksData(page: page)
//        let blockDataSize = blockData.count * MemoryLayout<Float>.size
//        
//        if blockDataSize != 0 {
//            
//            vertexBufferBlocks = device!.makeBuffer(bytes: blockData, length: blockDataSize, options: [])
//            vertexBufferBlocks.label = "blockVertices"
//            
//            let blockIndices = createBlocksIndices(page: page)
//            let blockIndicesSize = blockIndices.count * MemoryLayout<UInt32>.size
//            indexBufferLength = blockIndices.count
//            
//            indexBufferblocks = device?.makeBuffer(bytes: blockIndices, length: blockIndicesSize, options: [])
//            indexBufferblocks.label = "blockIndices"
//        }
//        else{
//            indexBufferLength = 0
//        }
    }
    
    func getCGImage(from uiimg: NSImage) -> CGImage? { //ERIKMARK
            
//        UIGraphicsBeginImageContext(uiimg.size)
//        uiimg.draw(in: CGRect(origin: .zero, size: uiimg.size))
//        let contextImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return contextImage?.cgImage
        return nil
    }
        
    func getMTLTexture(from cgimg: CGImage) -> MTLTexture {
        
        let textureLoader = MTKTextureLoader(device: self.device!)
        
        do{
            let width = cgimg.width
            let height = cgimg.height
            let texture = try textureLoader.newTexture(cgImage: cgimg, options: nil)
            let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: texture.pixelFormat, width: width, height: height, mipmapped: false)
            textureDescriptor.usage = [.shaderRead, .shaderWrite]
            return texture
        } catch {
            fatalError("Couldn't convert CGImage to MTLtexture")
        }
    }
    
    func setNaturalColors(grayscale : Bool)
    {
        uniform.artificial = false
        uniform.grayscale = grayscale
        updateUniforms()
        self.needsDisplay = true
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //ERIKMARK
//
//        guard let location = touches.first?.location(in: self), let _ = inputTexture else {
//            return
//        }
//        
//        let transformed = transformPoint(point: location)
//        
//        if let word = mPage?.getWordPosition(pos: transformed)
//        {
//            metalDelegate?.wordTouched(position: word)
//        }
//    }
    
    func set(foreColor : NSColor, backColor : NSColor) //ERIKMARK
    {
//        uniform.foreColor = simd_float3(x: Float(foreColor.rgba.red), y: Float(foreColor.rgba.green), z: Float(foreColor.rgba.blue))
//        uniform.backColor = simd_float3(x: Float(backColor.rgba.red), y: Float(backColor.rgba.green), z: Float(backColor.rgba.blue))
//        uniform.artificial = true
//        
//        clearColor = MTLClearColor(red: backColor.rgba.red, green: backColor.rgba.green, blue: backColor.rgba.blue, alpha: 1.0)
//        updateUniforms()
//        setNeedsDisplay()
    }
    
    var mPNTimer : Timer?
    func pn(direction : PNDirection)
    {
        if direction != .stop && mPNTimer == nil
        {
            mPNTimer = Timer.scheduledTimer(timeInterval: 0.032, target: self, selector: #selector(firePNTimer), userInfo: direction, repeats: true)
        }
        else
        {
            mPNTimer?.invalidate()
            mPNTimer = nil
        }
    }
    
    @objc func firePNTimer()
    {
        let v = mPNTimer?.userInfo as! PNDirection

        if uniform.artificial == false
        {
            var bri = CGFloat(uniform.brightness)
            bri += v == .increase ? 0.02 : -0.02
            brightnessHelp(value: bri)
        }
        else{
            var pn = CGFloat(uniform.pn)
            pn += v == .increase ? 0.01 : -0.01
            contrastHelp(value: pn)
        }
    }

    var startContrast : CGFloat = 0
    func contrast(location: CGPoint, value : CGFloat, began: Bool)
    {
        if uniform.artificial == false
        {
            if began {
                startContrast = CGFloat(uniform.brightness)
            }
            let val = startContrast + value * 0.001
            brightnessHelp(value: val)
        }
        else{
            if began {
                startContrast = CGFloat(uniform.pn)
            }
            let val = startContrast + value * 0.001
            contrastHelp(value: val)
        }
    }
    
    private func brightnessHelp(value : CGFloat)
    {
        uniform.brightness = simd_float1(value)
        if uniform.brightness < -1 {
            uniform.brightness = -1
        }
        else if uniform.brightness > 1{
            uniform.brightness = 1
        }
        let percent = String(format: "%.0f", (1 + uniform.brightness) * 100.0 / 2)
        let string = "Brightness \(percent)%"
        metalDelegate?.valueChanged(text: string)
        updateUniforms()
        self.needsDisplay = true
    }
    
    private func contrastHelp(value : CGFloat)
    {
        uniform.pn = simd_float1(value)
        if uniform.pn < 0 {
            uniform.pn = 0
        }
        else if uniform.pn > (1 - 1 / 4) {
            uniform.pn = (1 - 1 / 4)
        }
        
        let percent = String(format: "%.0f", (uniform.pn * 100.0) / Float(1.0 - 1.0 / 4.0))
        let string = "Contrast \(percent)%"
        metalDelegate?.valueChanged(text: string)
        updateUniforms()
        self.needsDisplay = true
    }
    
    func setRange(range : NSRange) //ERIKMARK
    {
//        guard let size = mPage?.mImage?.size, let page = mPage else {
//            return
//        }
//        let rects = page.getSelectedRectangles(range: range)
//        if rects.count != 1 {
//            return
//        }
//        
//        if isRectangleInside(rect: rects[0]) == false {
//            print("NOT INSIDE")
//            updateUniforms()
//        }
//        
//        mSelectedCount = rects.count
//        let data = createBlocksData(rects: rects, size: size)
//
//        let dataSize = data.count * MemoryLayout<Float>.size
//        vertexBufferSelected.contents().copyMemory(from: data, byteCount: dataSize)
//
//        self.setNeedsDisplay()
    }
    
    private func isRectangleInside(rect : CGRect) -> Bool
    {
        let imageWidth = CGFloat(inputTexture?.width ?? 1280)
        let imageHeight = CGFloat(inputTexture?.height ?? 720)
        var result = true
        
//        print("rect \(rect)")
        
        let s1 = simd_float4(x: simd_float1(2 * rect.minX - imageWidth), y: simd_float1(-2 * rect.minY + imageHeight), z: 0, w: 1.0)
        
        let res1 = matrix_multiply(uniform.projectionMatrix, s1)
        
//        print("res1 \(res1[0]):\(res1[1])")
        
        let s2 = simd_float4(x: simd_float1(2 * rect.maxX - imageWidth), y: simd_float1(-2 * rect.maxY + imageHeight), z: 0, w: 1.0)
        
        let res2 = matrix_multiply(uniform.projectionMatrix, s2)

//        print("res2 \(res2[0]):\(res2[1])")

//        print("mPan \(mPan)") //Är bildens panorering
        
        let viewportSize = self.bounds.size
        
        if res1[0] < -1.0 {
            mPan.x -= CGFloat(res1[0] + 1) * viewportSize.width - 10.0
            result = false;
        }
        if res1[1] > 1.0 { //Lower
            mPan.y -= CGFloat(res1[1] - 1) * viewportSize.height + 10.0
            result = false;
        }
        if res2[0] > 1.0 {
            mPan.x -= CGFloat(res2[0] - 1) * viewportSize.width + 10.0
            result = false;
        }
        if res2[1] < -1.0 { //Upper
            mPan.y -= CGFloat(res2[1] + 1) * viewportSize.height - 10.0
            result = false;
        }
        
        return result
    }
}
