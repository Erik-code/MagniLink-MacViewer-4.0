//
//  VideoGenQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2015-04-10.
//  Copyright (c) 2015 Prevas AB. All rights reserved.
//

#import "VideoGenQuery.h"

@implementation VideoGenQuery

- (id)initWithGroup:(int) group
{
    self = [super init];
    groupNumber = group;
    return self;
}

- (UInt16) getCommand {
	return 300 + groupNumber * 56;
}

- (UInt16) getResponseLength {
	return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
    interlaced = ([buffer getUInt8At:0] & 0x8) != 0;
    usb = [buffer getUInt8At:0] >> 4 == 0x2;
}

- (bool)isUsb
{
    return usb;
}

- (bool)isInterlaced
{
    return interlaced;
}

@end
