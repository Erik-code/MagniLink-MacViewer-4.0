//
//  MessageBufferTests.m
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ByteBufferTests.h"


@implementation ByteBufferTests

- (void) setUp {
	buffer = [[[ByteBuffer alloc] init] autorelease];
}

- (void) test_addUInt8 {
	UInt8 x = 0x12;
	[buffer addUInt8:x];
	UInt8 result = [buffer getUInt8At:0];
	GHAssertEquals((int) result, (int) x, nil);
}

- (void) test_addUInt16 {
	UInt16 x = 0x1234;
	[buffer	addUInt16:x];
	UInt8 lowByte = [buffer getUInt8At:0];
	GHAssertEquals((int) lowByte, (int) 0x34, nil);
	UInt8 highByte = [buffer getUInt8At:1];
	GHAssertEquals((int) highByte, (int) 0x12, nil);		
}

- (void) test_addUInt8Array {
	UInt8 data[] = {1, 2, 3, 4};
	[buffer addUInt8Array:data ofLength:4];
	for (int i=0; i<4; ++i) {
		GHAssertEquals((int) [buffer getUInt8At:i], (int) data[i], nil);
	}
}

- (void) test_addUInt8_ThrowsWhenBufferFull {
	for (int i=0; i<MAXBUFFERSIZE; ++i) {
		[buffer addUInt8:(UInt8) i];
	}
	GHAssertThrows([buffer addUInt8:0], nil);
}

- (void) test_addUInt16_ThrowsWhenBufferFull {
	for (int i=0; i<MAXBUFFERSIZE-1; ++i) {
		[buffer addUInt8:(UInt8) i];
	}
	GHAssertThrows([buffer addUInt16:0], nil);
}

- (void) test_addUInt8Array_ThrowsWhenBufferFull {
	UInt8 data[MAXBUFFERSIZE+1];
	GHAssertThrows([buffer addUInt8Array:data ofLength:MAXBUFFERSIZE+1], nil);
}


- (void) test_getBufferLength {
	int numberOfBytes = MAXBUFFERSIZE-1;
	for (int i=0; i<numberOfBytes; ++i) {
		[buffer addUInt8:(UInt8) i];
	}
	UInt16 length = [buffer getBufferLength];
	GHAssertEquals((int) length, numberOfBytes, nil);
}

- (void) test_getSInt32At {
	UInt8 data[] = {0x12, 0x34, 0x56, 0x78};
	[buffer addUInt8Array: data ofLength:4];
	SInt32 expected = 0x78563412;
	SInt32 result = [buffer getSInt32At:0];
	GHAssertEquals((int) result, (int) expected, nil);
}

- (void) test_getSInt32At_ThrowsWhenNotEnoughData {
	[buffer addUInt8:0];
	[buffer addUInt8:1];
	GHAssertThrows([buffer getSInt32At:0], nil);
}

- (void) test_convertToString {
	UInt8 data[] = {'A', 'B', 'C'};
	[buffer addUInt8Array:data ofLength:3];
	NSString* result = [buffer convertToString];
	GHAssertEqualStrings(result, @"ABC", nil);
}

- (void) test_isContentEqualTo_NULL_Yes {
	GHAssertTrue([buffer isContentEqualTo:NULL ofLength:0], nil);
}

- (void) test_isContentEqualTo_NULL_No {
	[buffer addUInt8:1];
	GHAssertTrue(![buffer isContentEqualTo:NULL ofLength:0], nil);
}

- (void) test_isContentEqualTo_NotEqualLength_No {
	UInt8 data[] = {1, 2, 3};
	[buffer addUInt8Array:data ofLength:3];
	UInt8 compareData[] = {1, 2, 3, 4};
	GHAssertTrue(![buffer isContentEqualTo:compareData ofLength:4], nil);	
}

- (void) test_isContentEqualTo_Yes {
	UInt8 data[] = {1, 2, 3};
	[buffer addUInt8Array:data ofLength:3];
	UInt8 compareData[] = {1, 2, 3};
	GHAssertTrue([buffer isContentEqualTo:compareData ofLength:3], nil);	
}

- (void) test_isContentEqualTo_No {
	UInt8 data[] = {1, 2, 3};
	[buffer addUInt8Array:data ofLength:3];
	UInt8 compareData[] = {1, 2, 1};
	GHAssertTrue(![buffer isContentEqualTo:compareData ofLength:3], nil);	
}

- (void) test_isEqualTo_NotSameClass_No {
	GHAssertTrue(![buffer isEqualTo:@"Kalle"], nil);
}

- (void) test_IsEqualTo_NotEqualLength_No {
	UInt8 data[] = {1, 2, 3};
	[buffer addUInt8Array:data ofLength:3];
	
	ByteBuffer* buffer2 = [[[ByteBuffer alloc] init] autorelease];
	[buffer2 addUInt8: 5]; 
	GHAssertTrue(![buffer isEqualTo:buffer2], nil);
}

- (void) test_IsEqualTo_NotEqualContent_No {
	UInt8 data[] = {1, 2, 3};
	[buffer addUInt8Array:data ofLength:3];
	
	ByteBuffer* buffer2 = [[[ByteBuffer alloc] init] autorelease];
	UInt8 data2[] = {1, 3, 2};
	[buffer2 addUInt8Array:data2 ofLength:3];
	GHAssertTrue(![buffer isEqualTo:buffer2], nil);
}

- (void) test_IsEqualTo_EqualContent_Yes {
	UInt8 data[] = {1, 2, 3};
	[buffer addUInt8Array:data ofLength:3];
	
	ByteBuffer* buffer2 = [[[ByteBuffer alloc] init] autorelease];
	UInt8 data2[] = {1, 2, 3};
	[buffer2 addUInt8Array:data2 ofLength:3];
	GHAssertTrue([buffer isEqualTo:buffer2], nil);
}

@end
