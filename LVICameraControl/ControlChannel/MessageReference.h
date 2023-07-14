//
//  MessageReference.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MessageReference : NSObject {
@private UInt8 counter;
}

- (UInt16) createMarker;
@end
