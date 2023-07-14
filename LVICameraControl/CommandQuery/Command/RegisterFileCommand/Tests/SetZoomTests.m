//
//  SetZoomTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetZoomTests.h"
#import "SetZoom.h"
#import "StubControlChannel.h"

@implementation SetZoomTests

- (void) setUp {
	command = [[[SetZoom alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 84, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 2, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 2, nil);
}

- (void) test_encode_ZoomStop {
	command = [[[SetZoom alloc] initWithCommand:SetZoom_Stop] autorelease];
	UInt8 stopPlusTrigg = 0x00 | 0x80;
	UInt8 commandData[] = {0x54, 0x80, 0x08, 0x00, 0x02, 0x00, stopPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
	
}

- (void) test_encode_ZoomIn {
	command = [[[SetZoom alloc] initWithCommand:SetZoom_In] autorelease];
	UInt8 inPlusTrigg = 0x02 | 0x80;
	UInt8 commandData[] = {0x54, 0x80, 0x08, 0x00, 0x02, 0x00, inPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_ZoomOut {
	command = [[[SetZoom alloc] initWithCommand:SetZoom_Out] autorelease];
	UInt8 outPlusTrigg = 0x01 | 0x80;
	UInt8 commandData[] = {0x54, 0x80, 0x08, 0x00, 0x02, 0x00, outPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	command = [[[SetZoom alloc] initWithCommand:SetZoom_Out] autorelease];
	UInt8 outPlusTrigg = 0x01 | 0x80;
	UInt8 commandData[] = {0x54, 0x80, 0x08, 0x00, 0x02, 0x00, outPlusTrigg, 0x00};
	
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
}

@end
