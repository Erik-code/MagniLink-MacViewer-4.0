//
//  CIFCardStatusQueryTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CIFCardStatusQueryTests.h"
#import "StubControlChannel.h"

@implementation CIFCardStatusQueryTests

- (void) setUp {
	cifCardStatusQuery = [[[CIFCardStatusQuery alloc] init] autorelease];
	
}
   
- (void) test_getCommand {
	UInt16 result = [cifCardStatusQuery getCommand];
	GHAssertEquals((int) result, 1565, nil);
}

- (void) test_getChannel {
	UInt16 result = [cifCardStatusQuery getChannel];
	GHAssertEquals((int) result, (int) 2, nil);
}

- (void) test_getResponseLength {
	UInt16 result = [cifCardStatusQuery getResponseLength];
	GHAssertEquals((int) result, 1, nil);
}

- (void) test_updateWithResponse_Startup {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0x00];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_Startup, nil);
}

- (void) test_updateWithResponse_BridgeStop {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0x10];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_BridgeStop, nil);
}

- (void) test_updateWithResponse_BridgeStart {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0x20];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_BridgeStart, nil);
}

- (void) test_updateWithResponse_Standby {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0x30];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_Standby, nil);
}

- (void) test_updateWithResponse_E2PUpdate {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0x40];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_E2PUpdate, nil);
}

- (void) test_updateWithResponse_VideoEnable {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0x50];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_VideoEnable, nil);
}

- (void) test_updateWithResponse_VideoStandby {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0x60];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_VideoStandby, nil);
}

- (void) test_updateWithResponse_VideoDisable {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0x70];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_VideoDisable, nil);
}

- (void) test_updateWithResponse_VideoStart {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0x80];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_VideoStart, nil);
}

- (void) test_updateWithResponse_VideoShow {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0x90];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_VideoShow, nil);
}

- (void) test_updateWithResponse_VideoStop {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0xA0];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_VideoStop, nil);
}

- (void) test_updateWithResponse_ExternPowerLow {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	[buffer addUInt8:0xB0];
	[cifCardStatusQuery updateWithResponse:buffer];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_ExternPowerLow, nil);
}

- (void) test_encode {
	UInt8 queryData[] = {0x1D, 0x06, 0x08, 0x00, 0x02, 0x00, 0x01, 0x00};	
	[self assert:[cifCardStatusQuery encode] isEqualTo:queryData];
}

- (void) test_execute{
	UInt8 queryData[] = {0x1D, 0x06, 0x08, 0x00, 0x02, 0x00, 0x01, 0x00};
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];

	ByteBuffer* responseBuffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 responseData[] = {0xB0};
	[responseBuffer addUInt8Array:responseData ofLength:1];

	[channel addReadBuffer:responseBuffer];
	[cifCardStatusQuery execute:channel];

	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:queryData];
	CIFCardStatus result = [cifCardStatusQuery getStatus];
	GHAssertEquals(result, CIFCardStatus_ExternPowerLow, nil);
}
   
@end
