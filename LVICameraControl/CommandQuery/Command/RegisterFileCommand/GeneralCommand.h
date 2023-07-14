//
//  GeneralCommand.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-09.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface GeneralCommand : RegisterFileCommand

- (id) initWithCommand:(UInt16)command andLength:(UInt16)length andData:(SInt32)data;

@end

NS_ASSUME_NONNULL_END
