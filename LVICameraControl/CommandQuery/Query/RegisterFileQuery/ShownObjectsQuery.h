//
//  ShownObjects.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-05-23.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

@interface ShownObjectsQuery : RegisterFileQuery
{
@private uint8 shownObjects;    
}

- (uint8) getShownObjects;

@end
