//
//  PanAndTiltQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2012-06-08.
//  Copyright 2012 Prevas AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"

@interface PanAndTiltQuery : RegisterFileQuery {
@private PanStateDistance panState;
@private TiltStateDistance tiltState;
	
};

- (PanStateDistance) getPanState;
- (TiltStateDistance) getTiltState;


@end
