//
//  SetUserAreaControl.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 1/29/11.
//  Copyright 2011 Prevas AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"

typedef enum {
	SetUserAreaControl_On,   // Enable write to user area
	SetUserAreaControl_Off   // Save user area and disable write 
} SetUserAreaControl_Command;

@interface SetUserAreaControl : RegisterFileCommand {
@private UInt8 commandCode;
}

- (id) initWithCommand:(SetUserAreaControl_Command) command;
@end
