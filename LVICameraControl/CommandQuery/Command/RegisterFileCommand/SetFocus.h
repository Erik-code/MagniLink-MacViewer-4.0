//
//  SetFocus.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2015-08-04.
//  Copyright (c) 2015 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"

typedef enum {
    SetFocus_Stop,
    SetFocus_In,
    SetFocus_Out
} SetFocusCommand;

@interface SetFocus : RegisterFileCommand {
@private UInt8 focusCommandCode;
}

- (id) initWithCommand: (SetFocusCommand) command;

@end
