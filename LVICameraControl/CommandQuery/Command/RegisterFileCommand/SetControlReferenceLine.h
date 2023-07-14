//
//  SetControlReferenceLine.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-11-10.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"

@interface SetControlReferenceLine : RegisterFileCommand
{
    @private uint16 refLinePosition;
}

- (id) initWithPosition: (uint16) position;

@end
