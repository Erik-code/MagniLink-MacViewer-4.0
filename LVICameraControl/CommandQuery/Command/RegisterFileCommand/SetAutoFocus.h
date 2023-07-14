//
//  SetAutoFocus.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2012-05-09.
//  Copyright 2012 Prevas AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"

typedef enum {
	SetAutofocus_Stop,
	SetAutofocus_On,
	SetAutofocus_Off
} SetAutofocusCommand;

@interface SetAutofocus : RegisterFileCommand {
@private UInt8 autofocusCommandCode;
}

- (id) initWithCommand: (SetAutofocusCommand) command;

@end
