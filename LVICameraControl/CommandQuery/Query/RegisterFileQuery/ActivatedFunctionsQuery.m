//
//  ActivatedFunctionsQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-08.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "ActivatedFunctionsQuery.h"

@implementation ActivatedFunctionsQuery

- (UInt16) getCommand {
    return 0x94;
}

- (UInt16) getResponseLength {
    return 4;
}

- (void) updateWithResponse: (ByteBuffer*) buffer
{
    val = [buffer getUInt8At:0];
    if((val & 0xC) == 0xC){
        mFunctions = BothActive;
    }
    else if((val & 0x4) == 0x4){
        mFunctions = LineActive;
    }
    else if((val & 0x8) == 0x8){
        mFunctions = CurtainActive;
    }
}

-(ActivatedFunctions) getActivatedFunctions
{
    return mFunctions;
}

-(UInt8) getVal
{
    return val;
}

@end
