//
//  VersionRegisterFile.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VersionRegisterFileQuery.h"

static const UInt16 VERSION_STRING_LENGTH = 8;

@interface VersionRegisterFileQuery() 
- (void) setVersion:(NSString*) v;
@end

@implementation VersionRegisterFileQuery


- (void) dealloc {
}

- (UInt16) getCommand {
	return 0;
}


- (UInt16) getResponseLength {
	return VERSION_STRING_LENGTH;
}

- (void) updateWithResponse: (ByteBuffer*) response {
	NSString* newVersion = [response convertToString];
	[self setVersion:[newVersion stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (NSString*) getVersion {
	return version;
}

- (void) setVersion:(NSString*) v {
	version = v;
}
@end
