//
//  GeneralQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-09.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface GeneralQuery : RegisterFileQuery

- (id) initWithCommand:(UInt16)command andLength:(UInt16)length;

- (SInt32) getData;

@end

NS_ASSUME_NONNULL_END
