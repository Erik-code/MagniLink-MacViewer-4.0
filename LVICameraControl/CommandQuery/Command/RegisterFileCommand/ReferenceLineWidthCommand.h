//
//  ReferenceLineWidthCommand.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-08.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReferenceLineWidthCommand : RegisterFileCommand
{
    @private UInt16 commandCode;
}

- (id) initWithCommand: (UInt16) command;

@end

NS_ASSUME_NONNULL_END
