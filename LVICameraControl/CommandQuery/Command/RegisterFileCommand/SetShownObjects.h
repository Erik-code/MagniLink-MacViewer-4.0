//
//  SetShownObjects.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-05-23.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"

@interface SetShownObjects : RegisterFileCommand{
@private uint8 shownObjectsCommandCode;
}

- (id) initWithCommand: (uint8) command;

@end
