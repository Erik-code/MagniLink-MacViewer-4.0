//
//  ProductConfigurationQueryTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProductConfigurationQueryTests.h"
#import "StubControlChannel.h"

@implementation ProductConfigurationQueryTests

- (void) setUp {
	prodQuery = [[[ProductConfigurationQuery alloc] init] autorelease];
	
}

- (void) test_getCommand {
	UInt16 result = [prodQuery getCommand];
	GHAssertEquals((int) result, 756, nil);
}

- (void) test_getChannel {
	UInt16 result = [prodQuery getChannel];
	GHAssertEquals((int) result, (int) 2, nil);
}

- (void) test_getResponseLength {
	UInt16 result = [prodQuery getResponseLength];
	GHAssertEquals((int) result, 4, nil);
}

- (void) test_updateWithResponse_MLSA {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 data[] = {0x01, 0x00, 0x00, 0x00};
	[buffer addUInt8Array:data ofLength:4];
	[prodQuery updateWithResponse:buffer];
	ProductConfiguration result = [prodQuery getConfiguration];	
	GHAssertEquals(result, ProductConfiguration_MLSA, nil);
}

- (void) test_updateWithResponse_MLS {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 data[] = {0x02, 0x00, 0x00, 0x00};
	[buffer addUInt8Array:data ofLength:4];
	[prodQuery updateWithResponse:buffer];
	ProductConfiguration result = [prodQuery getConfiguration];	
	GHAssertEquals(result, ProductConfiguration_MLS, nil);
}

- (void) test_updateWithResponse_MLS_PRO {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 data[] = {0x03, 0x00, 0x00, 0x00};
	[buffer addUInt8Array:data ofLength:4];
	[prodQuery updateWithResponse:buffer];
	ProductConfiguration result = [prodQuery getConfiguration];	
	GHAssertEquals(result, ProductConfiguration_MLS_PRO, nil);
}

- (void) test_encode {
	UInt8 queryData[] = {0xF4, 0x02, 0x08, 0x00, 0x02, 0x00, 0x04, 0x00};
	[self assert:[prodQuery encode] isEqualTo:queryData];
}

- (void) test_execute{
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	UInt8 queryData[] = {0xF4, 0x02, 0x08, 0x00, 0x02, 0x00, 0x04, 0x00};
	ByteBuffer* responseBuffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 responseData[] = {0x03, 0x00, 0x00, 0x00};
	[responseBuffer addUInt8Array:responseData ofLength:4];
	[channel addReadBuffer:responseBuffer];
	
	[prodQuery execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:queryData];
	ProductConfiguration result = [prodQuery getConfiguration];	
	GHAssertEquals(result, ProductConfiguration_MLS_PRO, nil);
}

@end
