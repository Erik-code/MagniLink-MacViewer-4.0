//
//  TiltStateQueryTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TiltStateQueryTests.h"
#import "StubControlChannel.h"

@implementation TiltStateQueryTests

- (void) setUp {
	tiltQuery = [[[TiltStateQuery alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [tiltQuery getCommand];
	GHAssertEquals((int) result, 1700, nil);
}

- (void) test_getChannel {
	UInt16 result = [tiltQuery getChannel];
	GHAssertEquals((int) result, (int) 2, nil);
}

- (void) test_getResponseLength {
	UInt16 result = [tiltQuery getResponseLength];
	GHAssertEquals((int) result, 1, nil);
}

- (void) test_updateWithResponse_Reading {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 data[] = {0x00};
	[buffer addUInt8Array:data ofLength:1];
	[tiltQuery updateWithResponse:buffer];
	TiltState result = [tiltQuery getTiltState];	
	GHAssertEquals(result, TiltState_Reading, nil);
}

- (void) test_updateWithResponse_Distance {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 data[] = {0x01};
	[buffer addUInt8Array:data ofLength:1];
	[tiltQuery updateWithResponse:buffer];
	TiltState result = [tiltQuery getTiltState];	
	GHAssertEquals(result, TiltState_Distance, nil);
}

- (void) test_updateWithResponse_Off {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 data[] = {0x02};
	[buffer addUInt8Array:data ofLength:1];
	[tiltQuery updateWithResponse:buffer];
	TiltState result = [tiltQuery getTiltState];	
	GHAssertEquals(result, TiltState_Off, nil);
}

- (void) test_encode {
	UInt8 queryData[] = {0xA4, 0x06, 0x08, 0x00, 0x02, 0x00, 0x01, 0x00};
	[self assert:[tiltQuery encode] isEqualTo:queryData];
}

- (void) test_execute{
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	UInt8 queryData[] = {0xA4, 0x06, 0x08, 0x00, 0x02, 0x00, 0x01, 0x00};
	ByteBuffer* responseBuffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 responseData[] = {0x02, 0x00, 0x00, 0x00};
	[responseBuffer addUInt8Array:responseData ofLength:4];
	[channel addReadBuffer:responseBuffer];
	
	[tiltQuery execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:queryData];
	TiltState result = [tiltQuery getTiltState];	
	GHAssertEquals(result, TiltState_Off, nil);
}

@end
