//
//  CommandTests.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GHUnit/GHUnit.h>
#import "Command.h"


@interface CommandTests : GHTestCase {
	Command* command;
}

- (void) assert:(ByteBuffer*) buffer isEqualTo:(UInt8[]) array;

@end
