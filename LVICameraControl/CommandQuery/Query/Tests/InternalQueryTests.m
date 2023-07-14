//
//  InternalQueryTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InternalQueryTests.h"
#import "StubControlChannel.h"

@implementation InternalQueryTests

- (void) setUp {
	internalQuery = [[[InternalQuery alloc] init] autorelease];
}

- (void) test_getCommand_Throws {
	GHAssertThrows([internalQuery getCommand], nil);
}

- (void) test_getChannel {
	UInt16 result = [internalQuery getChannel];
	GHAssertEquals((int) result, (int) 1, nil);
}

- (void) test_getResponseLength_Throws {
	GHAssertThrows([internalQuery getResponseLength], nil);
}

- (void) test_updateWithResponse_Throws {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	GHAssertThrows([internalQuery updateWithResponse:buffer], nil);
}

- (void) test_execute_Throws {
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	GHAssertThrows([internalQuery execute:channel], nil);
}

@end
