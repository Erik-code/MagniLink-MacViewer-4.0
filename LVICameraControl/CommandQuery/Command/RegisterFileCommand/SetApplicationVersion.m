//
//  SetApplicationVersion.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetApplicationVersion.h"

@interface SetApplicationVersion() 

- (void) initVersion;
- (void) setVersion: (NSString*) applicationVersion;

@end

@implementation SetApplicationVersion



- (id) initWithVersion: (NSString*) applicationVersion {
	self = [super init];
	if (self) {
		[self initVersion];
		[self setVersion:applicationVersion];
	}
	return self;	
}

- (void) initVersion {
	for (int i=0; i<MAX_STRING_LENGTH; ++i) {
		version[i] = (UInt8) ' ';
	}
}

- (void) setVersion: (NSString*) applicationVersion {
	if (applicationVersion) {
		UInt8 buffer[MAX_STRING_LENGTH];
		NSUInteger usedBufferCount;
		NSRange range;
		NSUInteger versionLength = [applicationVersion length];
		range.location = 0;
		range.length = (versionLength > MAX_STRING_LENGTH) ? MAX_STRING_LENGTH : versionLength;
		(void) [applicationVersion getBytes:buffer maxLength:MAX_STRING_LENGTH 
								   usedLength:&usedBufferCount 
								   encoding:NSASCIIStringEncoding 
								   options:NSStringEncodingConversionAllowLossy 
								   range:range 
								   remainingRange:NULL];
		int indexInVersion = MAX_STRING_LENGTH-1;
		for (int indexInBuffer = MAX_STRING_LENGTH-1; indexInBuffer >= 0; --indexInBuffer) {
			if (buffer[indexInBuffer] != 0) {
				version[indexInVersion] = (UInt8) buffer[indexInBuffer];
				indexInVersion -= 1;
			}
		}
	}
}

- (UInt16) getCommand {
	return 20;
}

- (UInt16) getDataLength {
	return MAX_STRING_LENGTH;
}

- (void) appendData: (ByteBuffer*) buffer {
	for (int i=0; i<MAX_STRING_LENGTH; ++i) {
		[buffer addUInt8:version[i]];
	}
}


@end
