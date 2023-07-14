//
//  SetUserAreaControl.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 1/29/11.
//  Copyright 2011 Prevas AB. All rights reserved.
//

#import "SetUserAreaControl.h"

static const UInt8 ON  = 0x80;
static const UInt8 OFF = 0x02;

@interface SetUserAreaControl() 
- (UInt8) getUserAreaCommandCodeFor:(SetUserAreaControl_Command) command;
@end

@implementation SetUserAreaControl

- (id) initWithCommand:(SetUserAreaControl_Command) command {
	self = [super init];
	if (self) {
		commandCode = [self getUserAreaCommandCodeFor:command];
	}
	return self;
}

- (UInt8) getUserAreaCommandCodeFor:(SetUserAreaControl_Command) command {
	switch (command) {
		case SetUserAreaControl_On:
			return ON;
		case SetUserAreaControl_Off:
			return OFF;
		default:
			break;
	}
	return OFF;
}

- (UInt16) getCommand {
	return 1560;
}

- (UInt16) getDataLength {
	return 1;
}

- (void) appendData: (ByteBuffer*) buffer {
	[buffer addUInt8:commandCode];
}
@end
