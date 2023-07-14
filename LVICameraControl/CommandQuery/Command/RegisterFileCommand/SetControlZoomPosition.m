//
//  SetControlZoomPosition.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-10-24.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "SetControlZoomPosition.h"

@implementation SetControlZoomPosition

- (id) initWithPosition: (uint16) position {
    self = [super init];
    if (self) {
        zoomPosition = position;
    }
    return self;	
}

- (UInt16) getCommand {
	return 1550;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	[buffer addUInt8:zoomPosition & 0xFF];
    [buffer addUInt8:zoomPosition >> 8];
}


@end
