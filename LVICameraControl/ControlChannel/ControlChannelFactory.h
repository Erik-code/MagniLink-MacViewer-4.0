//
//  ControlChannelFactory.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ControlChannel.h"

@interface ControlChannelFactory : NSObject {

}

- (id<ControlChannel>) createControlChannel;

@end
