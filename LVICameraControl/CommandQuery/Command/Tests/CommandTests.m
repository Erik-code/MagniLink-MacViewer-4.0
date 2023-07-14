//
//  CommandTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CommandTests.h"
#import "StubControlChannel.h"


@implementation CommandTests

- (void) setUp {
	command = [[[Command alloc] init] autorelease];
}

- (void) test_getCommand_Throws {
	GHAssertThrows([command getCommand], nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 0, nil);
}

- (void) test_getChannel_Throws {
	GHAssertThrows([command getChannel], nil);
}


- (void) test_execute_Throws {
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	GHAssertThrows([command execute:channel], nil);
}

- (void) assert:(ByteBuffer*) buffer isEqualTo:(UInt8[]) array {
	GHAssertTrue([buffer isContentEqualTo:array ofLength:[buffer getBufferLength]],nil);
}

@end
