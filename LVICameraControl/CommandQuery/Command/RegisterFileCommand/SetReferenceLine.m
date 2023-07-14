//
//  SetReferenceLines.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetReferenceLine.h"

static const UInt8 STOP = 0x00;
static const UInt8 UP_OR_LEFT = 0x02;
static const UInt8 DOWN_OR_RIGHT = 0x03;
static const UInt8 GOTO_POSITION = 0x08;
static const UInt8 TRIGGERBIT = 0x80;


@interface SetReferenceLine() 
- (UInt8) getReferenceLineCommandCodeFor:(SetReferenceLine_Command) command;
@end

@implementation SetReferenceLine

- (id) initWithCommand:(SetReferenceLine_Command) command {
	self = [super init];
	if (self) {
		referenceLineCommandCode = [self getReferenceLineCommandCodeFor:command];
	}
	return self;
}

- (UInt8) getReferenceLineCommandCodeFor:(SetReferenceLine_Command) command {
	switch (command) {
		case SetReferenceLine_Stop:
			return STOP;
		case SetReferenceLine_DownOrRight:
			return DOWN_OR_RIGHT;
		case SetReferenceLine_UpOrLeft:
			return UP_OR_LEFT;
        case SetReferenceLine_GotoPosition:
			return GOTO_POSITION;
		default:
			break;
	}
	return STOP;
}


- (UInt16) getCommand {
	return 98;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	[buffer addUInt8:referenceLineCommandCode];
	[buffer addUInt8:TRIGGERBIT];
}

@end
