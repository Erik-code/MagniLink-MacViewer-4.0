//
//  VideoWidthQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2015-04-10.
//  Copyright (c) 2015 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

@interface VideoWidthQuery : RegisterFileQuery
{
    @private int groupNumber;
    @private int width;
}

- (id) initWithGroup:(int) group;
-(int) getWidth;

@end
