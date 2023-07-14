//
//  SetImageHeightTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetImageHeightTests.h"
#import "SetImageHeight.h"
#import "StubControlChannel.h"

@implementation SetImageHeightTests

- (void) setUp {
	command = [[[SetImageHeight alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 16, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 2, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 2, nil);
}

- (void) test_encode {
	command = [[[SetImageHeight alloc] initWithHeight:400] autorelease];
	UInt8 commandData[] = {0x10, 0x80, 0x08, 0x00, 0x02, 0x00, 0x90, 0x01};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	command = [[[SetImageHeight alloc] initWithHeight:400] autorelease];
	UInt8 commandData[] = {0x10, 0x80, 0x08, 0x00, 0x02, 0x00, 0x90, 0x01};
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
}

@end
