//
//  SetImageWidth.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetImageWidth.h"


@implementation SetImageWidth

- (id) initWithWidth: (UInt16) imageWidth {
	self = [super init];
	if (self) {
		width = imageWidth;
	}
	return self;
}

- (UInt16) getCommand {
	return 18;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	[buffer addUInt16: width];
}

@end
