//
//  ReferenceLineWidthCommand.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-08.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "ReferenceLineWidthCommand.h"

@implementation ReferenceLineWidthCommand

-(id) initWithCommand:(UInt16)command
{
    self = [super init];
    if(self){
        commandCode = command;
    }
    return self;
}

- (UInt16) getCommand {
    return 0x33C;
}

- (UInt16) getDataLength {
    return 2;
}

- (void) appendData: (ByteBuffer*) buffer
{
}

@end
