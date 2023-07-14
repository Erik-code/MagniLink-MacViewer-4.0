//
//  SetApplicationStatus.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetApplicationStatus.h"

static const UInt8 MINIMIZED_BIT = 0x40;
static const UInt8 LIVE_CAMERA_BIT = 0x20;
static const UInt8 MEGA_PIXEL_CAMERA_BIT = 0x10;


@implementation SetApplicationStatus

- (id) initWithStatusMinimized: (BOOL) minimized  andLive:(BOOL) live andMegaPixel:(BOOL) megapixel {
	self = [super init];
	if (self) {
		status = 0;
		if (minimized) {
			status |= MINIMIZED_BIT;
		}
		if (live) {
			status |= LIVE_CAMERA_BIT;
		}
		if (megapixel) {
			status |= MEGA_PIXEL_CAMERA_BIT;
		}
	}
	return self;	
}

- (UInt16) getCommand {
	return 9;
}

- (UInt16) getDataLength {
	return 1;
}

- (void) appendData: (ByteBuffer*) buffer {
	[buffer addUInt8:status];
}
@end
