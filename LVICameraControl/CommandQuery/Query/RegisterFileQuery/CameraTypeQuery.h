//
//  CameraTypeQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2012-06-13.
//  Copyright 2012 Prevas AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"

@interface CameraTypeQuery : RegisterFileQuery {
@private CameraType cameraType;	
}

- (CameraType) getCameraType;

@end
