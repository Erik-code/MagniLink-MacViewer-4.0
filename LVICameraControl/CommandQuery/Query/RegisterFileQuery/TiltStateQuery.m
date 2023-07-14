//
//  TiltStateQuery.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TiltStateQuery.h"


@implementation TiltStateQuery

- (id) init {
	self = [super init];
	if (self) {
		tiltState = TiltState_Off;
	}
	return self;
}

- (UInt16) getCommand {
	return 1700;
}


- (UInt16) getResponseLength {
	return 1;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
	switch ([buffer getUInt8At:0]) {
		case 0:
			tiltState = TiltState_Reading; break;
		case 1:	
			tiltState = TiltState_Distance; break;
		case 2:	
			tiltState = TiltState_Off; break;
		default:
			tiltState = TiltState_Off;
	}
}

- (TiltState) getTiltState {
	return tiltState;	
}

@end
