//
//  SetImageHeight.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetImageHeight.h"



@implementation SetImageHeight

- (id) initWithHeight: (UInt16) imageHeight {
	self = [super init];
	if (self) {
		height = imageHeight;
	}
	return self;
}

- (UInt16) getCommand {
	return 16;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	[buffer addUInt16: height];
}

@end
