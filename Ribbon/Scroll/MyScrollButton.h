//
//  MyScrollButton.h
//  MagniLink
//
//  Created by Erik Sandström on 2019-10-01.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyScrollButtonDelegate <NSObject>

-(void) buttonPressed:(NSControl*)sender;
-(void) buttonReleased:(NSControl*)sender;

@end

@interface MyScrollButton : NSButton

@property (nonatomic, weak) id <MyScrollButtonDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
