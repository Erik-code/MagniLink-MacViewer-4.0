//
//  VideoGenQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2015-04-10.
//  Copyright (c) 2015 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

@interface VideoGenQuery : RegisterFileQuery
{
    @private int groupNumber;
    @private bool usb;
    @private bool interlaced;
}

- (id)initWithGroup:(int) group;
- (bool)isUsb;
- (bool)isInterlaced;
@end
