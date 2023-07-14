//
//  ReflineCurtain.swift
//  MagniLink Viewer
//
//  Created by Erik Sandstrom on 2022-05-19.
//

import Foundation
import simd

enum ReflineType : CaseIterable
{
    case verticalLine
    case horizontalLine
    case verticalCurtain
    case horizontalCurtain

    init(value : Int)
    {
        let allCases = type(of: self).allCases
        self = allCases[value]
    }
    
    func intValue() -> Int
    {
        let allCases = type(of: self).allCases
        return allCases.firstIndex(of: self)!
    }
    
    mutating func next() {
        let allCases = type(of: self).allCases
        self = allCases[(allCases.firstIndex(of: self)! + 1) % allCases.count]
    }
    
    mutating func previous() {
        let allCases = type(of: self).allCases
        self = allCases[(allCases.firstIndex(of: self)! + allCases.count - 1) % allCases.count]
    }
}

class ReflineCurtainInfo
{
    let minCurtain = 10
    var color = simd_float3(0.0, 0.0, 0.0)
    var sameAsForeground = true
    var lineWidth = 20
    var type : ReflineType = .verticalLine
    var onOrOff = false
    var position = 0
    
    func print()
    {
        Swift.print("on=\(onOrOff ? "yes" : "no") type=\(type) posiition=\(position)")
    }
}

class ReflineCurtain
{
    var mReflineInfo = ReflineCurtainInfo()
    var mReflineCommand : ReflineCommand = .stop
    var mWidth = 1280
    var mHeight = 720
    
    init()
    {
        
    }
    
    func print()
    {
        Swift.print("mWidth=\(mWidth) mHeight=\(mHeight)")
        mReflineInfo.print()
    }
    
    func setSize(size : CGSize)
    {
        mWidth = Int(size.width)
        mHeight = Int(size.height)
    }
    
    func setCommand(refline : ReflineCommand)
    {
        mReflineCommand = refline
    }
    
    func moveRefline()
    {
        if (mReflineCommand == .right) {
            if (mReflineInfo.onOrOff) {
                if (mReflineInfo.type == .verticalLine) {
                    mReflineInfo.position += 10;
                    if (mReflineInfo.position > mWidth) {
                        mReflineInfo.onOrOff = false;
                        mReflineInfo.position = 0;
                    }
                }
                else if (mReflineInfo.type == .horizontalLine) {
                    mReflineInfo.position += 10;
                    if (mReflineInfo.position > mHeight) {
                        mReflineInfo.onOrOff = false;
                        mReflineInfo.position = 0;
                    }
                }
                if (mReflineInfo.type == .verticalCurtain) {
                    mReflineInfo.position += 6
                    if (mReflineInfo.position > mWidth / 2 - mReflineInfo.minCurtain) {
                        mReflineInfo.onOrOff = false
                        mReflineInfo.position = 0
                    }
                }
                else if (mReflineInfo.type == .horizontalCurtain) {
                    mReflineInfo.position += 6
                    if (mReflineInfo.position > mHeight / 2 - mReflineInfo.minCurtain) {
                        mReflineInfo.onOrOff = false
                        mReflineInfo.position = 0
                    }
                }
            }
            else {
                mReflineInfo.position += 1;
                if (mReflineInfo.position == 20) {
                    mReflineInfo.onOrOff = true;
                    mReflineInfo.position = 0;

                    if (true /*mReflineInfo.mRefline == refline::Both*/) {
                        mReflineInfo.type.next()
                    }
    //                    else if (mReflineInfo.mRefline == refline::Line) {
    //                        mReflineInfo.mType = (refline_type)(((int)mReflineInfo.mType + 1) % 2);
    //                    }
    //                    else if (mReflineInfo.mRefline == refline::Curtain) {
    //                        mReflineInfo.mType = (refline_type)(((int)mReflineInfo.mType + 1) % 2 + 2);
    //                    }
                }
            }
        }
        else if (mReflineCommand == .left)
        {
            if (mReflineInfo.onOrOff) {
                if (mReflineInfo.type == .verticalLine) {
                    mReflineInfo.position -= 10;
                    if (mReflineInfo.position < 0) {
                        mReflineInfo.onOrOff = false;
                        mReflineInfo.position = 0;
                    }
                }
                else if (mReflineInfo.type == .horizontalLine) {
                    mReflineInfo.position -= 10;
                    if (mReflineInfo.position < 0) {
                        mReflineInfo.onOrOff = false;
                        mReflineInfo.position = 0;
                    }
                }
                if (mReflineInfo.type == .verticalCurtain) {
                    mReflineInfo.position -= 6
                    if (mReflineInfo.position < 0) {
                        mReflineInfo.onOrOff = false
                        mReflineInfo.position = 0
                    }
                }
                else if (mReflineInfo.type == .horizontalCurtain) {
                    mReflineInfo.position -= 6
                    if (mReflineInfo.position < 0) {
                        mReflineInfo.onOrOff = false
                        mReflineInfo.position = 0
                    }
                }
            }
            else {
                mReflineInfo.position += 1;
                if (mReflineInfo.position >= 20) {
                    mReflineInfo.onOrOff = true;

                    if (true /*mReflineInfo.mRefline == refline::Both*/) {
                        mReflineInfo.type.previous()
                    }
    //                    else if (mReflineInfo.mRefline == refline::Line) {
    //                        mReflineInfo.mType = (refline_type)(((int)mReflineInfo.mType + 1) % 2);
    //                    }
    //                    else if (mReflineInfo.mRefline == refline::Curtain) {
    //                        mReflineInfo.mType = (refline_type)(((int)mReflineInfo.mType + 1) % 2 + 2);
    //                    }

                    if (mReflineInfo.type == .verticalLine)
                    {
                        mReflineInfo.position = mWidth
                    }
                    else if (mReflineInfo.type == .horizontalLine)
                    {
                        mReflineInfo.position = mHeight
                    }
                    if (mReflineInfo.type == .verticalCurtain)
                    {
                        mReflineInfo.position = mWidth / 2 - mReflineInfo.minCurtain
                    }
                    else if (mReflineInfo.type == .horizontalCurtain)
                    {
                        mReflineInfo.position = mHeight / 2 - mReflineInfo.minCurtain
                    }
                }
            }
        }
    }
}
