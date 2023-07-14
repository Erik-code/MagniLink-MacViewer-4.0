//
//  StubControlChannel.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ControlChannel.h"

#define MAX_NUMBER_OF_BUFFERS 20

@interface StubControlChannel : NSObject<ControlChannel> {
	ByteBuffer* writeBuffers[MAX_NUMBER_OF_BUFFERS];
	ByteBuffer* readBuffers[MAX_NUMBER_OF_BUFFERS];
	int writeBufferIndex;
	int readBufferIndex;
	int currentReadBufferIndex;
}

- (void) addReadBuffer: (ByteBuffer*) buffer;
- (ByteBuffer*) getWriteBufferAtIndex:(int) index;
- (int) getNumberOfWriteBuffers;
- (void) resetWriteBuffers;
@end
