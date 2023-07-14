//
//  ColorPairQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-07.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "ColorPairQuery.h"

@implementation ColorPairQuery

- (id) initWithPalette:(int)palette {
    self = [super init];
    if (self) {
        mPalette = palette;
    }
    return self;
}

- (UInt16) getCommand {
    return 0x348 + mPalette * 0x20;
}

- (UInt16) getResponseLength {
    return 12;
}

- (void) updateWithResponse: (ByteBuffer*) buffer
{
    uint16 low = [buffer getUInt8At:0];
    uint16 high = [buffer getUInt8At:1];
//    uint16 higher1 = [buffer getUInt8At:2];
    
    if(high == 0x40){
        mType = Natural;
    }
    else if(high == 0x80){
        mType = Positive;
    }
    else if(high == 0xC0){
        mType = Negative;
    }
    else{
        mType = Unused;
    }
   
    uint16 a = [buffer getUInt8At:4];
    uint16 r = [buffer getUInt8At:5];
    uint16 g = [buffer getUInt8At:6];
    uint16 b = [buffer getUInt8At:7];
      
    mForeColor = [NSColor colorWithRed:r / 255.0f green:g / 255.0 blue:b / 255.0 alpha:1.0];
    
    a = [buffer getUInt8At:8];
    r = [buffer getUInt8At:9];
    g = [buffer getUInt8At:10];
    b = [buffer getUInt8At:11];
    
    mBackColor = [NSColor colorWithRed:r / 255.0f green:g / 255.0 blue:b / 255.0 alpha:1.0];
 }

-(ColorPaletteType) type
{
    return mType;
}

-(NSColor*) foreColor
{
    return mForeColor;
}

-(NSColor*) backColor
{
    return mBackColor;
}

@end

