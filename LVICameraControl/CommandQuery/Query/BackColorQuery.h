//
//  ColorGroupQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-05-09.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

@interface BackColorQuery : RegisterFileQuery
{
@private NSColor* backColor;
@private int groupNumber;
}

- (id)initWithGroup:(int) group;
- (NSColor*) getBackColor;

@end
