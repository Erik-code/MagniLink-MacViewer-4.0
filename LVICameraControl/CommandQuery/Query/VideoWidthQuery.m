//
//  VideoWidthQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2015-04-10.
//  Copyright (c) 2015 Prevas AB. All rights reserved.
//

#import "VideoWidthQuery.h"

@implementation VideoWidthQuery

- (id)initWithGroup:(int) group
{
    self = [super init];
    groupNumber = group;
    return self;
}

- (UInt16) getCommand {
	return 332 + groupNumber * 56;
}

- (UInt16) getResponseLength {
	return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
    width = [buffer getUInt8At:0];
    width += [buffer getUInt8At:1] << 8;
}

- (int) getWidth
{
    return width;
}

@end
