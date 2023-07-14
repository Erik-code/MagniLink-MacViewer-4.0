//
//  RegisterFileQueryTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RegisterFileQueryTests.h"
#import "StubControlChannel.h"


@implementation RegisterFileQueryTests

- (void) setUp {
	registerFileQuery = [[[RegisterFileQuery alloc] init] autorelease];
}

- (void) test_getCommand_Throws {
	GHAssertThrows([registerFileQuery getCommand], nil);
}

- (void) test_getChannel {
	UInt16 result = [registerFileQuery getChannel];
	GHAssertEquals((int) result, (int) 2, nil);
}

- (void) test_getResponseLength_Throws {
	GHAssertThrows([registerFileQuery getResponseLength], nil);
}

- (void) test_updateWithResponse_Throws {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	GHAssertThrows([registerFileQuery updateWithResponse:buffer], nil);
}

- (void) test_execute_Throws {
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	GHAssertThrows([registerFileQuery execute:channel], nil);
}

@end
