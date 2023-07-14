//
//  SetReferenceLines.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"


typedef enum {
	SetReferenceLine_DownOrRight,
	SetReferenceLine_UpOrLeft,
	SetReferenceLine_Stop,
    SetReferenceLine_GotoPosition
} SetReferenceLine_Command;

@interface SetReferenceLine : RegisterFileCommand {
@private UInt8 referenceLineCommandCode;
}

- (id) initWithCommand:(SetReferenceLine_Command) command;

@end
