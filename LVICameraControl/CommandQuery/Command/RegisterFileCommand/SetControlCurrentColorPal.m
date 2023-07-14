//
//  SetControlCurrentColorPal.m
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-06-05.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "SetControlCurrentColorPal.h"

@implementation SetControlCurrentColorPal

- (id) initWithCommand: (ColorPalette) command {
self = [super init];
if (self) {
    setControlCurrentColorPalCommandCode = command;
}
return self;	
}

- (UInt16) getCommand {
	return 1552;
}

- (UInt16) getDataLength {
	return 2;
}

- (void) appendData: (ByteBuffer*) buffer {
	UInt8 data = setControlCurrentColorPalCommandCode;
	[buffer addUInt8:data];
    [buffer addUInt8:0];
}


@end
