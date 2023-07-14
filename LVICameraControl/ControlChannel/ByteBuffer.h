//
//  MessageBuffer.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#define MAXBUFFERSIZE 30

@interface ByteBuffer : NSObject {
@private UInt8 buffer[MAXBUFFERSIZE];
@private UInt16 bufferIndex;
}

- (void) addUInt8:(UInt8) data;
- (void) addUInt16:(UInt16) data;
- (void) addUInt8Array:(UInt8[]) array ofLength:(UInt16) length;
- (UInt16) getBufferLength;
- (UInt8) getUInt8At: (UInt16) index;
- (NSString*) convertToString;
- (NSData*) convertToData;
- (SInt32) getSInt32At: (UInt16) index;
- (BOOL) isContentEqualTo:(UInt8[]) array ofLength:(UInt16) length;
- (BOOL) isEqualTo:(id)other;
@end
