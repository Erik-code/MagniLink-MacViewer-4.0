//
//  MaskingOperations.h
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MaskingOperations : NSObject {

}

+ (UInt8) getLowByte: (UInt16) x;
+ (UInt8) getHighByte: (UInt16) x;
+ (UInt16) setHighByte: (UInt8) x;
@end
