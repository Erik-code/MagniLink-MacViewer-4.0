//
//  VideoHeightQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2015-04-10.
//  Copyright (c) 2015 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

@interface VideoHeightQuery : RegisterFileQuery
{
    @private int groupNumber;
    @private int height;
}

- (id) initWithGroup:(int) group;
-(int) getHeight;
@end
