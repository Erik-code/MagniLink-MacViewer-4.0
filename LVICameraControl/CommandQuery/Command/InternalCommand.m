//
//  InternalCommand.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InternalCommand.h"

static const UInt16 INTERNAL_CHANNEL = 1;

@implementation InternalCommand

- (UInt16) getChannel {
	return INTERNAL_CHANNEL;	
}
@end
