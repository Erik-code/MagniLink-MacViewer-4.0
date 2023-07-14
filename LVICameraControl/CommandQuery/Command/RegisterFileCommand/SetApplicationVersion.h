//
//  SetApplicationVersion.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"

#define MAX_STRING_LENGTH 8

@interface SetApplicationVersion : RegisterFileCommand {
@private UInt8 version[MAX_STRING_LENGTH];
}

- (id) initWithVersion: (NSString*) applicationVersion;

@end
