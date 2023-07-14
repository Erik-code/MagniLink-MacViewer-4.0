//
//  LicenseKeyQuery.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 12/12/10.
//  Copyright 2010 Prevas AB. All rights reserved.
//

#import "LicenseKeyQuery.h"


static const UInt16 KEY_STRING_LENGTH = 16;

@interface LicenseKeyQuery() 

- (void) setLicenseKey:(NSData*) aKey;

@end

@implementation LicenseKeyQuery

- (id) init {
	self = [super init];
	if (self) {
		key = [NSData data];
	}
	return self;
}

- (void) dealloc {
}

- (NSData*) getLicenseKey {
	return key;
}

- (void) setLicenseKey:(NSData*)aKey {
	key = aKey ;
}

- (UInt16) getCommand {
	return 1360;
}

- (UInt16) getResponseLength {
	return KEY_STRING_LENGTH;
}

- (void) updateWithResponse:(ByteBuffer *)response {
	[self setLicenseKey:[response convertToData]];
}

@end
