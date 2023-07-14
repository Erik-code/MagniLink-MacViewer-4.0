//
//  IsZoomingQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-09-16.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "IsZoomingQuery.h"

@implementation IsZoomingQuery

- (id) init {
    self = [super init];
    if (self) {
        zoom = NO;
    }
    return self;
}

- (UInt16) getCommand {
    return 84;
}

- (UInt16) getResponseLength {
    return 2;
}

- (void) updateWithResponse: (ByteBuffer*) buffer
{
    uint16 low = [buffer getUInt8At:0];
    zoom = (low & 0x80) != 0;
}

-(BOOL) isZooming{
    return zoom;
}

@end
