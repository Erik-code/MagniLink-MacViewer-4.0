//
//  SetApplicationStatus.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegisterFileCommand.h"

@interface SetApplicationStatus : RegisterFileCommand {
@private UInt8 status;
}

- (id) initWithStatusMinimized: (BOOL) minimized  andLive:(BOOL) live andMegaPixel:(BOOL) megapixel;

@end
