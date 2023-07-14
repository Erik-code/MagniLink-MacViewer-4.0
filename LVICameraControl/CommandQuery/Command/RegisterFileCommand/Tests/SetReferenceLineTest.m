//
//  SetReferenceLinesTest.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetReferenceLineTest.h"
#import "SetReferenceLine.h"
#import "StubControlChannel.h"

@implementation SetReferenceLineTest

- (void) setUp {
	command = [[[SetReferenceLine alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 98, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 2, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 2, nil);
}

- (void) test_encode_Stop {
	command = [[[SetReferenceLine alloc] initWithCommand:SetReferenceLine_Stop] autorelease];
	UInt8 commandData[] = {0x62, 0x80, 0x08, 0x00, 0x02, 0x00, 0x00, 0x80};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_DownOrRight {
	command = [[[SetReferenceLine alloc] initWithCommand:SetReferenceLine_DownOrRight] autorelease];
	UInt8 commandData[] = {0x62, 0x80, 0x08, 0x00, 0x02, 0x00, 0x03, 0x80};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_UpOrLeft {
	command = [[[SetReferenceLine alloc] initWithCommand:SetReferenceLine_UpOrLeft] autorelease];
	UInt8 commandData[] = {0x62, 0x80, 0x08, 0x00, 0x02, 0x00, 0x02, 0x80};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	command = [[[SetReferenceLine alloc] initWithCommand:SetReferenceLine_Stop] autorelease];
	UInt8 commandData[] = {0x62, 0x80, 0x08, 0x00, 0x02, 0x00, 0x00, 0x80};
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
	
}
@end
