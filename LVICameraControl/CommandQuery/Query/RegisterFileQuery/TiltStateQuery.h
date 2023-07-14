//
//  TiltStateProperty.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"


@interface TiltStateQuery : RegisterFileQuery {
@private TiltState tiltState;

}

- (TiltState) getTiltState;
@end
