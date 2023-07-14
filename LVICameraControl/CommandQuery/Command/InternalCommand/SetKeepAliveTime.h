//
//  SetKeepAlive.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InternalCommand.h"


@interface SetKeepAliveTime : InternalCommand {
@private UInt8 keepAliveTime;
}

- (id) initWithKeepAliveTimeInSeconds:(UInt8) time;

@end
