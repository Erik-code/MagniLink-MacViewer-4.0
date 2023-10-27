//
//  MyGrabberButtonBarView.h
//  MagniLink MacViewer
//
//  Created by Erik Sandström on 2021-01-07.
//  Copyright © 2021 LVI Low Vision International AB. All rights reserved.
//

#import "MyButtonBarView.h"
#import "MyButtonView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {kColorsGrabber , kContrastGrabber , kReferenceLineGrabber, kFunctionsGrabber, kOCRGrabber, kHelpGrabber, kNumberOfGrabberGroups} GrabberGroups;

typedef enum {kGrabberNatural, kGrabberArtificial,
    kGrabberDecreaseContrast, kGrabberIncreaseContrast,
    kGrabberLineLeftUp, kGrabberLineRightDown,
    kGrabberRotate, kGrabberMirror, /*kGrabberFreeze,*/
    /*kGrabberOCR,*/ kGrabberLetterBox,
    kGrabberSplitMode, kGrabberAlwaysOnTop, kGrabberHelp,
    kNumberGrabberButtons
} GrabberButton;

@protocol GrabberButtonDelegate <NSObject>

-(void) handleGrabberButtonClicked:(GrabberButton)button withModifier:(NSUInteger)mod;
-(void) handleGrabberButtonPress:(GrabberButton)button;
-(void) handleGrabberButtonRelease:(GrabberButton)button;
-(void) handleButtonBecomesFirstResponder:(MyButtonView*)button;

@end

@interface MyGrabberButtonBarView : MyButtonBarView<ButtonDelegate>
@property (nonatomic, weak) id <GrabberButtonDelegate> delegate;


-(void) setupWithGroups:(NSMutableArray*)groups andButtons:(NSArray*)buttons;
-(void) setGroups:(NSMutableArray*)groups;
-(void) toggleButton:(GrabberButton)button withState:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
