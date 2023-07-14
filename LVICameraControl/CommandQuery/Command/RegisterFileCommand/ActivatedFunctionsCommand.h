//
//  ActivatedFunctionsCommand.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-08.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivatedFunctionsCommand : RegisterFileCommand
{
    @private UInt32 commandCode;
    @private UInt16 commandLength;
}

- (id) initWithCommand: (UInt32) command andLength:(UInt16)length;

@end

NS_ASSUME_NONNULL_END
