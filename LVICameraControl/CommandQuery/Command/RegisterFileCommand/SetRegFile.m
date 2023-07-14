//
//  SetRegFile.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-07.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "SetRegFile.h"

@implementation SetRegFile

- (id) initWithCommand: (uint8) command {
    self = [super init];
    if (self) {
        commandCode = command;
    }
    return self;
}

- (UInt16) getCommand {
    return 0x0618;
}

- (UInt16) getDataLength {
    return 1;
}

- (void) appendData: (ByteBuffer*) buffer {
    
    [buffer addUInt8:commandCode];
}

@end
