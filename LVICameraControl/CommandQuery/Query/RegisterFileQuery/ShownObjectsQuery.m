//
//  ShownObjects.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-05-23.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "ShownObjectsQuery.h"

@implementation ShownObjectsQuery

- (id) init {
	self = [super init];
	if (self) {
		shownObjects = 0;
	}
	return self;
}

- (UInt16) getCommand {
	return 1690;
}

- (UInt16) getResponseLength {
	return 1;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
	shownObjects = [buffer getUInt8At:0];
}

-(uint8) getShownObjects{
    return shownObjects;
}

@end
