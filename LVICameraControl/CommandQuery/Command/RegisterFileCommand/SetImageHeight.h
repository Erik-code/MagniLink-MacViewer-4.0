//
//  SetImageHeight.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"

@interface SetImageHeight : RegisterFileCommand {
@private UInt16 height;
}

- (id) initWithHeight: (UInt16) imageHeight;
@end
