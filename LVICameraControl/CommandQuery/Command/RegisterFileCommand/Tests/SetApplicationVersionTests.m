//
//  SetApplicationVersionTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetApplicationVersionTests.h"
#import "SetApplicationVersion.h"
#import "StubControlChannel.h"

@implementation SetApplicationVersionTests

- (void) setUp {
	command = [[[SetApplicationVersion alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 20, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 8, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 2, nil);
}

- (void) test_encode {
	command = [[[SetApplicationVersion alloc] initWithVersion:@"ABCDE"] autorelease];
	UInt8 commandData[] = {0x14, 0x80, 0x0E, 0x00, 0x02, 0x00, ' ', ' ', ' ', 'A', 'B', 'C', 'D', 'E'};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	command = [[[SetApplicationVersion alloc] initWithVersion:@"ABCDE"] autorelease];
	UInt8 commandData[] = {0x14, 0x80, 0x0E, 0x00, 0x02, 0x00, ' ', ' ', ' ', 'A', 'B', 'C', 'D', 'E'};
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
}


@end
