//
//  SetImageWidthTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetImageWidthTests.h"
#import "SetImageWidth.h"
#import "StubControlChannel.h"

@implementation SetImageWidthTests

- (void) setUp {
	command = [[[SetImageWidth alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 18, nil);
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
	command = [[[SetImageWidth alloc] initWithWidth:530] autorelease];
	UInt8 commandData[] = {0x12, 0x80, 0x08, 0x00, 0x02, 0x00, 0x12, 0x02};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	command = [[[SetImageWidth alloc] initWithWidth:530] autorelease];
	UInt8 commandData[] = {0x12, 0x80, 0x08, 0x00, 0x02, 0x00, 0x12, 0x02};
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
}

@end
