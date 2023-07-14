//
//  SetKeepAliveProperty.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetKeepAliveTime.h"
#import "MaskingOperations.h"

static const UInt16 KEEPALIVECOMMAND = 0x0003; 

@implementation SetKeepAliveTime

- (id) initWithKeepAliveTimeInSeconds: (UInt8) time {
	self = [super init];
	if (self) {
		keepAliveTime = time;
	}
	return self;
}

- (UInt16) getCommand {
	UInt16 command = [MaskingOperations setHighByte:keepAliveTime];
	command |= KEEPALIVECOMMAND;
	return command;
		
}

@end
