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

