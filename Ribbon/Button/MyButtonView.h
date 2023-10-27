//
//  MyButtonView.h
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-21.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {kNoToggle , kToggle , kImage } ToggleOption;
@class MyButtonView;

@protocol ButtonDelegate <NSObject>

-(void) handleClicked:(int)button withModifier:(NSUInteger)mod;
-(void) handlePress:(int)button;
-(void) handleRelease:(int)button;
-(void) handleButtonBecomesFirstResponder:(MyButtonView*)button;

@end

@interface MyButtonView : NSButton

@property (nonatomic, strong) id <ButtonDelegate> delegate;

- (instancetype)initWithFilename:(NSString*)filename andCaption:(NSString*)caption andButton:(int)button;

- (void) setToggleButton:(ToggleOption)option;
- (void) toggle:(BOOL)value;
- (bool) isToggled;
- (void) setAlternativeFilename:(NSString*)filename andCaption:(NSString*)caption;
- (void) resize;

@end

NS_ASSUME_NONNULL_END
