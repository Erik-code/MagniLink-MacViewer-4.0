//
//  USBControlChannel.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "USBControlChannel.h"
#import "CameraControlException.h"
#import "MaskingOperations.h"

#include <IOKit/IOCFPlugIn.h>

static const int VENDOR_ID = 0x1904;
static const int PRODUCT_ID = 0x0001;
static const UInt16 UVC_CONTROL_INTERFACE_CLASS = 14;
static const UInt16 UVC_CONTROL_INTERFACE_SUBCLASS = 1;
static const UInt8 UVC_SET_CUR = 0x01;
static const UInt8 UVC_GET_CUR = 0x81;
static const UInt16 UVC_BRIGHTNESS_CONTROL = 0x0200; 
static const UInt16 UVC_BRIGHTNESS_CONTROL_LENGTH = 2;
static const UInt16 UVC_PROCESSING_UNIT = 0x0200;

@interface USBControlChannel() 
- (void) initializeControllerInterface;
- (io_service_t) getService;
- (IOCFPlugInInterface**) getPlugInInterface: (io_service_t) service ofClientType: (CFUUIDRef) clientType;
- (IOUSBDeviceInterface**) getUSBDeviceInterface: (io_service_t) service;
- (IOUSBInterfaceInterface**) getUSBControllerInterface: (IOUSBDeviceInterface**) usbDeviceInterface;
- (io_iterator_t) createInterfaceIterator: (IOUSBDeviceInterface**) usbDeviceInterface;
- (void) initializeReadControlRequest;
- (void) initializeWriteControlRequest;
- (void) writeUInt16:(UInt16) data;
- (UInt16) readUInt16;
- (void) open;
- (void) close;
- (void) unlock;
@end

@implementation USBControlChannel 

- (id) init {
	self = [super init];
	if (self) {
		messageReference = [[MessageReference alloc] init];
		[self initializeReadControlRequest];
		[self initializeWriteControlRequest];
	}
	return self;
}

- (void) dealloc {
	if (usbControllerInterface) {
		(*usbControllerInterface)->USBInterfaceClose(usbControllerInterface);
		(*usbControllerInterface)->Release(usbControllerInterface);
		usbControllerInterface = NULL;	
	}
}

- (void) setupInterface {
	[self initializeControllerInterface];
	[self unlock];
}

- (void) unlock {
	UInt16 unlockSequence[] = {0x5E03, 0x1B25, 0x42FD, 0x7B1B, 0x07A3};
	int unlockSequenceLength = 5;
	[self open];
	for (int i=0; i<unlockSequenceLength; ++i) {
		[self writeUInt16:unlockSequence[i]];
	}
	[self close];
}

- (void) write:(ByteBuffer*)buffer {
	[self open];
	UInt16 referenceMarker = [messageReference createMarker]; 
	UInt16 bufferLength = [buffer getBufferLength];
	for (UInt16 i = 0; i<bufferLength; ++i) {
		UInt8 data = [buffer getUInt8At: i];
		UInt16 dataToSend = referenceMarker | data;
		[self writeUInt16: dataToSend];
	}
	[self close];
}

- (ByteBuffer*) read:(UInt16) numberOfBytes {
	ByteBuffer* buffer = [[ByteBuffer alloc] init];
	[self open];
	for (UInt16 i=0; i<numberOfBytes; ++i) {
		UInt16 receivedData = [self readUInt16];
		UInt8 dataToSave = [MaskingOperations getLowByte:receivedData];
		[buffer addUInt8:dataToSave];
	}
	return buffer;
}

- (void) open {
    
	kern_return_t openResult = (*usbControllerInterface)->USBInterfaceOpen(usbControllerInterface);
	if (openResult != kIOReturnSuccess) {
		//NSException* exception = [CameraControlException create:@"Failed to open interface"];
		//@throw exception;
	}
}

- (int) getDeviceSpeed{
    IOUSBDeviceInterface ** dev = [self getUSBDeviceInterface:[self getService]];
    uint8 speed = 0;
    (*dev)->GetDeviceSpeed(dev,&speed);
    return speed;
}

- (void) writeUInt16:(UInt16) data {
	writeControlRequest.wLenDone = 0;
	writeControlRequest.pData = &data;
	kern_return_t result = (*usbControllerInterface)->ControlRequest(usbControllerInterface, 0, &writeControlRequest);
	if (result != kIOReturnSuccess || writeControlRequest.wLenDone != UVC_BRIGHTNESS_CONTROL_LENGTH) {
		NSException* exception = [CameraControlException create:@"Failed to send data"];
		@throw exception;
	}
	// NSLog(@"Sending 0x%02x", data);
}

- (UInt16) readUInt16 {
	UInt16 data = 0;
	readControlRequest.wLenDone = 0;
	readControlRequest.pData = &data;
	kern_return_t result = (*usbControllerInterface)->ControlRequest(usbControllerInterface, 0, &readControlRequest);
	if (result != kIOReturnSuccess || readControlRequest.wLenDone != UVC_BRIGHTNESS_CONTROL_LENGTH) {
		NSException* exception = [CameraControlException create:@"Failed to read data"];
		@throw exception;
	}
	return data;
}

- (void) close {
	kern_return_t closeResult = (*usbControllerInterface)->USBInterfaceClose(usbControllerInterface);
	if (closeResult != kIOReturnSuccess) {
		NSException* exception = [CameraControlException create:@"Failed to close interface"];
		@throw exception;
	}
}

- (void) initializeControllerInterface {
	io_service_t service = [self getService];
	IOUSBDeviceInterface** deviceInterface = [self getUSBDeviceInterface:service];
	(void) IOObjectRelease(service);
	usbControllerInterface = [self getUSBControllerInterface: deviceInterface];
}

- (io_service_t) getService {
	CFMutableDictionaryRef dictionary = IOServiceMatching(kIOUSBDeviceClassName);
	CFNumberRef vendorId = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &VENDOR_ID);
	CFNumberRef productId = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &PRODUCT_ID);
	CFDictionarySetValue(dictionary, CFSTR(kUSBVendorID), vendorId);
	CFDictionarySetValue(dictionary, CFSTR(kUSBProductID), productId);
	io_service_t result = IOServiceGetMatchingService(kIOMasterPortDefault, dictionary);
	CFRelease(vendorId);
	CFRelease(productId);
	if (!result) {
		NSException* exception = [CameraControlException create:@"Failed to get service"];
		@throw exception;
	}
	return result;
}

- (IOUSBDeviceInterface**) getUSBDeviceInterface : (io_service_t) service {
    NSLog(@"Enter getUSBDeviceInterface");
	IOCFPlugInInterface** pluginInterface = [self getPlugInInterface: service ofClientType:kIOUSBDeviceUserClientTypeID];
	NSLog(@"getUSBDeviceInterface 1");
    IOUSBDeviceInterface** deviceInterface = NULL;
	HRESULT result = (*pluginInterface)->QueryInterface(pluginInterface, CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID), (LPVOID*) &deviceInterface);
    NSLog(@"getUSBDeviceInterface kIOUSBDeviceInterfaceID650 QueryInterface %d", result);

	(*pluginInterface)->Release(pluginInterface);
	if (result || deviceInterface == NULL) {

		NSString* reason = [NSString stringWithFormat:@"QueryInterface returned %d", result];
		NSException* exception = [CameraControlException create:reason];
		@throw exception;
	}
	return deviceInterface;	
}


- (IOCFPlugInInterface**) getPlugInInterface: (io_service_t) service ofClientType: (CFUUIDRef) clientType {
	IOCFPlugInInterface** pluginInterface = NULL;
	SInt32 score;
	kern_return_t kernelReturn = IOCreatePlugInInterfaceForService(service, clientType, kIOCFPlugInInterfaceID, &pluginInterface, &score);
	if ((kernelReturn != kIOReturnSuccess) || !pluginInterface) {
		NSString* reason = [NSString stringWithFormat:@"IOCreatePlugInInterface returned 0x%08x", kernelReturn];
		NSException* exception = [CameraControlException create:reason];
		@throw exception;
	}
	return pluginInterface;
}

- (IOUSBInterfaceInterface**) getUSBControllerInterface:(IOUSBDeviceInterface **)usbDeviceInterface {
	io_iterator_t interfaceIterator = [self createInterfaceIterator: usbDeviceInterface];
	io_service_t service = IOIteratorNext(interfaceIterator);
	IOCFPlugInInterface** pluginInterface = [self getPlugInInterface:service ofClientType:kIOUSBInterfaceUserClientTypeID];
	(void) IOObjectRelease(service);
	IOUSBInterfaceInterface** controllerInterface = NULL;
	HRESULT result = (*pluginInterface)->QueryInterface(pluginInterface, CFUUIDGetUUIDBytes(kIOUSBInterfaceInterfaceID), (LPVOID*) &controllerInterface);
	(*pluginInterface)->Release(pluginInterface);
	if (result || !controllerInterface) {
		NSString* reason = [NSString stringWithFormat:@"QueryInterface returned %d", result];
		NSException* exception = [CameraControlException create:reason];
		@throw exception;
	}
	return controllerInterface; 
}

- (io_iterator_t) createInterfaceIterator: (IOUSBDeviceInterface**) usbDeviceInterface {
	io_iterator_t interfaceIterator;
	IOUSBFindInterfaceRequest interfaceRequest;
	interfaceRequest.bInterfaceClass = UVC_CONTROL_INTERFACE_CLASS;
	interfaceRequest.bInterfaceSubClass = UVC_CONTROL_INTERFACE_SUBCLASS;
	interfaceRequest.bInterfaceProtocol = kIOUSBFindInterfaceDontCare;
	interfaceRequest.bAlternateSetting = kIOUSBFindInterfaceDontCare;
	IOReturn success = (*usbDeviceInterface)->CreateInterfaceIterator(usbDeviceInterface, &interfaceRequest, &interfaceIterator);
	if (success != kIOReturnSuccess) {
		NSString* reason = [NSString stringWithFormat:@"CreateInterfaceIterator returned %d", success];
		NSException* exception = [CameraControlException create:reason];
		@throw exception;
	}
	return interfaceIterator;
}

- (void) initializeWriteControlRequest {
	writeControlRequest.bmRequestType = USBmakebmRequestType(kUSBOut, kUSBClass, kUSBInterface);
	writeControlRequest.bRequest = UVC_SET_CUR;
	writeControlRequest.wValue = UVC_BRIGHTNESS_CONTROL;
	writeControlRequest.wIndex = UVC_PROCESSING_UNIT;
	writeControlRequest.wLength = UVC_BRIGHTNESS_CONTROL_LENGTH;
}

- (void) initializeReadControlRequest {
	readControlRequest.bmRequestType = USBmakebmRequestType(kUSBIn, kUSBClass, kUSBInterface);
	readControlRequest.bRequest = UVC_GET_CUR;
	readControlRequest.wValue = UVC_BRIGHTNESS_CONTROL;
	readControlRequest.wIndex = UVC_PROCESSING_UNIT;
	readControlRequest.wLength = UVC_BRIGHTNESS_CONTROL_LENGTH;
}

	
@end



