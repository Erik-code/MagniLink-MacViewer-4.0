//
//  EnableTiltState.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetTiltState.h"

static const UInt8 READING = 0;
static const UInt8 DISTANCE = 1;
static const UInt8 OFF = 2;
static const UInt8 TRIGGERBIT = 0x80;

@interface SetTiltState() 

- (UInt8) getTiltStateCode: (TiltState) state;

@end

@implementation SetTiltState

- (id) initWithState: (TiltState) state {
	self = [super init];
	if (self) {
		stateCode = [self getTiltStateCode: state];
	}
	return self;
}

- (UInt8) getTiltStateCode: (TiltState) state {
	switch (state) {
		case TiltState_Off:
			return  OFF;
		case TiltState_Reading:
			return READING;
		case TiltState_Distance:	
			return DISTANCE;
		default:
			break;
	}
	return OFF;
}

- (UInt16) getCommand {
	return 100;
}

- (UInt16) getDataLength {
	return 1;
}

- (void) appendData: (ByteBuffer*) buffer {
	UInt8 data = stateCode	| TRIGGERBIT;
	[buffer addUInt8:data];
}

@end
