//
//  StubControlChannelFactory.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StubControlChannelFactory.h"
#import "StubControlChannel.h"

@implementation StubControlChannelFactory

- (id<ControlChannel>) createControlChannel {
	return controlChannel;
}

- (void) setChannelToReturn:(id<ControlChannel>) channel {
	[controlChannel autorelease];
	controlChannel = channel;
	[controlChannel retain];
}

@end
