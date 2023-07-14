//
//  SetColorPalette.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"

typedef enum {
	SetColorPalette_IncreaseNaturalColors,
	SetColorPalette_DecreaseNaturalColors,	
	SetColorPalette_IncreasePositiveColors,
	SetColorPalette_DecreasePositiveColors,
	SetColorPalette_IncreaseNegativeColors,
	SetColorPalette_DecreaseNegativeColors,
	SetColorPalette_IncreaseArtificialColors,
	SetColorPalette_DecreaseArtificialColors,
    SetColorPalette_FromControlRegister,
} SetColorPaletteCommand;

@interface SetColorPalette : RegisterFileCommand {
@private UInt8 colorPaletteCommandCode; 
}

- (id) initWithCommand: (SetColorPaletteCommand) command;

@end
