//
//  ProductConfiguration.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProductConfigurationQuery.h"


@implementation ProductConfigurationQuery

- (id) init {
	self = [super init];
	if (self) {
		configuration = 0;
	}
	return self;
}

- (UInt16) getCommand {
	return 756;
}

- (UInt16) getResponseLength {
	return 4;
}

- (void) updateWithResponse: (ByteBuffer*) buffer {
	configuration = [buffer getSInt32At: 0];
}

- (int) getConfiguration {
	return configuration;
}
@end
