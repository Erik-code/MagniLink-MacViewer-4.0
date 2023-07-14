//
//  CameraControl.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CameraControl.h"
#import "ControlChannel.h"
#import "ControlChannelFactory.h"
#import "CameraControlTypes.h"


@interface LVICameraControl : NSObject<CameraControl> {
@private NSString* registerFileVersion;
@private ControlChannelFactory* controlChannelFactory;
@private id<ControlChannel> controlChannel;
@private NSTimer* keepAliveTimer;

}

- (id) initWithControlChannelFactory: (ControlChannelFactory*) factory;

@end
