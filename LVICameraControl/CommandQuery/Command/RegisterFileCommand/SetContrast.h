//
//  SetContrast.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"

typedef enum {
	SetContrast_Stop,
	SetContrast_Increase,
	SetContrast_Decrease,
	SetContrast_Middle,
	SetContrast_Manual,
	SetContrast_Auto
} SetContrastCommand;

@interface SetContrast : RegisterFileCommand {
@private UInt8 contrastCommandCode;
}

- (id) initWithCommand:(SetContrastCommand) command;

@end
