//
//  ActivatedFunctionsQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-08.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivatedFunctionsQuery : RegisterFileQuery
{
    ActivatedFunctions mFunctions;
    UInt8 val;
}

-(ActivatedFunctions) getActivatedFunctions;
-(UInt8) getVal;

@end

NS_ASSUME_NONNULL_END
