//
//  StubControlChannel.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StubControlChannel.h"


@implementation StubControlChannel

- (void) dealloc {
	for (int i=0; i<MAX_NUMBER_OF_BUFFERS; ++i) {
		[writeBuffers[i] release];
		[readBuffers[i] release];
	}
	[super dealloc];
}

- (void) write: (ByteBuffer*) buffer {
	if (writeBufferIndex < MAX_NUMBER_OF_BUFFERS) {
		writeBuffers[writeBufferIndex] = buffer;
		[writeBuffers[writeBufferIndex] retain];
		writeBufferIndex += 1;
	}
	else {
		NSException* exception = [NSException exceptionWithName:@"StubControlChannelException" reason:@"Write buffers full" userInfo:nil];
		@throw exception;
	}
}

- (ByteBuffer*) read:(UInt16) numberOfBytes {
	if (currentReadBufferIndex < MAX_NUMBER_OF_BUFFERS) {
		ByteBuffer* readBuffer = readBuffers[currentReadBufferIndex];
		currentReadBufferIndex += 1;
		if (readBuffer) {
			ByteBuffer* response = [[[ByteBuffer alloc] init] autorelease];
			for (UInt16 i=0; i<numberOfBytes; ++i) {
				[response addUInt8:[readBuffer getUInt8At:i]];
			}
			return response;
		}
	}
	return nil;
}

- (void) addReadBuffer: (ByteBuffer*) buffer {
	if (readBufferIndex < MAX_NUMBER_OF_BUFFERS) {
		readBuffers[readBufferIndex] = buffer;
		[buffer retain];
	}
}

- (ByteBuffer*) getWriteBufferAtIndex:(int) index {
	if (index < MAX_NUMBER_OF_BUFFERS) {
		return writeBuffers[index];
	}
	else {
		NSException* exception = [NSException exceptionWithName:@"StubControlChannelException" reason:@"Write buffer index out of range" userInfo:nil];
		@throw exception;
	}
	return nil;
}

- (int) getNumberOfWriteBuffers {
	return writeBufferIndex;
}

- (void) resetWriteBuffers {
	writeBufferIndex = 0;
}

@end
