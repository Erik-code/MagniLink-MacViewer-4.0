//
//  KeepAliveTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KeepAliveTests.h"
#import "KeepAlive.h"
#import "StubControlChannel.h"

@implementation KeepAliveTests

- (void) setUp {
	command = [[[KeepAlive alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 2, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 0, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 1, nil);
}


- (void) test_encode {
	UInt8 commandData[] = {0x02, 0x80, 0x06, 0x00, 0x01, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	UInt8 commandData[] = {0x02, 0x80, 0x06, 0x00, 0x01, 0x00};
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
}
@end
