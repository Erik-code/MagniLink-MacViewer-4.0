//
//  SetLicenseKey.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 1/29/11.
//  Copyright 2011 Prevas AB. All rights reserved.
//

#import "SetLicenseKey.h"

static const UInt16 MAX_KEY_STRING_LENGTH = 16;


@implementation SetLicenseKey

- (id) initWithKey:(NSData*) aKey {
	self = [super init];
	if (self) {
		license_key = aKey;
	}
	return self;
}

- (void) dealloc {
}

- (UInt16) getCommand {
	return 1360;
}

- (UInt16) getDataLength {
	return MAX_KEY_STRING_LENGTH;
}

- (void) appendData: (ByteBuffer*) buffer {
	UInt16 bytesToCopy = MAX_KEY_STRING_LENGTH;
	if ([license_key length] < MAX_KEY_STRING_LENGTH) {
		bytesToCopy = (UInt16) [license_key length];
	}
	char* bufferPtr = (char*) [license_key bytes];	
	UInt16 copiedBytes = 0;
	for (; copiedBytes < bytesToCopy; ++copiedBytes) {
		UInt8 current = (UInt8) *bufferPtr;
		[buffer addUInt8:current];
		bufferPtr++;
	}
	for (; copiedBytes < MAX_KEY_STRING_LENGTH; ++copiedBytes) {
		[buffer addUInt8:0];
	}
}

@end
