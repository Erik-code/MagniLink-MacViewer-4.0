//
//  Command.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Command.h"
#import "ByteBuffer.h"
#import "CameraControlException.h"

static const UInt16 COMMAND_MARKER_BIT = 0x8000;
static const UInt16 HEADER_LENGTH = 6; // command (2) + length (2) + channel (2) = 6

@implementation Command

- (void) execute : (id<ControlChannel>) channel {
	ByteBuffer* buffer = [self encode];
	[channel write:buffer];
}

- (ByteBuffer*) encode {
	ByteBuffer* buffer = [[ByteBuffer alloc] init];
	UInt16 command = [self getCommand] | COMMAND_MARKER_BIT;
	[buffer addUInt16: command];
	UInt16 length = [self getDataLength] + HEADER_LENGTH;
	[buffer addUInt16:length];
	[buffer addUInt16:[self getChannel]];
	[self appendData: buffer];
	return buffer;
}

- (UInt16) getCommand {
	NSException* exception = [CameraControlException create: @"Abstract method called"];
	@throw exception;
}

- (void) appendData: (ByteBuffer*) buffer {
	
}

- (UInt16) getDataLength {
	return 0;
}

- (UInt16) getChannel {
	NSException* exception = [CameraControlException create: @"Abstract method called"];
	@throw exception;	
}

@end
