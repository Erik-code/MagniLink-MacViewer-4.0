//
//  SetAutoFocus.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2012-05-09.
//  Copyright 2012 Prevas AB. All rights reserved.
//

#import "SetAutoFocus.h"

static const UInt8 STOP_AUTOFOCUS = 0x00;
static const UInt8 AUTOFOCUS_ON = 0x01;
static const UInt8 AUTOFOCUS_OFF = 0x02;
static const UInt8 TRIGGERBIT = 0x80;

@interface SetAutofocus() 
- (UInt8) getAutofocusCommandCode:(SetAutofocusCommand) command;	
@end

@implementation SetAutofocus

- (id) initWithCommand: (SetAutofocusCommand) command {
	self = [super init];
	if (self) {
		autofocusCommandCode = [self getAutofocusCommandCode: command];
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
	UInt8 data = autofocusCommandCode | TRIGGERBIT;
	[buffer addUInt8:data];
	[buffer addUInt8:0];
}

- (UInt8) getAutofocusCommandCode: (SetAutofocusCommand) command {
	switch (command) {
		case SetAutofocus_Stop:
			return STOP_AUTOFOCUS; break;
		case SetAutofocus_On:	
			return AUTOFOCUS_ON; break;
		case SetAutofocus_Off:
			return AUTOFOCUS_OFF; break;
		default:
			return STOP_AUTOFOCUS;
	}	
}

@end
