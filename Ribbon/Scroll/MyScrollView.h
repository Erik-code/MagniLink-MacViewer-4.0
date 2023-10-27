//
//  MyScrollView.h
//  MagniLink
//
//  Created by Erik Sandström on 2019-10-01.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyScrollButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyScrollView : NSView<MyScrollButtonDelegate>

-(void) setDocumentView:(NSView*)view;
-(void) controlFocus:(NSRect)frame;

-(MyScrollButton*) getLeftButton;
-(MyScrollButton*) getRightButton;

@end

NS_ASSUME_NONNULL_END
