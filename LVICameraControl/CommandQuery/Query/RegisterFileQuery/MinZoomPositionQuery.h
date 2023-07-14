//
//  MinZoomPositionQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-10-27.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"

@interface MinZoomPositionQuery : RegisterFileQuery
{
    @private uint16 zoomPosition;
    @private TiltState tiltState;
}

- (id)initWithTiltState:(TiltState) state;
- (uint16) getZoomPosition;
@end
