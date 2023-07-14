//
//  SetContrastTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetContrastTests.h"
#import "SetContrast.h"
#import "StubControlChannel.h"

@implementation SetContrastTests

- (void) setUp {
	command = [[[SetContrast alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 96, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 2, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 2, nil);
}

- (void) test_encode_ContrastStop {
	command = [[[SetContrast alloc] initWithCommand:SetContrast_Stop] autorelease];
	UInt8 stopPlusTrigg = 0x00 | 0x80;
	UInt8 commandData[] = {0x60, 0x80, 0x08, 0x00, 0x02, 0x00, stopPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_ContrastIncrease {
	command = [[[SetContrast alloc] initWithCommand:SetContrast_Increase] autorelease];
	UInt8 morePlusTrigg = 0x03 | 0x80;
	UInt8 commandData[] = {0x60, 0x80, 0x08, 0x00, 0x02, 0x00, morePlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_ContrastDecrease {
	command = [[[SetContrast alloc] initWithCommand:SetContrast_Decrease] autorelease];
	UInt8 lessPlusTrigg = 0x02 | 0x80;
	UInt8 commandData[] = {0x60, 0x80, 0x08, 0x00, 0x02, 0x00, lessPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_ContrastMiddle {
	command = [[[SetContrast alloc] initWithCommand:SetContrast_Middle] autorelease];
	UInt8 middlePlusTrigg = 0x01 | 0x80;
	UInt8 commandData[] = {0x60, 0x80, 0x08, 0x00, 0x02, 0x00, middlePlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_ContrastManual {
	command = [[[SetContrast alloc] initWithCommand:SetContrast_Manual] autorelease];
	UInt8 manualPlusTrigg = 0x04 | 0x80;
	UInt8 commandData[] = {0x60, 0x80, 0x08, 0x00, 0x02, 0x00, manualPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_ContrastAuto {
	command = [[[SetContrast alloc] initWithCommand:SetContrast_Auto] autorelease];
	UInt8 autoPlusTrigg = 0x06 | 0x80;
	UInt8 commandData[] = {0x60, 0x80, 0x08, 0x00, 0x02, 0x00, autoPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	command = [[[SetContrast alloc] initWithCommand:SetContrast_Auto] autorelease];
	UInt8 autoPlusTrigg = 0x06 | 0x80;
	UInt8 commandData[] = {0x60, 0x80, 0x08, 0x00, 0x02, 0x00, autoPlusTrigg, 0x00};
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
}

@end
