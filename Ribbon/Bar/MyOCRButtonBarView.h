//
//  MyOCRButtonBarView.h
//  TestNSView
//
//  Created by Erik Sandström on 2019-06-25.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import "MyButtonBarView.h"
#import "MyButtonView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {kDocument , kColorsOcr , kFonts, kSpeech, kNavigation, kVolumeAndSpeed, kPages, kHelpOcr, kNumberOfOcrGroups} OcrGroups;

typedef enum {kOcrSave, kOcrOpen,
    kOcrNatural, kOcrArtificial,
    kOcrStart, kOcrStop,
    kOcrDisplayMode, kOcrQuietMode, kOcrNavigateBack, kOcrNavigateForward, kOcrReadMode,
    kOcrSplit, kOcrAlwaysOnTop, kOcrHelp,
    kNumberOcrButtons
} OcrButton;

@protocol OcrButtonDelegate <NSObject>

-(void) handleOcrButtonClicked:(OcrButton)button withModifier:(NSUInteger)mod;
-(void) handleVolumeChanged:(double)value;
-(void) handleSpeedChanged:(double)value;
-(void) handleFontChanged:(NSString*)name;
-(void) handleFontSizeChanged:(int)size;
-(void) handlePages:(int)page;
-(void) handleButtonBecomesFirstResponder:(MyButtonView*)button;

@end

@interface MyOCRButtonBarView : MyButtonBarView<ButtonDelegate>
@property (nonatomic, weak) id <OcrButtonDelegate> delegate;

-(void) setupWithGroups:(NSInteger)groups andButtons:(NSArray*)buttons;
-(void) setGroups:(NSInteger)groups;
-(void) toggleButton:(int)button withState:(BOOL)state;
-(void) setFont:(NSString*)name;
-(void) setFontSize:(int)size;
-(void) setVolume:(double)volume;
-(void) setSpeed:(double)speed;
-(void) setPageNumber:(int)number andCount:(int)count;

#ifdef DEBUG

-(void) takeScreenShot;

#endif

@end

NS_ASSUME_NONNULL_END
