//
//  MyRibbonView.h
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-21.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyCameraButtonBarView.h"
#import "MyOcrButtonBarView.h"
#import "MyGrabberButtonBarView.h"
//#import "Utility.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {kTabCamera, kTabOcr, kTabGrabber} RibbonTab;

typedef struct _Functions
{
    bool ocr;
    bool recording;
    bool light;
    bool manualFocus;
} Functions;

@interface MyRibbonTab : NSButton
{
    NSColor *mBackground;
    NSColor *mForeground;
}

-(id)initWithBackground:(NSColor*)back andForeground:(NSColor*)fore;

@end

@protocol RibbonDelegate <NSObject>

@optional
-(void) handleSettings;

-(void) handleCameraButtonClicked:(CameraButton)button withModifier:(NSUInteger)mod;
-(void) handleCameraButtonPress:(CameraButton)button;
-(void) handleCameraButtonRelease:(CameraButton)button;

-(void) handleAutofocusClicked;

-(void) handleOcrButtonClicked:(OcrButton)button withModifier:(NSUInteger)mod;

-(void) handleGrabberButtonClicked:(GrabberButton)button withModifier:(NSUInteger)mod;
-(void) handleGrabberButtonPress:(GrabberButton)button;
-(void) handleGrabberButtonRelease:(GrabberButton)button;

-(void) handleTabSwitch:(RibbonTab)tab;

-(void) handleVolumeChanged:(double)value;
-(void) handleSpeedChanged:(double)value;
-(void) handleFontChanged:(NSString*)name;
-(void) handleFontSizeChanged:(int)size;
-(void) handlePages:(int)pages;

@end

@interface MyRibbonView : NSView<CameraButtonDelegate,OcrButtonDelegate,GrabberButtonDelegate>

@property (nonatomic, weak) id <RibbonDelegate> delegate;

-(void) setup;
-(void) setScale:(float)scaleFactor;
-(NSInteger) getCameraGroups;
-(void) setAllCameraGroups;
-(void) setCameraGroups:(NSInteger)groups;
-(void) setToggleSources:(bool)value;

-(NSInteger) getOcrGroups;
-(void) setAllOcrGroups;
-(void) setOcrGroups:(NSInteger)groups;

//-(NSInteger) getGrabberGroups;
//-(void) setGrabberGroups:(NSInteger)groups;

-(void) toggleCameraButton:(int)button withState:(bool)state;
-(void) toggleAutofocusWithState:(bool)state;
-(void) toggleOcrButton:(int)button withState:(bool)state;
-(void) toggleGrabberButton:(int)button withState:(bool)state;
-(void) setTab:(RibbonTab)tab;
-(RibbonTab) getTab;
-(void) setFont:(NSString*)name;
-(void) setFontSize:(int)size;
-(void) setVolume:(double)volume;
-(void) setSpeed:(double)speed;
-(void) setPageNumber:(int)number andCount:(int)count;
-(void) setFunctions:(Functions)functions;
//-(void) setGrabber:(bool)enable;
//-(bool) getGrabber;

#ifdef DEBUG

-(void) takeScreenShot;

#endif

@end

NS_ASSUME_NONNULL_END
