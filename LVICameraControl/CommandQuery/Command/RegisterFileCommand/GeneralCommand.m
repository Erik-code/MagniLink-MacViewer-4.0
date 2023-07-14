//
//  GeneralCommand.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-09.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "GeneralCommand.h"
#import "regFileDef_D39419A.h"

@interface GeneralCommand()
{
    UInt16 mCommand;
    UInt16 mLength;
    SInt32 mData;
}
@end

@implementation GeneralCommand

- (id) initWithCommand:(UInt16)command andLength:(UInt16)length andData:(SInt32)data
{
    self = [super init];
    if(self)
    {
        mCommand = command;
        mLength = length;
        mData = data;
    }
    return self;
}

- (UInt16) getCommand {
    return mCommand;
}

- (UInt16) getDataLength {
    return mLength;
}

- (void) appendData: (ByteBuffer*) buffer
{
    [buffer addUInt16:mData & 0xFFFF];
    [buffer addUInt16:mData >> 16];
}


@end
