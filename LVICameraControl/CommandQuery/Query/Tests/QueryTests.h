//
//  QueryTests.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GHUnit/GHUnit.h>
#import "Query.h"


@interface QueryTests : GHTestCase {
	Query* query;
}

- (void) assert:(ByteBuffer*) buffer isEqualTo:(UInt8[]) array;
@end
