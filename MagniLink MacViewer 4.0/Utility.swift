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
