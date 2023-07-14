//
//  ControlChannelFactory.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ControlChannelFactory.h"
#import "USBControlChannel.h"

@implementation ControlChannelFactory

- (id<ControlChannel>) createControlChannel {
	USBControlChannel* channel = [[USBControlChannel alloc] init];
	[channel setupInterface];
	return channel;
}


@end
