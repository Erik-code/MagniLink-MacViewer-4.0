//
//  GeneralQuery.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-09.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "GeneralQuery.h"

@interface GeneralQuery()
{
    UInt16 mCommand;
    UInt16 mLength;
    SInt32 mData;
}
@end

@implementation GeneralQuery

- (id) initWithCommand:(UInt16)command andLength:(UInt16)length {
    self = [super init];
    if (self) {
        mCommand = command;
        mLength = length;
    }
    return self;
}

- (UInt16) getCommand {
    return mCommand;
}

- (UInt16) getResponseLength {
    return mLength;
}

- (void) updateWithResponse: (ByteBuffer*) buffer
{
    mData = 0;
    for(int i = 0 ; i < [buffer getBufferLength] ; i++)
    {
        mData = mData | ([buffer getUInt8At:i] << i*8);
    }
}

- (SInt32) getData
{
    return mData;
}

@end
