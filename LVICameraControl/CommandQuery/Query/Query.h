//
//  Query.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ControlChannel.h"


@interface Query : NSObject {

}

- (void) execute: (id<ControlChannel>) channel;
- (UInt16) getCommand;
- (UInt16) getResponseLength;
- (UInt16) getChannel;
- (void) updateWithResponse: (ByteBuffer*) response;
- (ByteBuffer*) encode;

@end
