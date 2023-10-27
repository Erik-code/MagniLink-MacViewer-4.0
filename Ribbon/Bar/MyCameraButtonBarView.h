//
//  CameraButtonBarView.h
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-24.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import "MyButtonBarView.h"
#import "MyButtonView.h"
#import "MyCheckBoxView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {kColorsCamera , kMagnification, kMultiCam, kPanTilt, kPresets , kFocus, kManualFocus, kContrast, kLineCurtain, kLight, kPicture, kVideo, kFunctions, kOcr, kHelpCamera, kNumberOfCameraGroups} CameraGroups;

typedef enum {kCamNatural, kCamArtificial,
    kCamDecreaseMagnification, kCamIncreaseMagnification, kCamOverView,
    kMultiCamSources, kMultiCamSwitch, kMultiCamSplit, kMultiCamLeft, kMultiCamRight,
    kPanLeft, kPanRight, kTiltUp, kTiltDown,
    kPresetOne, kPresetTwo, kPresetThree,
    
    /*kCamAutofocus,*/
    kCamDecreaseFocus, kCamIncreaseFocus,
    kCamDecreaseContrast, kCamIncreaseContrast,
    kCamLineLeftUp, kCamLineRightDown,
    kCamDecreaseLight, kCamIncreaseLight,
    kCamSavePicture, kCamOpenPicture,
    kCamSaveVideo, kCamOpenVideo,
    kCamRotate, kCamMirror, kCamFreeze,
    kCamOcr, kCamLetterBox,
    kCamSplitMode, kCamAlwaysOnTop, kCamHelp,
    kNumberCamButtons
} CameraButton;

@protocol CameraButtonDelegate <NSObject>

-(void) handleCameraButtonClicked:(CameraButton)button withModifier:(NSUInteger)mod;
-(void) handleCameraButtonPress:(CameraButton)button;
-(void) handleCameraButtonRelease:(CameraButton)button;
-(void) handleButtonBecomesFirstResponder:(MyButtonView*)button;

-(void) handleAutofocusClicked;

@end

@interface MyCameraButtonBarView : MyButtonBarView<ButtonDelegate,CheckBoxDelegate>
@property (nonatomic, weak) id <CameraButtonDelegate> delegate;

-(void) setupWithGroups:(NSInteger)groups andButtons:(NSArray*)buttons;
-(void) setGroups:(NSInteger)groups;
-(NSInteger) getGroups;
-(void) toggleButton:(CameraButton)button withState:(BOOL)state;
-(void) toggleAutofocusWithState:(BOOL)state;
-(void) setToggleSources:(bool)value;
#ifdef DEBUG

-(void) takeScreenShot;

#endif

@end

NS_ASSUME_NONNULL_END
