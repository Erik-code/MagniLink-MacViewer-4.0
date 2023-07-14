//
//  StubControlChannelFactory.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ControlChannelFactory.h"


@interface StubControlChannelFactory : ControlChannelFactory {
	id<ControlChannel> controlChannel;
}

- (void) setChannelToReturn:(id<ControlChannel>) channel;
@end
