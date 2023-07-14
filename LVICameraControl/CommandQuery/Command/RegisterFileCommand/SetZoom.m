//
//  SetZoom.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetZoom.h"

static const UInt8 STOP_ZOOM = 0x00;
static const UInt8 ZOOM_OUT = 0x01;
static const UInt8 ZOOM_IN = 0x02;
static const UInt8 ZOOM_POSITION = 0x03;
static const UInt8 TRIGGERBIT = 0x80;

@interface SetZoom() 
- (UInt8) getZoomCommandCode:(SetZoomCommand) command;	
@end

@implementation SetZoom

- (id) initWithCommand: (SetZoomCommand) command {
	self = [super init];
	if (self) {
		zoomCommandCode = [self getZoomCommandCode: command];
	}
	return self;	
}

- (UInt16) getCommand {
	return 84;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	UInt8 data = zoomCommandCode | TRIGGERBIT;
	[buffer addUInt8:data];
	[buffer addUInt8:0];
}

- (UInt8) getZoomCommandCode: (SetZoomCommand) command {
	switch (command) {
		case SetZoom_Stop:
			return STOP_ZOOM; break;
		case SetZoom_Out:	
			return ZOOM_OUT; break;
		case SetZoom_In:
			return ZOOM_IN; break;
        case SetZoom_Position:
			return ZOOM_POSITION; break;
		default:
			return STOP_ZOOM;
	}	
}

@end
