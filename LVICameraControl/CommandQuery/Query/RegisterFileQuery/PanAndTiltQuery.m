//
//  PanAndTiltQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2012-06-08.
//  Copyright 2012 Prevas AB. All rights reserved.
//

#import "PanAndTiltQuery.h"


@implementation PanAndTiltQuery

- (id) init {
	self = [super init];
	if (self) {
		panState = Pan_Stop;
		tiltState = Tilt_Stop;
	}
	return self;
}

- (UInt16) getCommand {
	return 104;
}

- (UInt16) getResponseLength {
	return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
	uint8 bits = [buffer getUInt8At:0];
	uint8 pan = (bits & 0x03);
	uint8 tilt =  (bits & 0x0C) >> 2;
	switch (tilt) {
		case 0:
			tiltState = Tilt_Stop; break;
		case 1:	
			tiltState = Tilt_Up; break;
		case 2:	
			tiltState = Tilt_Down; break;
		default:
			tiltState = Tilt_Stop; break;
	}
	switch (pan) {
		case 0:
			panState = Pan_Stop; break;
		case 1:	
			panState = Pan_Right; break;
		case 2:	
			panState = Pan_Left; break;
		default:
			panState = Pan_Stop; break;
	}
}

- (PanStateDistance) getPanState {
	return panState;	
}

- (TiltStateDistance) getTiltState {
	return tiltState;	
}

@end
