//
//  IsZoomingQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-09-16.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface IsZoomingQuery : RegisterFileQuery
{
    @private bool zoom;
}

- (BOOL) isZooming;

@end

NS_ASSUME_NONNULL_END
