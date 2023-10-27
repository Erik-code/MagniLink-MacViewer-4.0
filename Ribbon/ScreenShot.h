//
//  ScreenShot.h
//  MagniLink
//
//  Created by Erik Sandström on 2019-11-05.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenShot : NSObject

-(void) begin:(NSSize) size;
-(void) takeScreenShot:(NSRect) rect;
-(void) addArrow:(NSString*)number atPosition:(NSPoint)position;
-(void) saveToFile:(NSString*)path;

@end

NS_ASSUME_NONNULL_END
