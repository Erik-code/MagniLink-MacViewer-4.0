//
//  SetControlReferenceLineOrientation.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-11-11.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"
#import "CameraControlTypes.h"

@interface SetControlReferenceLineOrientation : RegisterFileCommand
{
    @private uint16 refLineOrientation;
}

- (id) initWithType: (ReferenceLineType)type andOrientation:(ReferenceLineOrient)orientation;

- (id) initWithVal: (uint16)val;

@end
