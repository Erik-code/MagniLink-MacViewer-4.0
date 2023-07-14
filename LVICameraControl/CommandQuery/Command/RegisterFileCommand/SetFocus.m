//
//  SetFocus.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2015-08-04.
//  Copyright (c) 2015 Prevas AB. All rights reserved.
//

#import "SetFocus.h"

static const UInt8 STOP_FOCUS = 0x00;
static const UInt8 FOCUS_OUT = 0x05;
static const UInt8 FOCUS_IN = 0x04;
static const UInt8 TRIGGERBIT = 0x80;

@implementation SetFocus

- (id) initWithCommand: (SetFocusCommand) command {
	self = [super init];
	if (self) {
		focusCommandCode = [self getFocusCommandCode: command];
	}
	return self;	
}

- (UInt16) getCommand {
	return 82;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	UInt8 data = focusCommandCode | TRIGGERBIT;
	[buffer addUInt8:data];
	[buffer addUInt8:0];
}

- (UInt8) getFocusCommandCode: (SetFocusCommand) command {
	switch (command) {
		case SetFocus_Stop:
			return STOP_FOCUS; break;
		case SetFocus_Out:	
			return FOCUS_OUT; break;
		case SetFocus_In:
			return FOCUS_IN; break;
		default:
			return STOP_FOCUS;
	}	
}

@end
