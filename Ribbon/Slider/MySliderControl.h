//
//  MySliderControl.h
//  MagniLink
//
//  Created by Erik Sandström on 2019-09-30.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MySliderControl : NSSlider

@property double maxValue;
@property double minValue;

-(id) initWithFrame:(NSRect)frameRect;
-(id) init;
-(void) resize;

@end

NS_ASSUME_NONNULL_END
