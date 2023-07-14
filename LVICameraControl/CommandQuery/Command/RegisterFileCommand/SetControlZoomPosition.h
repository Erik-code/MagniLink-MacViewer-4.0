//
//  SetControlZoomPosition.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-10-24.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"

@interface SetControlZoomPosition : RegisterFileCommand
{
    @private uint16 zoomPosition;
}

- (id) initWithPosition: (uint16) position;

@end
