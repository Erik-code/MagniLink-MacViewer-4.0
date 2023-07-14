//
//  PackageReference.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageReference.h"

@interface MessageReference() 
- (void) incrementCounter;
@end

@implementation MessageReference


- (UInt16) createMarker {
	[self incrementCounter];
	return counter << 8;
}

- (void) incrementCounter {
	counter += 1;
	if (counter == 0xFF) {
		counter = 0x01;
	}
}

@end
