//
//  Utility.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-20.
//

import Foundation
import simd

func createSquareData(size: CGSize) -> [Float]
{
    let width = Float(size.width)
    let height = Float(size.height)

    let data : [Float] =
    [
        -width, -height, 0.0, 1.0,
         width, -height, 1.0, 1.0,
         width, height, 1.0, 0.0,
        
        -width, -height, 0.0, 1.0,
         width, height, 1.0, 0.0,
        -width, height, 0.0, 0.0,
    ]
    return data;
}

func makeOrthographicMatrix(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> float4x4 {
  
    return float4x4(
        [ 2 / (right - left), 0, 0, 0],
        [0, 2 / (top - bottom), 0, 0],
        [0, 0, 1 / (far - near), 0],
        [(left + right) / (left - right), (top + bottom) / (bottom - top), near / (near - far), 1]
    )
}

func createFramePositions(width: Float, height: Float, thickness: Float) -> [Float]
{
    let data : [Float] =
    [
    -width, -height, 0.0, 0.0,
     width, -height, 1.0, 0.0,

     width, height, 1.0, 1.0,
     -width, height, 0.0, 1.0,

     -width+thickness, -height+thickness, 0.0, 0.0,
      width-thickness, -height+thickness, 1.0, 0.0,
     
      width-thickness, height-thickness, 1.0, 1.0,
     -width+thickness, height-thickness, 0.0, 1.0
    ]
    return data
}

func createFrameIndices() -> [UInt32]
{
    let data : [UInt32] = [
        0,1,5, 0,5,4,
        1,2,6, 1,6,5,
        2,3,7, 2,7,6,
        3,0,4, 3,4,7,
    ]
    return data
}

func createBlocksData(rects : [CGRect], size : CGSize) -> [Float]
{
    var data : [Float] = []
    let thickness : Float = 8.0
    
    for rect in rects
    {
        let x = -Float(size.width) + Float(rect.minX * 2.0)
        let y = Float(size.height) - Float(rect.minY * 2.0)

        let x2 = -Float(size.width) + Float(rect.maxX * 2.0)
        let y2 = Float(size.height) - Float(rect.maxY * 2.0)

        data.append(contentsOf: [x, y, 0.0, 0.0])
        data.append(contentsOf: [x2, y, 1.0, 0.0])
        data.append(contentsOf: [x2, y2, 1.0, 1.0])
        data.append(contentsOf: [x, y2, 0.0, 1.0])

        let xt = -Float(size.width) + (Float(rect.minX) - thickness) * 2.0
        let yt = Float(size.height) - (Float(rect.minY) - thickness) * 2.0
        
        let xt2 = -Float(size.width) + (Float(rect.maxX) + thickness) * 2.0
        let yt2 = Float(size.height) - (Float(rect.maxY) + thickness) * 2.0
        
        data.append(contentsOf: [xt, yt, 0.0, 0.0])
        data.append(contentsOf: [xt2, yt, 1.0, 0.0])
        data.append(contentsOf: [xt2, yt2, 1.0, 1.0])
        data.append(contentsOf: [xt, yt2, 0.0, 1.0])
    }
    
    return data
}

func calculateMaxPan(magnification : Float, imageSize: CGSize, viewSize: CGSize) -> (CGFloat, CGFloat)
{
    let scaleX = viewSize.width / imageSize.width
    let scaleY = viewSize.height / imageSize.height
    let scale = min(scaleX, scaleY)
    
    let imageSizeX = imageSize.width * scale * CGFloat(magnification)
    let imageSizeY = imageSize.height * scale * CGFloat(magnification)
    
    let panX = imageSizeX > viewSize.width ? (imageSizeX - viewSize.width) * 0.5 : 0
    let panY = imageSizeY > viewSize.height ? (imageSizeY - viewSize.height) * 0.5 : 0

    return (panX * 2, panY * 2)
}

func calculateScale(ipadSize : CGSize, windowSize: CGSize, videoSize: simd_float2, isLandscape : Bool, letterBox : Bool ) -> Float
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
            return max(Float(ipadSize.width) / videoSize.x, Float(ipadSize.height) / videoSize.y);
        }
        else
        {
            return max(Float(ipadSize.width) / videoSize.y, Float(ipadSize.height) / videoSize.x);
        }
    }
}

