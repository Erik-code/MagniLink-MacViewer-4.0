//
//  QueryTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QueryTests.h"
#import "StubControlChannel.h";


@implementation QueryTests

- (void) setUp {
	query = [[[Query alloc] init] autorelease];
}

- (void) test_getCommand_Throws {
	GHAssertThrows([query getCommand], nil);
}

- (void) test_getChannel_Throws {
	GHAssertThrows([query getChannel], nil);
}

- (void) test_getResponseLength_Throws {
	GHAssertThrows([query getResponseLength], nil);
}

- (void) test_updateWithResponse_Throws {
	ByteBuffer* buffer = [[[ByteBuffer alloc] init] autorelease];
	GHAssertThrows([query updateWithResponse:buffer], nil);
}

- (void) test_execute_Throws {
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	GHAssertThrows([query execute:channel], nil);
}

- (void) assert:(ByteBuffer*) buffer isEqualTo:(UInt8[]) array {
	GHAssertTrue([buffer isContentEqualTo:array ofLength:[buffer getBufferLength]],nil);
}

@end
