//
//  SetControlCurrentColorPal.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-06-05.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"
#import "CameraControlTypes.h"

@interface SetControlCurrentColorPal : RegisterFileCommand
{
    @private ColorPalette setControlCurrentColorPalCommandCode;
}

- (id) initWithCommand: (ColorPalette) command;

@end
