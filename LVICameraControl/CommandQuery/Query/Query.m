//
//  Query.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Query.h"
#import "CameraControlException.h"

static const UInt16 QUERY_LENGTH = 8; // command (2) + length (2) + channel (2) + number of data bytes to read later (2)

@implementation Query

- (void) execute: (id<ControlChannel>) channel {
	ByteBuffer* queryBuffer = [self encode];
	[channel write:queryBuffer];
	UInt16 bytesToRead = [self getResponseLength];
	ByteBuffer* responseBuffer = [channel read:bytesToRead];
	[self updateWithResponse:responseBuffer];
}

- (ByteBuffer*) encode {
	ByteBuffer* buffer = [[ByteBuffer alloc] init];
	[buffer addUInt16: [self getCommand]];
	[buffer addUInt16: QUERY_LENGTH];
	[buffer addUInt16: [self getChannel]];
	[buffer addUInt16: [self getResponseLength]];	
	return buffer;
}

- (UInt16) getCommand {
	NSException* exception = [CameraControlException create: @"Abstract method called"];
	@throw exception;	
}

- (UInt16) getResponseLength {
	NSException* exception = [CameraControlException create: @"Abstract method called"];
	@throw exception;	
}

- (UInt16) getChannel {
	NSException* exception = [CameraControlException create: @"Abstract method called"];
	@throw exception;	
}

- (void) updateWithResponse: (ByteBuffer*) response {
	NSException* exception = [CameraControlException create: @"Abstract method called"];
	@throw exception;	
}

@end
