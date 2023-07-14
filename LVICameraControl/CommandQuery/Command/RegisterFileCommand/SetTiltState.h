//
//  EnableTiltState.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"
#import "CameraControlTypes.h"

@interface SetTiltState : RegisterFileCommand {
@private UInt8 stateCode;
}

- (id) initWithState: (TiltState) state;
@end
