//
//  LVICameraControlTests.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GHUnit/GHUnit.h>
#import "LVICameraControl.h"
#import "StubControlChannel.h"

@interface LVICameraControlTests : GHTestCase {
	LVICameraControl* control;
	StubControlChannel* controlChannel;
}

@end
