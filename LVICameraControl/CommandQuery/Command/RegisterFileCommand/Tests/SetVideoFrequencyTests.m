//
//  SetVideoFrequencyTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetVideoFrequencyTests.h"
#import "SetVideoFrequency.h"
#import "StubControlChannel.h"

@implementation SetVideoFrequencyTests

- (void) setUp {
	command = [[[SetVideoFrequency alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 79, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 1, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 2, nil);
}

- (void) test_encode {
	command = [[[SetVideoFrequency alloc] initWithFrequency:60] autorelease];
	UInt8 sixtyPlusTrigg = 0x3C | 0x80;
	UInt8 commandData[] = {0x4F, 0x80, 0x07, 0x00, 0x02, 0x00, sixtyPlusTrigg};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	command = [[[SetVideoFrequency alloc] initWithFrequency:60] autorelease];
	UInt8 sixtyPlusTrigg = 0x3C | 0x80;
	UInt8 commandData[] = {0x4F, 0x80, 0x07, 0x00, 0x02, 0x00, sixtyPlusTrigg};
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
	
}

@end
