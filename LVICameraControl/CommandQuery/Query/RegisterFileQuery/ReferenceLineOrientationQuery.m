//
//  ReferenceLineOrientationQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-11-11.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "ReferenceLineOrientationQuery.h"

@implementation ReferenceLineOrientationQuery

- (id) init {
	self = [super init];
	if (self) {
		refLineOrientation = 0;
	}
	return self;
}

- (UInt16) getCommand {
	return 1676;
}

- (UInt16) getResponseLength {
	return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
    uint16 low = [buffer getUInt8At:0];
    refLineOrientation = low;
}

- (ReferenceLineType) getRefLineType
{
    if((refLineOrientation & 0x4) !=0)
        return Curtain;
    return ReferenceLine;
}

- (ReferenceLineOrient) getRefLineOrientation
{
    return refLineOrientation & 0x3;
}

- (uint16) getVal
{
    return refLineOrientation;
}

@end
