//
//  ColorGroupQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-05-09.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "BackColorQuery.h"

@implementation BackColorQuery

- (id)initWithGroup:(int) group
{
    self = [super init];
    groupNumber = group;
    return self;
}

- (UInt16) getCommand {
	return 848 + groupNumber * 32;
}

- (UInt16) getResponseLength {
	return 4;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
    
    CGFloat red = (CGFloat)([buffer getUInt8At : 1]) / 255.0f;
    CGFloat green = (CGFloat)([buffer getUInt8At : 2]) / 255.0f;
    CGFloat blue = (CGFloat)([buffer getUInt8At : 3]) / 255.0f;
    
    backColor = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:1.0];
}

- (NSColor*) getBackColor {
	return backColor;
}

@end
