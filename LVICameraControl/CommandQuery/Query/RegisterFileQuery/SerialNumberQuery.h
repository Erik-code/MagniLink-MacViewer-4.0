//
//  SerialKeyQuery.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 12/5/10.
//  Copyright 2010 Prevas AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"

@interface SerialNumberQuery : RegisterFileQuery {
@private NSString* serialNumber;
}

- (NSString*) getSerialNumber;
@end
