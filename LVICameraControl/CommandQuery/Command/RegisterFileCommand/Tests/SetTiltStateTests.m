//
//  SetTiltStateTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetTiltStateTests.h"
#import "StubControlChannel.h"
#import "SetTiltState.h"

@implementation SetTiltStateTests

- (void) setUp {
	command = [[[SetTiltState alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 100, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 1, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 2, nil);
}

- (void) test_encode_Off {
	command = [[[SetTiltState alloc] initWithState:TiltState_Off] autorelease];
	UInt8 offPlusTrigg = 0x02 | 0x80;
	UInt8 commandData[] = {0x64, 0x80, 0x07, 0x00, 0x02, 0x00, offPlusTrigg};
	[self assert:[command encode] isEqualTo:commandData];
	
}

- (void) test_encode_Reading {
	command = [[[SetTiltState alloc] initWithState:TiltState_Reading] autorelease];
	UInt8 readingPlusTrigg = 0x00 | 0x80;
	UInt8 commandData[] = {0x64, 0x80, 0x07, 0x00, 0x02, 0x00, readingPlusTrigg};
	[self assert:[command encode] isEqualTo:commandData];
	
}

- (void) test_encode_Distance {
	command = [[[SetTiltState alloc] initWithState:TiltState_Distance] autorelease];
	UInt8 distancePlusTrigg = 0x01 | 0x80;
	UInt8 commandData[] = {0x64, 0x80, 0x07, 0x00, 0x02, 0x00, distancePlusTrigg};
	[self assert:[command encode] isEqualTo:commandData];
	
}

- (void) test_execute {
	command = [[[SetTiltState alloc] initWithState:TiltState_Off] autorelease];
	UInt8 offPlusTrigg = 0x02 | 0x80;
	UInt8 commandData[] = {0x64, 0x80, 0x07, 0x00, 0x02, 0x00, offPlusTrigg};
	
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
}

@end
