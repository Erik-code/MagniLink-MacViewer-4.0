//
//  SetControlReferenceLineOrientation.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-11-11.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "SetControlReferenceLineOrientation.h"

@implementation SetControlReferenceLineOrientation

- (id) initWithType: (ReferenceLineType)type andOrientation:(ReferenceLineOrient)orientation;
 {
    self = [super init];
    if (self) {
        refLineOrientation = orientation + (type << 2);
    }
    return self;	
}

- (id) initWithVal: (uint16)val
{
    self = [super init];
    if (self) {
        refLineOrientation = val;
    }
    return self;
}

- (UInt16) getCommand {
	return 1556;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	[buffer addUInt8:refLineOrientation];
    [buffer addUInt8:0];
}

@end
