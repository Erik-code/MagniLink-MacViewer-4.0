//
//  RegisterFileCommandTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RegisterFileCommandTests.h"
#import "RegisterFileCommand.h"
#import "StubControlChannel.h"

@implementation RegisterFileCommandTests

- (void) setUp {
	command = [[[RegisterFileCommand alloc] init] autorelease];
}

- (void) test_getCommand_Throws {
	GHAssertThrows([command getCommand], nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 0, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 2, nil);
}


- (void) test_execute_Throws {
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	GHAssertThrows([command execute:channel], nil);
}

@end
