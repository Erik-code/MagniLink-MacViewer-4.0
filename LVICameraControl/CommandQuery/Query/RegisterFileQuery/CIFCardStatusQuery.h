//
//  CIFCardStatusQuery.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"

@interface CIFCardStatusQuery : RegisterFileQuery {
@private CIFCardStatus status;
}

- (CIFCardStatus) getStatus;
@end
