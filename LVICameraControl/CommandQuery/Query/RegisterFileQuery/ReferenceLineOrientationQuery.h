//
//  ReferenceLineOrientationQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-11-11.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"

@interface ReferenceLineOrientationQuery : RegisterFileQuery
{
    @private uint16 refLineOrientation;
}

- (uint16) getVal;
- (ReferenceLineType) getRefLineType;
- (ReferenceLineOrient) getRefLineOrientation;

@end
