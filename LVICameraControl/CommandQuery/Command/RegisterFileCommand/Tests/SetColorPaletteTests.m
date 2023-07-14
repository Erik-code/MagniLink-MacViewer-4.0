//
//  SetPaletteTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetColorPaletteTests.h"
#import "SetColorPalette.h"
#import "StubControlChannel.h"

@implementation SetColorPaletteTests

- (void) setUp {
	command = [[[SetColorPalette alloc] init] autorelease];
}

- (void) test_getCommand {
	UInt16 result = [command getCommand];
	GHAssertEquals((int) result, 94, nil);
}

- (void) test_getDataLength {
	UInt16 dataLength = [command getDataLength];
	GHAssertEquals((int) dataLength, 2, nil);
}

- (void) test_getChannel {
	UInt16 result = [command getChannel];
	GHAssertEquals((int) result, 2, nil);
}

- (void) test_encode_IncreaseNatural {
	command = [[[SetColorPalette alloc] initWithCommand:SetColorPalette_IncreaseNaturalColors] autorelease];
	UInt8 increaseNaturalPlusTrigg = 0x02 | 0x80;
	UInt8 commandData[] = {0x5E, 0x80, 0x08, 0x00, 0x02, 0x00, increaseNaturalPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_DecreaseNatural {
	command = [[[SetColorPalette alloc] initWithCommand:SetColorPalette_DecreaseNaturalColors] autorelease];
	UInt8 decreaseNaturalPlusTrigg = 0x03 | 0x80;
	UInt8 commandData[] = {0x5E, 0x80, 0x08, 0x00, 0x02, 0x00, decreaseNaturalPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_IncreasePositive {
	command = [[[SetColorPalette alloc] initWithCommand:SetColorPalette_IncreasePositiveColors] autorelease];
	UInt8 increasePositivePlusTrigg = 0x04 | 0x80;
	UInt8 commandData[] = {0x5E, 0x80, 0x08, 0x00, 0x02, 0x00, increasePositivePlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_DecreasePositive {
	command = [[[SetColorPalette alloc] initWithCommand:SetColorPalette_DecreasePositiveColors] autorelease];
	UInt8 decreasePositivePlusTrigg = 0x05 | 0x80;
	UInt8 commandData[] = {0x5E, 0x80, 0x08, 0x00, 0x02, 0x00, decreasePositivePlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_IncreaseNegative {
	command = [[[SetColorPalette alloc] initWithCommand:SetColorPalette_IncreaseNegativeColors] autorelease];
	UInt8 increaseNegativePlusTrigg = 0x06 | 0x80;
	UInt8 commandData[] = {0x5E, 0x80, 0x08, 0x00, 0x02, 0x00, increaseNegativePlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_DecreaseNegative {
	command = [[[SetColorPalette alloc] initWithCommand:SetColorPalette_DecreaseNegativeColors] autorelease];
	UInt8 decreaseNegativePlusTrigg = 0x07 | 0x80;
	UInt8 commandData[] = {0x5E, 0x80, 0x08, 0x00, 0x02, 0x00, decreaseNegativePlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_IncreaseArtifical {
	command = [[[SetColorPalette alloc] initWithCommand:SetColorPalette_IncreaseArtificialColors] autorelease];
	UInt8 increaseArtificialPlusTrigg = 0x08 | 0x80;
	UInt8 commandData[] = {0x5E, 0x80, 0x08, 0x00, 0x02, 0x00, increaseArtificialPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_encode_DecreaseArtifical {
	command = [[[SetColorPalette alloc] initWithCommand:SetColorPalette_DecreaseArtificialColors] autorelease];
	UInt8 decreaseArtificialPlusTrigg = 0x09 | 0x80;
	UInt8 commandData[] = {0x5E, 0x80, 0x08, 0x00, 0x02, 0x00, decreaseArtificialPlusTrigg, 0x00};
	[self assert:[command encode] isEqualTo:commandData];
}

- (void) test_execute {
	command = [[[SetColorPalette alloc] initWithCommand:SetColorPalette_DecreaseArtificialColors] autorelease];
	UInt8 decreaseArtificialPlusTrigg = 0x09 | 0x80;
	UInt8 commandData[] = {0x5E, 0x80, 0x08, 0x00, 0x02, 0x00, decreaseArtificialPlusTrigg, 0x00};
	StubControlChannel* channel = [[[StubControlChannel alloc] init] autorelease];
	
	[command execute:channel];
	
	[self assert:[channel getWriteBufferAtIndex:0] isEqualTo:commandData];
}
@end
