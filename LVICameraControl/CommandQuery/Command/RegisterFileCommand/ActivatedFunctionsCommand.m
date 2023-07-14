//
//  ActivatedFunctionsCommand.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-08.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "ActivatedFunctionsCommand.h"

@implementation ActivatedFunctionsCommand

- (id) initWithCommand: (UInt32) command andLength:(UInt16)length;
{
    self = [super init];
    if(self){
        commandCode = command;
        commandLength = length;
    }
    return self;
}

- (UInt16) getCommand {
    return 0x94;
}

- (UInt16) getDataLength {
    return commandLength;
}

- (void) appendData: (ByteBuffer*) buffer
{
    [buffer addUInt8:commandCode & 0xFF];
}

@end
