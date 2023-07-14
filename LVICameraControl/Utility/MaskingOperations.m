//
//  MaskingOperations.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MaskingOperations.h"

static const UInt16 LOW_BYTE_MASK = 0x00FF;
static const UInt16 HIGH_BYTE_MASK = 0xFF00;

@implementation MaskingOperations

+ (UInt8) getLowByte: (UInt16) x {
	return (UInt8) (x & LOW_BYTE_MASK);
}

+ (UInt8) getHighByte: (UInt16) x {
	return (UInt8) ((x & HIGH_BYTE_MASK) >> 8);
}

+ (UInt16) setHighByte: (UInt8) x {
	UInt16 result = (UInt16) x;
	return result << 8;
}
@end
