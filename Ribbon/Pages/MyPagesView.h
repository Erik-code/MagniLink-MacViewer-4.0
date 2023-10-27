//
//  MyPagesView.h
//  MagniLink
//
//  Created by Erik Sandström on 2019-08-29.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPagesButton : NSButton
@end

@protocol MyPagesdelegate <NSObject>

-(void) handlePages:(int)move;

@end

@interface MyPagesView : NSView

@property (nonatomic, strong) id <MyPagesdelegate> delegate;
-(void) setPageNumber:(int)number andCount:(int)count;
-(void) resize;
-(NSArray*) getButtons;

@end

NS_ASSUME_NONNULL_END
