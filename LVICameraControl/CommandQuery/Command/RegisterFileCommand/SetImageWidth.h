//
//  SetImageWidth.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"


@interface SetImageWidth : RegisterFileCommand {
@private UInt16 width;
}

- (id) initWithWidth: (UInt16) imageWidth;

@end
