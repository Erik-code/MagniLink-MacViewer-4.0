//
//  SetControlReferenceLine.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-11-10.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "SetControlReferenceLine.h"

@implementation SetControlReferenceLine

- (id) initWithPosition: (uint16) position {
    self = [super init];
    if (self) {
        refLinePosition = position;
    }
    return self;	
}

- (UInt16) getCommand {
	return 1558;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	[buffer addUInt8:refLinePosition & 0xFF];
    [buffer addUInt8:refLinePosition >> 8];
}



@end
