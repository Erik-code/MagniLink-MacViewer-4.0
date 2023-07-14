//
//  ControlChannelException.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CameraControlException : NSException {
}

+ (NSException*) create:(NSString*) reason;

@end
