//
//  SetShownObjects.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-05-23.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "SetShownObjects.h"

static const UInt8 TRIGGERBIT = 0x01;

@implementation SetShownObjects

- (id) initWithCommand: (uint8) command {
	self = [super init];
	if (self) {
		shownObjectsCommandCode = command;
	}
	return self;	
}

- (UInt16) getCommand {
	return 80;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	UInt8 data = shownObjectsCommandCode;
	[buffer addUInt8:data];
	[buffer addUInt8:TRIGGERBIT];
}

@end
