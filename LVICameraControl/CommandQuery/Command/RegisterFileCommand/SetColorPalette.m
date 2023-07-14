//
//  SetColorPalette.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetColorPalette.h"

static const UInt8 TRIGGERBIT = 0x80;
static const UInt8 INCREASE_NATURAL = 0x02;
static const UInt8 DECREASE_NATURAL = 0x03;
static const UInt8 INCREASE_POSITIVE = 0x04;
static const UInt8 DECREASE_POSITIVE = 0x05;
static const UInt8 INCREASE_NEGATIVE = 0x06;
static const UInt8 DECREASE_NEGATIVE = 0x07;
static const UInt8 INCREASE_ARTIFICAL = 0x8;
static const UInt8 DECREASE_ARTIFICAL = 0x9;
static const UInt8 CONTROL_REGISTER = 0x10;

@interface SetColorPalette() 
- (UInt8) getColorPaletteCommandCode: (SetColorPaletteCommand) command;
@end

@implementation SetColorPalette

- (id) initWithCommand: (SetColorPaletteCommand) command {
	self = [super init];
	if (self) {
		colorPaletteCommandCode = [self getColorPaletteCommandCode:command];
	}
	return self;
}

- (UInt8) getColorPaletteCommandCode: (SetColorPaletteCommand) command {
	switch (command) {
		case SetColorPalette_IncreaseNaturalColors:
			return INCREASE_NATURAL;
		case SetColorPalette_DecreaseNaturalColors:
			return DECREASE_NATURAL;
		case SetColorPalette_IncreasePositiveColors:
			return INCREASE_POSITIVE;
		case SetColorPalette_DecreasePositiveColors:
			return DECREASE_POSITIVE;
		case SetColorPalette_IncreaseNegativeColors:
			return INCREASE_NEGATIVE;
		case SetColorPalette_DecreaseNegativeColors:
			return DECREASE_NEGATIVE;
		case SetColorPalette_IncreaseArtificialColors:
			return INCREASE_ARTIFICAL;
		case SetColorPalette_DecreaseArtificialColors:
			return DECREASE_ARTIFICAL;
        case SetColorPalette_FromControlRegister:
            return CONTROL_REGISTER;
		default:
			break;
	}
	return INCREASE_NATURAL;
}

- (UInt16) getCommand {
	return 94;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	UInt8 data = colorPaletteCommandCode | TRIGGERBIT;
	[buffer addUInt8:data];
	[buffer addUInt8:0];
}
@end
