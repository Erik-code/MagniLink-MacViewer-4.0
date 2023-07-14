//
//  USBControlChannel.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ControlChannel.h"
#include <IOKit/usb/IOUSBLib.h>
#include "MessageReference.h"

@interface USBControlChannel : NSObject <ControlChannel> {
@private IOUSBInterfaceInterface** usbControllerInterface;
@private IOUSBDevRequest writeControlRequest;
@private IOUSBDevRequest readControlRequest;
@private int getDeviceSpeed;
@private MessageReference* messageReference;
}

- (void) setupInterface;

@end
