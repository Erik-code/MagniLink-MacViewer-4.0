//
//  VideoHeightQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2015-04-10.
//  Copyright (c) 2015 Prevas AB. All rights reserved.
//

#import "VideoHeightQuery.h"

@implementation VideoHeightQuery

- (id)initWithGroup:(int) group
{
    self = [super init];
    groupNumber = group;
    return self;
}

- (UInt16) getCommand {
	return 316 + groupNumber * 56;
}

- (UInt16) getResponseLength {
	return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
    height = [buffer getUInt8At:0];
    height += [buffer getUInt8At:1] << 8;
}

- (int) getHeight
{
    return height;
}

@end
