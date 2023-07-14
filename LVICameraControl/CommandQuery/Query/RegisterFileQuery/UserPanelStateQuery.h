//
//  UserPanelStateQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2015-08-04.
//  Copyright (c) 2015 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

@interface UserPanelStateQuery : RegisterFileQuery
{
@private bool running;
}

- (id)init;
- (bool) isRunning;

@end
