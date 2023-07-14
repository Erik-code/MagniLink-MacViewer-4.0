//
//  CryptoKeyQuery.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 12/12/10.
//  Copyright 2010 Prevas AB. All rights reserved.
//

#import "CryptoKeyQuery.h"


static const UInt16 KEY_STRING_LENGTH = 16;

@interface CryptoKeyQuery() 

- (void) setCryptoKey:(NSData*) aKey;

@end

@implementation CryptoKeyQuery

- (id) init {
	self = [super init];
	if (self) {
		key = [NSData data];
	}
	return self;
}

- (void) dealloc {
}

- (NSData*) getCryptoKey {
	return key;
}

- (void) setCryptoKey:(NSData*)aKey {
	key = aKey;
}

- (UInt16) getCommand {
	return 776;
}

- (UInt16) getResponseLength {
	return KEY_STRING_LENGTH;
}

- (void) updateWithResponse:(ByteBuffer *)response {
	[self setCryptoKey:[response convertToData]];
}

@end
