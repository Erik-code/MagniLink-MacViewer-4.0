//
//  ControlChannel.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ByteBuffer.h"


@protocol ControlChannel<NSObject>

- (void) write: (ByteBuffer*) buffer; 
- (ByteBuffer*) read:(UInt16) numberOfBytes;
- (int) getDeviceSpeed;
@end
