//
//  MaskingOperationsTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MaskingOperationsTests.h"
#import "MaskingOperations.h"


@implementation MaskingOperationsTests

- (void) test_getLowByte {
	UInt16 x = 0x1234;
	UInt8 result = [MaskingOperations getLowByte:x];
	GHAssertEquals((int)result, (int) 0x34, nil);
}

- (void) test_getHighByte {
	UInt16 x = 0x1234;
	UInt8 result = [MaskingOperations getHighByte:x];
	GHAssertEquals((int) result, (int)0x12, nil);
}

- (void) test_setHighByte {
	UInt8 x = 0x34;
	UInt16 result = [MaskingOperations setHighByte:x];
	GHAssertEquals((int) result, (int) 0x3400, nil);
}
@end
