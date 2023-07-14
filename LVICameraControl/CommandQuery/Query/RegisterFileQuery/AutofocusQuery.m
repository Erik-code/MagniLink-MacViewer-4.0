//
//  AutofocusQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2012-05-09.
//  Copyright 2012 Prevas AB. All rights reserved.
//

#import "AutofocusQuery.h"


@implementation AutofocusQuery

- (id) init {
	self = [super init];
	if (self) {
		autofocusState = Autofocus_On;
	}
	return self;
}

- (UInt16) getCommand {
	return 1658;
}


- (UInt16) getResponseLength {
	return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
	uint8 bits = [buffer getUInt8At:0];
	bits = (bits & 0x80) >> 7;
	switch (bits) {
		case 0:
			autofocusState = Autofocus_Off; break;
		case 1:	
			autofocusState = Autofocus_On; break;
		default:
			autofocusState = Autofocus_On;
	}
}

- (AutofocusState) getAutofocusState {
	return autofocusState;	
}


@end
