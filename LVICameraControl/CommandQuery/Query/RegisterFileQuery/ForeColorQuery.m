//
//  ForeColorQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-05-12.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "ForeColorQuery.h"

@implementation ForeColorQuery

- (id)initWithGroup:(int) group
{
    self = [super init];
    groupNumber = group;
    return self;
}

- (UInt16) getCommand {
	return 844 + groupNumber * 32;
}

- (UInt16) getResponseLength {
	return 4;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
    CGFloat red = (CGFloat)([buffer getUInt8At : 1]) / 255.0f;
    CGFloat green = (CGFloat)([buffer getUInt8At : 2]) / 255.0f;
    CGFloat blue = (CGFloat)([buffer getUInt8At : 3]) / 255.0f;
    
    foreColor = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:1.0];
}

- (NSColor*) getForeColor {
	return foreColor;
}


@end
