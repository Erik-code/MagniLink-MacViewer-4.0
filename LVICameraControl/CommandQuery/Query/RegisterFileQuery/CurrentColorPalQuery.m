//
//  CurrentColorPalQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-05-09.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "CurrentColorPalQuery.h"

@implementation CurrentColorPalQuery

- (id) init {
	self = [super init];
	return self;
}

- (UInt16) getCommand {
	return 1670;
}

- (UInt16) getResponseLength {
	return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
	UInt8 byte = [buffer getUInt8At : 0];
	colorPal = (byte & 0x0F);
	type =  (byte >> 6) & 0x3;
}

- (ColorPalette) getColorPal {
	return colorPal;
}

- (ColorPaletteType) getType {
    return type;
}

@end
