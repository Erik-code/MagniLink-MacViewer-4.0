//
//  SetContrast.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetContrast.h"

static const UInt8 TRIGGERBIT = 0x80;
static const UInt8 STOP_CONTRAST = 0x00;
static const UInt8 MIDDLE_CONTRAST = 0x01;
static const UInt8 LESS_CONTRAST = 0x02;
static const UInt8 MORE_CONTRAST = 0x03;
static const UInt8 MANUAL_CONTRAST = 0x04;
static const UInt8 AUTO_CONTRAST = 0x06;

@interface SetContrast() 
- (UInt8) getContrastCommandCode: (SetContrastCommand) command;
@end

@implementation SetContrast

- (id) initWithCommand:(SetContrastCommand) command {
	self = [super init];
	if (self) {
		contrastCommandCode = [self getContrastCommandCode:command];
	}
	return self;
}

- (UInt8) getContrastCommandCode: (SetContrastCommand) command {
	switch (command) {
		case SetContrast_Stop:
			return STOP_CONTRAST; 
		case SetContrast_Increase:
			return MORE_CONTRAST; 
		case SetContrast_Decrease:
			return LESS_CONTRAST; 
		case SetContrast_Middle:
			return MIDDLE_CONTRAST; 
		case SetContrast_Manual:
			return MANUAL_CONTRAST; 
		case SetContrast_Auto:
			return AUTO_CONTRAST;
		default:
			break;
	}
	return STOP_CONTRAST;
}

- (UInt16) getCommand {
	return 96;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	UInt8 data = contrastCommandCode | TRIGGERBIT;
	[buffer addUInt8:data];
	[buffer addUInt8:0];
}

@end
