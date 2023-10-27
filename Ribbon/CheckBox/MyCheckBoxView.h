//
//  CheckBoxView.h
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-21.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CheckBoxDelegate <NSObject>

-(void) handleCheckBoxClicked;

@end

@interface MyCheckBoxView : NSButton
@property (nonatomic, weak) id <CheckBoxDelegate> delegate;

- (instancetype)initWithString:(NSString*)caption;
- (void) toggle:(BOOL)value;
- (void) resize;

@end

NS_ASSUME_NONNULL_END
