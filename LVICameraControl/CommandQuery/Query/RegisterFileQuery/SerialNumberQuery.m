//
//  SerialKeyQuery.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 12/5/10.
//  Copyright 2010 Prevas AB. All rights reserved.
//

#import "SerialNumberQuery.h"

static const UInt16 KEY_STRING_LENGTH = 16;

@interface SerialNumberQuery() 

- (void) setSerialNumber:(NSString*) aSerialNumber;

@end


@implementation SerialNumberQuery


- (void) dealloc {
}

- (NSString*) getSerialNumber {
	return serialNumber;
}

- (void) setSerialNumber:(NSString*)aSerialNumber {
	serialNumber = aSerialNumber;
}

- (UInt16) getCommand {
	return 760;
}

- (UInt16) getResponseLength {
	return KEY_STRING_LENGTH;
}

- (void) updateWithResponse:(ByteBuffer *)response {
	NSString* newSerial = [response convertToString];
	[self setSerialNumber:[newSerial stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

@end
