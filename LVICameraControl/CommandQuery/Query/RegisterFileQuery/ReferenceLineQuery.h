//
//  ReferenceLineQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-11-10.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

@interface ReferenceLineQuery : RegisterFileQuery
{
    @private uint16 refLinePosition;
}

- (uint16) getRefLinePosition;

@end
