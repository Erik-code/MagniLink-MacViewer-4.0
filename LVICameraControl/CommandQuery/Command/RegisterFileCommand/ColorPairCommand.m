//
//  ColorPairCommand.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-08.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "ColorPairCommand.h"

@interface ColorPairCommand()
{
    int mPalette;
    @private ColorPaletteType mType;
    
    @private NSColor* mForeColor;
    @private NSColor* mBackColor;
    
    bool mGrayscale;
    
    UInt16 mLength;
}
@end

@implementation ColorPairCommand

- (id) initWithPalette:(int)palette andType:(ColorPaletteType)type andForeColor:(NSColor*)fore andBackColor:(NSColor*)back
{
    self = [super init];
    if(self){
        mPalette = palette;
        mType = type;
        mForeColor = fore;
        mBackColor = back;
        mLength = 12;
    }
    return self;
}

- (id) initWithGrayscale:(bool)grayscale
{
    self = [super init];
    if(self){
        mGrayscale = grayscale;
        mLength = 8;
    }
    return self;
}

- (UInt16) getCommand {
    return 0x348 + mPalette * 0x20;
}

- (UInt16) getDataLength {
    return mLength;
}

- (void) appendData: (ByteBuffer*) buffer
{
    [buffer addUInt8:0];
    if(mType == Natural){
        [buffer addUInt8:0x40];
    }
    else if(mType == Positive){
        [buffer addUInt8:0x80];
    }
    else if(mType == Negative){
        [buffer addUInt8:0xC0];
    }
    else if(mType == Unused){
        [buffer addUInt8:0x00];
    }
    [buffer addUInt8:0];
    [buffer addUInt8:0];

    [buffer addUInt8:0];
    uint8 r = [mForeColor redComponent] * 255.0;
    uint8 g = [mForeColor greenComponent] * 255.0;
    uint8 b = [mForeColor blueComponent] * 255.0;
    [buffer addUInt8:r];
    [buffer addUInt8:g];
    [buffer addUInt8:b];

////
    [buffer addUInt8:63];
    r = [mBackColor redComponent] * 255.0;
    g = [mBackColor greenComponent] * 255.0;
    b = [mBackColor blueComponent] * 255.0;
    [buffer addUInt8:r];
    [buffer addUInt8:g];
    [buffer addUInt8:b];
}

@end
