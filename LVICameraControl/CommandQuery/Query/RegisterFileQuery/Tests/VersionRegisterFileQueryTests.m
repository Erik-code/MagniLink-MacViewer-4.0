//
//  VersionRegisterFileQueryTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VersionRegisterFileQueryTests.h"
#import "StubControlChannel.h"


@implementation VersionRegisterFileQueryTests

- (void) setUp {
	versionRegisterFileQuery = [[[VersionRegisterFileQuery alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [versionRegisterFileQuery getCommand];
	GHAssertEquals((int) result, 0, nil);
}

- (void) test_getChannel {
	UInt16 result = [versionRegisterFileQuery getChannel];
	GHAssertEquals((int) result, (int) 2, nil);
}

- (void) test_getResponseLength {
	UInt16 result = [versionRegisterFileQuery getResponseLength];
	GHAssertEquals((int) result, 8, nil);
}

- (void) test_updateWithResponse {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 data[] = {' ', ' ', ' ', 'A', 'B'};
	[buffer addUInt8Array:data ofLength:5];
	[versionRegisterFileQuery updateWithResponse:buffer];
	NSString* result = [versionRegisterFileQuery getVersion];
	GHAssertEqualStrings(result, @"AB", nil);
}

- (void) test_encode {
	UInt8 queryData[] = {0x00, 0x00, 0x08, 0x00, 0x02, 0x00, 0x08, 0x00};
	[self assert:[versionRegisterFileQuery encode] isEqualTo:queryData];
}

- (void) test_execute {
	UInt8 queryData[] = {0x00, 0x00, 0x08, 0x00, 0x02, 0x00, 0x08, 0x00};
	StubControlChannel* controlChannel = [[[StubControlChannel alloc] init] autorelease];
	ByteBuffer* responseBuffer = [[[ByteBuffer alloc] init] autorelease];
	UInt8 responseData[] = {' ', ' ', ' ', 'A', 'B', 'C', 'D', 'E'};
	[responseBuffer addUInt8Array:responseData ofLength:8];
	[controlChannel addReadBuffer:responseBuffer];
	
	[versionRegisterFileQuery execute:controlChannel];
	
	[self assert:[controlChannel getWriteBufferAtIndex:0] isEqualTo:queryData];
	NSString* result = [versionRegisterFileQuery getVersion];
	GHAssertEqualStrings(result, @"ABCDE", nil);
	
}
@end
