//
//  MinZoomPositionQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-10-27.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "MinZoomPositionQuery.h"

@implementation MinZoomPositionQuery

- (id)initWithTiltState:(TiltState) state;
{
    self = [super init];
    tiltState = state;
    zoomPosition = 0;
    return self;
}

- (UInt16) getCommand {
	return 1390 + tiltState * 52;
}

- (UInt16) getResponseLength {
	return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
    uint16 low = [buffer getUInt8At:0];
    uint16 high = [buffer getUInt8At:1];
    
	zoomPosition = low + (high << 8);
}

- (uint16) getZoomPosition {
	return zoomPosition;
}


@end
