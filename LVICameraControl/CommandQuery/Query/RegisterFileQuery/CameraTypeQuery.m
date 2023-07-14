//
//  CameraTypeQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2012-06-13.
//  Copyright 2012 Prevas AB. All rights reserved.
//

#import "CameraTypeQuery.h"


@implementation CameraTypeQuery

- (id) init {
	self = [super init];
	return self;
}

- (UInt16) getCommand {
	return 145;
}

- (UInt16) getResponseLength {
	return 1;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
	UInt8 byte = [buffer getUInt8At : 0];
	cameraType = byte;
}

- (CameraType) getCameraType {
	return cameraType;
}


@end
