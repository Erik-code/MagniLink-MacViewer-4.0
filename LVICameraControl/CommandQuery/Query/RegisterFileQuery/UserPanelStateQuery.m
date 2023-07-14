//
//  UserPanelStateQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2015-08-04.
//  Copyright (c) 2015 Prevas AB. All rights reserved.
//

#import "UserPanelStateQuery.h"

@implementation UserPanelStateQuery

- (id)init
{
    self = [super init];
    return self;
}

- (UInt16) getCommand {
	return 1704;
}

- (UInt16) getResponseLength {
	return 4;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {    
    uint i = [buffer getUInt8At:3];
    running = (i & 0x80) == 0;
}

- (bool) isRunning {
	return running;
}


@end
