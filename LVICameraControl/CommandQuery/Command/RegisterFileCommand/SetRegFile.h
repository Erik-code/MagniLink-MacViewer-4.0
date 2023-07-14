//
//  SetRegFile.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-07.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetRegFile : RegisterFileCommand
{
    @private UInt8 commandCode;
}

- (id) initWithCommand: (UInt8) command;

@end

NS_ASSUME_NONNULL_END
