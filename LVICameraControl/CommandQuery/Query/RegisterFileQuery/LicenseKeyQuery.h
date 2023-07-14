//
//  LicenseKeyQuery.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 12/12/10.
//  Copyright 2010 Prevas AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"


@interface LicenseKeyQuery : RegisterFileQuery {
@private NSData* key;
}

- (NSData*) getLicenseKey;

@end
