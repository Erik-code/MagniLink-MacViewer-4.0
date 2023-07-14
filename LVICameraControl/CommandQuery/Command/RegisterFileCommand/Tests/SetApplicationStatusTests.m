//
//  SetApplicationStatusTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetApplicationStatusTests.h"
#import "SetApplicationStatus.h"
#import "StubControlChannel.h"

@implementation SetApplicationStatusTests

- (void) setUp {
	command = [[[SetApplicationStatus alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 9, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 1, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 2, nil);
}


- (void) test_encode_NotMinimized_NotLive_NotMegaPixel {
	command = [[[SetApplicationStatus alloc] initWithStatusMinimized:NO andLive:NO andMegaPixel:NO] autorelease];
	UInt8 commandData[] = {0x09, 0x80, 0x07, 0x00, 0x02, 0x00, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_Minimized_NotLive_NotMegaPixel {
	command = [[[SetApplicationStatus alloc] initWithStatusMinimized:YES andLive:NO andMegaPixel:NO] autorelease];
	UInt8 commandData[] = {0x09, 0x80, 0x07, 0x00, 0x02, 0x00, 0x40};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_NotMinimized_Live_NotMegaPixel {
	command = [[[SetApplicationStatus alloc] initWithStatusMinimized:NO andLive:YES andMegaPixel:NO] autorelease];
	UInt8 commandData[] = {0x09, 0x80, 0x07, 0x00, 0x02, 0x00, 0x20};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_NotMinimized_NotLive_MegaPixel {
	command = [[[SetApplicationStatus alloc] initWithStatusMinimized:NO andLive:NO andMegaPixel:YES] autorelease];
	UInt8 commandData[] = {0x09, 0x80, 0x07, 0x00, 0x02, 0x00, 0x10};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_Minimized_Live_MegaPixel {
	command = [[[SetApplicationStatus alloc] initWithStatusMinimized:YES andLive:YES andMegaPixel:YES] autorelease];
	UInt8 commandData[] = {0x09, 0x80, 0x07, 0x00, 0x02, 0x00, 0x70};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	command = [[[SetApplicationStatus alloc] initWithStatusMinimized:NO andLive:NO andMegaPixel:NO] autorelease];
	UInt8 commandData[] = {0x09, 0x80, 0x07, 0x00, 0x02, 0x00, 0x00};
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
}

@end
