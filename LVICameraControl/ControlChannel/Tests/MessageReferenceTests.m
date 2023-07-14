//
//  MessageReferenceTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageReferenceTests.h"


@implementation MessageReferenceTests

- (void) setUp {
	reference = [[[MessageReference alloc] init] autorelease];
}

- (void) test_createMarker {
	UInt16 marker = [reference createMarker];
	GHAssertEquals((int) marker, (int) 0x0100, nil);
}

- (void) test_createMaker_Incremented {
	UInt16 marker = [reference createMarker];
	marker = [reference createMarker];
	GHAssertEquals((int) marker, (int) 0x0200, nil);
}

- (void) test_createMarker_WrapAround {
	for (UInt8 i = 1; i < 0xFF; ++i) {
		(void) [reference createMarker];
	}
	UInt16 marker = [reference createMarker];
	GHAssertEquals((int) marker, (int) 0x0100, nil);
}
@end
