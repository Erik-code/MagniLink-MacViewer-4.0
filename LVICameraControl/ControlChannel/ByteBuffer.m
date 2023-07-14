//
//  DataPackage.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ByteBuffer.h"
#import "MaskingOperations.h"

@interface ByteBuffer() 
- (BOOL) isEqualToByteBuffer:(ByteBuffer*) byteBuffer;
@end

@implementation ByteBuffer

- (void) addUInt8:(UInt8) data {
	if (bufferIndex < MAXBUFFERSIZE) {
		buffer[bufferIndex] = data;
		bufferIndex += 1;
	}
	else {
		NSException* exception = [NSException exceptionWithName:NSRangeException reason:@"buffer full" userInfo:nil];
		@throw exception;
	}
}

- (void) addUInt16:(UInt16) data {
	if (bufferIndex < MAXBUFFERSIZE-1) {
		buffer[bufferIndex] = [MaskingOperations getLowByte:data];
		bufferIndex += 1;
		buffer[bufferIndex] = [MaskingOperations getHighByte:data];
		bufferIndex += 1;
	}
	else {
		NSException* exception = [NSException exceptionWithName:NSRangeException reason:@"buffer full" userInfo:nil];
		@throw exception;
	}	
}

- (void) addUInt8Array:(UInt8[]) array ofLength:(UInt16) length {
	for (UInt16 i=0; i<length; ++i) {
		[self addUInt8:array[i]];
	}
}

- (UInt16) getBufferLength {
	return bufferIndex;
}

- (UInt8) getUInt8At: (UInt16) index {
	if (index < bufferIndex) {
		return buffer[index];
	}
	NSException* exception = [NSException exceptionWithName:NSRangeException reason:@"index greater than bufferIndex" userInfo:nil];
	@throw exception;
}

- (SInt32) getSInt32At: (UInt16) index {
	if (index < bufferIndex-3) {
		SInt32* p = (SInt32*) &(buffer[index]);
		return *p;
	}
	else {
		NSException* exception = [NSException exceptionWithName:NSRangeException reason:@"index greater than bufferIndex-4" userInfo:nil];
		@throw exception;
	}
}

- (NSString*) convertToString {
	return [[NSString alloc] initWithBytes:buffer length:bufferIndex encoding:NSASCIIStringEncoding];
}

- (NSData*) convertToData {
	return [NSData dataWithBytes:buffer length:bufferIndex];
}

- (BOOL) isContentEqualTo:(UInt8[]) array ofLength:(UInt16) length {
	if (array == NULL) {
		return bufferIndex == 0;
	}
	if (bufferIndex != length) {
		return NO;
	}
	for (int i=0; i<length; ++i) {
		if (buffer[i] != array[i]) {
			return NO;
		}
	}
	return YES;
}

- (BOOL) isEqualTo:(id)other {
	if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
	return [self isEqualToByteBuffer: other];
}

- (BOOL) isEqualToByteBuffer:(ByteBuffer*) byteBuffer {
	return [byteBuffer isContentEqualTo:buffer ofLength:bufferIndex];
}

@end
