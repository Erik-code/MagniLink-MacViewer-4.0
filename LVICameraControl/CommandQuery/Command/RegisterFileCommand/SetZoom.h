//
//  SetZoom.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"

typedef enum {
	SetZoom_Stop,
	SetZoom_In,
	SetZoom_Out,
    SetZoom_Position,
} SetZoomCommand;

@interface SetZoom : RegisterFileCommand {
@private UInt8 zoomCommandCode; 
}

- (id) initWithCommand: (SetZoomCommand) command;

@end
