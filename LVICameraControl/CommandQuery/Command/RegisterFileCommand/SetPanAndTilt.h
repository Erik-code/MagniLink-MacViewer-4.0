//
//  SetPanAndTilt.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2012-06-08.
//  Copyright 2012 Prevas AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"

typedef enum {
	SetPanAndTilt_Stop_Stop,
	
	SetPanAndTilt_Left_Stop,
	SetPanAndTilt_Right_Stop,
	SetPanAndTilt_Left_Up,
	SetPanAndTilt_Right_Up,
	
	SetPanAndTilt_Left_Down,
	SetPanAndTilt_Right_Down,
	
	SetPanAndTilt_Stop_Down,
	SetPanAndTilt_Stop_Up,
	
} SetPanAndTiltCommand;

@interface SetPanAndTilt : RegisterFileCommand {
@private UInt8 panAndTiltCommandCode;
}

- (id) initWithCommand: (SetPanAndTiltCommand) command;

@end
