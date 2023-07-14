//
//  SetKeepAliveTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetKeepAliveTimeTests.h"
#import "SetKeepAliveTime.h"
#import	"StubControlChannel.h"

@implementation SetKeepAliveTimeTests

- (void) setUp {
	command = [[[SetKeepAliveTime alloc] initWithKeepAliveTimeInSeconds:0] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, (int) 0x03, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 0, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 1, nil);
}


- (void) test_encode_ZeroTime {
	UInt8 commandData[] = {0x03, 0x80, 0x06, 0x00, 0x01, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_TwentyTime {
	UInt8 commandData[] = {0x03, 0x94, 0x06, 0x00, 0x01, 0x00};
	command = [[[SetKeepAliveTime alloc] initWithKeepAliveTimeInSeconds:20] autorelease];
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	UInt8 commandData[] = {0x03, 0x80, 0x06, 0x00, 0x01, 0x00};
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
}

@end
