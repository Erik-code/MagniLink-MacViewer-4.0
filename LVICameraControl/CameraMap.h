//
//  CameraMap.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-09.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraMap : NSObject

+(void) initMap;
+(NSRange) getCameraParameter:(NSString*)parameterName;

@end

NS_ASSUME_NONNULL_END
