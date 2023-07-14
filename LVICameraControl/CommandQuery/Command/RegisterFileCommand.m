//
//  RegisterFileCommand.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RegisterFileCommand.h"

static const UInt16 REGISTER_FILE_CHANNEL = 2;

@implementation RegisterFileCommand

- (UInt16) getChannel {
	return REGISTER_FILE_CHANNEL;	
}

@end
