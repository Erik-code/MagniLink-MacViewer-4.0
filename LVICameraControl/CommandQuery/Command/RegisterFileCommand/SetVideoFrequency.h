//
//  SetVideoFrequency.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"


@interface SetVideoFrequency : RegisterFileCommand {
@private UInt8 frequency;
}

- (id) initWithFrequency:(UInt8) f;
@end
