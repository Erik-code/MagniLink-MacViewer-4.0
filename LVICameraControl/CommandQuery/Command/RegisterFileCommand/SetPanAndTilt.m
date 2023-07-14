//
//  SetPanAndTilt.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2012-06-08.
//  Copyright 2012 Prevas AB. All rights reserved.
//

#import "SetPanAndTilt.h"

static const UInt8 PAN_TILT_STOP_STOP = 0x00;

static const UInt8 PAN_TILT_RIGHT_STOP = 0x01;
static const UInt8 PAN_TILT_LEFT_STOP = 0x02;

static const UInt8 PAN_TILT_STOP_UP = 0x04;
static const UInt8 PAN_TILT_STOP_DOWN = 0x08;

static const UInt8 PAN_TILT_LEFT_DOWN = 0x0A;
static const UInt8 PAN_TILT_LEFT_UP = 0x06;

static const UInt8 PAN_TILT_RIGHT_DOWN = 0x09;
static const UInt8 PAN_TILT_RIGHT_UP = 0x05;

static const UInt8 TRIGGERBIT = 0x80;

@interface SetPanAndTilt()
- (UInt8) getPanAndTiltCommandCode:(SetPanAndTiltCommand) command ;
@end

@implementation SetPanAndTilt

- (id) initWithCommand: (SetPanAndTiltCommand) command {
	self = [super init];
	if (self) {
		panAndTiltCommandCode = [self getPanAndTiltCommandCode: command];
	}
	return self;	
}

- (UInt16) getCommand {
	return 104;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	UInt8 data = panAndTiltCommandCode;
	[buffer addUInt8:data];
	[buffer addUInt8:TRIGGERBIT];
}


- (UInt8) getPanAndTiltCommandCode: (SetPanAndTiltCommand) command {
	switch (command) {
		case SetPanAndTilt_Stop_Stop:
			return PAN_TILT_STOP_STOP; break;
			
		case SetPanAndTilt_Left_Stop:	
			return PAN_TILT_LEFT_STOP; break;
			
		case SetPanAndTilt_Right_Stop:
			return PAN_TILT_RIGHT_STOP; break;
			
		case SetPanAndTilt_Left_Up:
			return PAN_TILT_LEFT_UP; break;
			
		case SetPanAndTilt_Right_Up:
			return PAN_TILT_RIGHT_UP; break;
			
		case SetPanAndTilt_Left_Down:
			return PAN_TILT_LEFT_DOWN; break;
			
		case SetPanAndTilt_Right_Down:
			return PAN_TILT_RIGHT_DOWN; break;
			
		case SetPanAndTilt_Stop_Down:	
			return PAN_TILT_STOP_DOWN; break;
			
		case SetPanAndTilt_Stop_Up:
			return PAN_TILT_STOP_UP; break;
			
		default:
			return PAN_TILT_STOP_STOP;
	}	
}

@end
