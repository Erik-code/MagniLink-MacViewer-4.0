//
//  ForeColorQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-05-12.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

@interface ForeColorQuery : RegisterFileQuery
{
@private NSColor* foreColor;
@private int groupNumber;
}

- (id)initWithGroup:(int) group;
- (NSColor*) getForeColor;

@end
