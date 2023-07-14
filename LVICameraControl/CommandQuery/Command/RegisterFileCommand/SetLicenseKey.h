//
//  SetLicenseKey.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 1/29/11.
//  Copyright 2011 Prevas AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"

#define MAX_LICENSE_KEY_LENGTH 16
@interface SetLicenseKey : RegisterFileCommand {
@private NSData* license_key;
}

- (id) initWithKey:(NSData*) aKey;

@end
