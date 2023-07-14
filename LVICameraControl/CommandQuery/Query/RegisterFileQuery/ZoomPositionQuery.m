//
//  ZoomPositionQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-10-21.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "ZoomPositionQuery.h"

@implementation ZoomPositionQuery

- (id) init {
	self = [super init];
	if (self) {
		zoomPos = 0;
	}
	return self;
}

- (UInt16) getCommand {
	return 1662;
}

- (UInt16) getResponseLength {
	return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
    uint16 low = [buffer getUInt8At:0];
    uint16 high = [buffer getUInt8At:1];
    
	zoomPos = low + (high << 8);
}

-(uint16) getZoomPos{
    return zoomPos;
}


@end
