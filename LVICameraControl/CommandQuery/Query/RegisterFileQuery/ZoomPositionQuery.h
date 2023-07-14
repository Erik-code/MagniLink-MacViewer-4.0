//
//  ZoomPositionQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-10-21.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

@interface ZoomPositionQuery : RegisterFileQuery
{
    @private uint16 zoomPos;
}

- (uint16) getZoomPos;
@end
