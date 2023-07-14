//
//  SetVideoFrequencyControlProperty.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetVideoFrequency.h"

static const UInt8 TRIGGERBIT = 0x80;

@implementation SetVideoFrequency

- (id) initWithFrequency:(UInt8) f {
	self = [super init];
	if (self) {
		frequency = f;
	}
	return self;
}

- (UInt16) getCommand {
	return 79;
}

- (UInt16) getDataLength {
	return 1;
}

- (void) appendData: (ByteBuffer*) buffer {
	UInt8 data = frequency | TRIGGERBIT;
	[buffer addUInt8:data];	
}

@end
