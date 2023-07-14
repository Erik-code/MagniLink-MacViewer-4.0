//
//  ReferenceLineQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-11-10.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "ReferenceLineQuery.h"

@implementation ReferenceLineQuery

- (id) init {
	self = [super init];
	if (self) {
		refLinePosition = 0;
	}
	return self;
}

- (UInt16) getCommand {
	return 1680;
}

- (UInt16) getResponseLength {
	return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
    uint16 low = [buffer getUInt8At:0];
    uint16 high = [buffer getUInt8At:1];
    
	refLinePosition = low + (high << 8);
}

-(uint16) getRefLinePosition{
    return refLinePosition;
}

@end
