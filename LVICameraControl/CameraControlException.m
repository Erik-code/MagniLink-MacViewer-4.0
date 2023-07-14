//
//  ControlChannelException.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraControlException.h"


@implementation CameraControlException

+ (NSException*) create: (NSString*) reason {
	return [CameraControlException exceptionWithName:@"CameraControlException" reason:reason userInfo:nil];
}
@end
