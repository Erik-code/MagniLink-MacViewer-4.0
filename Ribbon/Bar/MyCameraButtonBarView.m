//
//  MyCameraButtonBarView.m
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-24.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import "MyCameraButtonBarView.h"
#import "MyButtonView.h"
#import "MyCheckBoxView.h"
#import "MySizes.h"
#import "ScreenShot.h"
#import "Localization.h"
//#import "Preferences.h"

@interface MyCameraButtonBarView()
{
    float mPos;
    NSArray *mGroupControls;
    NSArray *mOutsideButtons;
    NSMutableArray *mButtons;
    NSInteger mGroups;
    MyCheckBoxView *mAutofocus;
    bool mToggleSources;
}
@end

@implementation MyCameraButtonBarView
@synthesize delegate;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

-(void) viewDidUnhide
{
    [self initKeyViews];
}

-(void) initKeyViews
{
    [[self window] setInitialFirstResponder:self];
    [[self window] recalculateKeyViewLoop];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [temp addObject:self];
    
    [temp addObject:[mOutsideButtons objectAtIndex:0]];
    [temp addObject:[mOutsideButtons objectAtIndex:1]];
    [temp addObject:[mOutsideButtons objectAtIndex:2]];
    
    for(NSArray *arr in mGroupControls)
    {
        for(NSView *v in arr){
            [temp addObject:v];
        }
    }
    
    for(int i = 0 ; i < [temp count] ; i++)
    {
        [[temp objectAtIndex:i] setNextKeyView:[temp objectAtIndex:(i+1) % [temp count]]];
    }
}

#pragma mark initialization methods

-(void) setupWithGroups:(NSInteger)groups andButtons:(NSArray*)buttons
{
    mToggleSources = false;
    mOutsideButtons = buttons;
    mButtons = [[NSMutableArray alloc] initWithCapacity:kNumberCamButtons];
    
    NSArray* colors = [self createColors];
    NSArray* magnification = [self createMagnification];
    NSArray* multicam = [self createMulticam];
    NSArray* panTilt = [self createPanTilt];
    NSArray* presets = [self createPresets];
    NSArray* focus = [self createFocus];
    NSArray* manualFocus = [self createManualFocus];
    NSArray* contrast = [self createContrast];

    NSArray* refline = [self createRefline];
    NSArray* light = [self createLight];
    NSArray* picture = [self createPicture];
    NSArray* recording = [self createRecording];
    NSArray* functions = [self createFunctions];

    NSArray* ocr = [self createOCR];
    NSArray* help = [self createHelp];
    
    mGroupControls = [[NSArray alloc] initWithObjects:colors,magnification, multicam, panTilt, presets,focus, manualFocus, contrast, refline,light,picture,recording,functions,ocr,help,
                 nil];
    
    [self setGroupsHelp:groups];
    
    [self setFrameSize:NSMakeSize(mPos, [self frame].size.height)];
  
    [self setNeedsDisplay:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(keyViewsTimerTick:) userInfo:nil repeats:NO];
}


- (void) keyViewsTimerTick: (NSTimer*) timer {
    [self initKeyViews];
}

-(MyButtonView*) createButton:(CameraButton)button file:(NSString*)filename caption:(NSString*)text
{
    MyButtonView *mybutton = [[MyButtonView alloc] initWithFilename:filename andCaption:text andButton:button];
    [mybutton setDelegate:self];
    [mButtons insertObject:mybutton atIndex:button];
    return mybutton;
}

-(NSArray*) createColors
{
    MyButtonView *button1 = [self createButton:kCamNatural file:@"stripedmoon2.png" caption:NSLocalizedString(@"Natural",@"")];
    [button1 setAccessibilityLabel:@"NaturalColors".localized];
    
    MyButtonView *button2 = [self createButton:kCamArtificial file:@"halfmoon2.png" caption:NSLocalizedString(@"Artificial",@"")];
    [button2 setAccessibilityLabel:@"ArtificialColors".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createMagnification
{
    MyButtonView *button1 = [self createButton:kCamDecreaseMagnification file:@"magniminus2.png" caption:NSLocalizedString(@"Decrease","")];
    [button1 setAccessibilityLabel:@"DecreaseMagnification".localized];
    MyButtonView *button2 = [self createButton:kCamIncreaseMagnification file:@"magniplus2.png" caption:NSLocalizedString(@"Increase","")];
    [button2 setAccessibilityLabel:@"IncreaseMagnification".localized];
    MyButtonView *button3 = [self createButton:kCamOverView file:@"focus2.png" caption:NSLocalizedString(@"Overview","")];
    [button3 setToggleButton:kToggle];
    return [[NSArray alloc] initWithObjects:button1, button2, button3, nil];
}

-(NSArray*) createMulticam
{
    MyButtonView *button0 = [self createButton:kMultiCamSources file:@"switch_sources.png" caption:NSLocalizedString(@"Sources","")];
    [button0 setAccessibilityLabel:@"ChangeSources".localized];
    MyButtonView *button1 = [self createButton:kMultiCamSwitch file:@"switch_camera22.png" caption:NSLocalizedString(@"Camera","")];
    [button1 setAccessibilityLabel:@"ChangeCamera".localized];
    MyButtonView *button2 = [self createButton:kMultiCamSplit file:@"change_split2V.png" caption:NSLocalizedString(@"Split","")];
    [button2 setAccessibilityLabel:@"ChangeSplit".localized];
    MyButtonView *button3 = [self createButton:kMultiCamLeft file:@"change_split_size_left.png" caption:NSLocalizedString(@"LeftUp","")];
    [button3 setAccessibilityLabel:@"SplitLeftUp".localized];
    MyButtonView *button4 = [self createButton:kMultiCamRight file:@"change_split_size_right.png" caption:NSLocalizedString(@"RightDown","")];
    [button4 setAccessibilityLabel:@"SplitRightDown".localized];
    return [[NSArray alloc] initWithObjects:button0, button1, button2, button3, button4, nil];
}

-(NSArray*) createPanTilt
{
    MyButtonView *button1 = [self createButton:kPanLeft file:@"left2.png" caption:NSLocalizedString(@"Left","")];
    [button1 setAccessibilityLabel:@"PanLeft".localized];
    MyButtonView *button2 = [self createButton:kPanRight file:@"right2.png" caption:NSLocalizedString(@"Right","")];
    [button2 setAccessibilityLabel:@"PanRight".localized];
    MyButtonView *button3 = [self createButton:kTiltUp file:@"up2.png" caption:NSLocalizedString(@"Up","")];
    [button3 setAccessibilityLabel:@"TiltUp".localized];

    MyButtonView *button4 = [self createButton:kTiltDown file:@"down2.png" caption:NSLocalizedString(@"Down","")];
    [button4 setAccessibilityLabel:@"TiltDown".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, button3, button4, nil];
}

-(NSArray*) createPresets
{
    MyButtonView *button1 = [self createButton:kPresetOne file:@"one2.png" caption:NSLocalizedString(@"One","")];
    [button1 setAccessibilityLabel:@"GotoPresetOne".localized];
    MyButtonView *button2 = [self createButton:kPresetTwo file:@"two2.png" caption:NSLocalizedString(@"Two","")];
    [button2 setAccessibilityLabel:@"GotoPresetTwo".localized];
    MyButtonView *button3 = [self createButton:kPresetThree file:@"three2.png" caption:NSLocalizedString(@"Three","")];
    [button3 setAccessibilityLabel:@"GotoPresetThree".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, button3, nil];
}

-(NSArray*) createFocus
{
    mAutofocus = [[MyCheckBoxView alloc] initWithString:NSLocalizedString(@"Autofocus","")];
    [mAutofocus setDelegate:self];
    return [[NSArray alloc] initWithObjects:mAutofocus, nil];
}

-(NSArray*) createManualFocus
{
    MyButtonView *button1 = [self createButton:kCamDecreaseFocus file:@"focus_up2.png" caption:NSLocalizedString(@"Up","")];
    [button1 setAccessibilityLabel:@"ManualFocusUp".localized];
    MyButtonView *button2 = [self createButton:kCamIncreaseFocus file:@"focus_down2.png" caption:NSLocalizedString(@"Down","")];
    [button2 setAccessibilityLabel:@"ManualFocusDown".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createContrast
{
    MyButtonView *button1 = [self createButton:kCamDecreaseContrast file:@"sunsmall2.png" caption:NSLocalizedString(@"Decrease","")];
    [button1 setAccessibilityLabel:@"DecreaseContrast".localized];
    MyButtonView *button2 = [self createButton:kCamIncreaseContrast file:@"sunlarge2.png" caption:NSLocalizedString(@"Increase","")];
    [button2 setAccessibilityLabel:@"IncreaseContrast".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createRefline
{
    MyButtonView *button1 = [self createButton:kCamLineLeftUp file:@"left2.png" caption:NSLocalizedString(@"LeftUp","")];
    [button1 setAccessibilityLabel:@"GuidingLineLeftUp".localized];
    MyButtonView *button2 = [self createButton:kCamLineRightDown file:@"right2.png" caption:NSLocalizedString(@"RightDown","")];
    [button2 setAccessibilityLabel:@"GuidingLineRightDown".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createLight
{
    MyButtonView *button1 = [self createButton:kCamDecreaseLight file:@"light_down2.png" caption:NSLocalizedString(@"Decrease","")];
    [button1 setAccessibilityLabel:@"DecreaseLight".localized];
    MyButtonView *button2 = [self createButton:kCamIncreaseLight file:@"light_up2.png" caption:NSLocalizedString(@"Increase","")];
    [button2 setAccessibilityLabel:@"IncreaseLight".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}


-(NSArray*) createPicture
{
    MyButtonView *button1 = [self createButton:kCamSavePicture file:@"camera2.png" caption:NSLocalizedString(@"Save","")];
    [button1 setAccessibilityLabel:@"SaveImage".localized];
    MyButtonView *button2 = [self createButton:kCamOpenPicture file:@"open2.png" caption:NSLocalizedString(@"Open","")];
    [button2 setAccessibilityLabel:@"OpenPicture".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createRecording
{
    MyButtonView *button1 = [self createButton:kCamSaveVideo file:@"video2.png" caption:NSLocalizedString(@"Record","")];
    [button1 setAccessibilityLabel:@"RecordVideo".localized];
    [button1 setToggleButton:kToggle];
    MyButtonView *button2 = [self createButton:kCamOpenVideo file:@"open2.png" caption:NSLocalizedString(@"Open","")];
    [button2 setAccessibilityLabel:@"OpenMovie".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createFunctions
{
    MyButtonView *button1 = [self createButton:kCamRotate file:@"rotate2.png" caption:NSLocalizedString(@"Rotate","")];
    [button1 setAccessibilityLabel:@"Rotate".localized];
    MyButtonView *button2 = [self createButton:kCamMirror file:@"mirror2.png" caption:NSLocalizedString(@"Mirror","")];
    [button2 setAccessibilityLabel:@"Mirror".localized];
    [button2 setToggleButton:kToggle];
    MyButtonView *button3 = [self createButton:kCamFreeze file:@"stop2.png" caption:NSLocalizedString(@"FreezeImage","")];
    [button3 setAccessibilityLabel:@"FreezeImage".localized];
    [button3 setToggleButton:kToggle];
    return [[NSArray alloc] initWithObjects:button1, button2, button3, nil];
}

-(NSArray*) createOCR
{
    MyButtonView *button1 = [self createButton:kCamOcr file:@"ocr2.png" caption:NSLocalizedString(@"OCR","")];
    [button1 setAccessibilityLabel:@"StartOcr".localized];
    MyButtonView *button2 = [self createButton:kCamLetterBox file:@"letter2.png" caption:NSLocalizedString(@"Whole","")];
    [button2 setAccessibilityLabel:@"Whole".localized];
    [button2 setToggleButton:kToggle];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createHelp
{
    MyButtonView *button1 = [self createButton:kCamSplitMode file:@"change_window2.png" caption:NSLocalizedString(@"SplitModes","")];
    [button1 setAccessibilityLabel:@"SplitModes".localized];
    MyButtonView *button2 = [self createButton:kCamAlwaysOnTop file:@"button_pin2.png" caption:NSLocalizedString(@"AlwaysOnTop","")];
    [button2 setAccessibilityLabel:@"AlwaysOnTop".localized];
    [button2 setToggleButton:kToggle];
    MyButtonView *button3 = [self createButton:kCamHelp file:@"help2.png" caption:NSLocalizedString(@"Help","")];
    [button3 setAccessibilityLabel:@"OpenManual".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, button3, nil];
}

#pragma mark delegate methods

-(void) handleClicked:(int)button withModifier:(NSUInteger)mod
{
    [delegate handleCameraButtonClicked:button withModifier:mod];
}

-(void) handlePress:(int)button
{
    [delegate handleCameraButtonPress:button];
}

-(void) handleRelease:(int)button
{
    [delegate handleCameraButtonRelease:button];
}

-(void) handleButtonBecomesFirstResponder:(MyButtonView*)button
{
    [delegate handleButtonBecomesFirstResponder:button];
}

-(void) handleCheckBoxClicked
{
    [delegate handleAutofocusClicked];
}

#pragma mark getter and setter

-(void) removeAll
{
    for(int i = 0; i < [mGroupControls count] ; i++){
        NSArray *arr = [mGroupControls objectAtIndex:i];
        for(int j = 0; j < [arr count]; j++)
        {
            [[arr objectAtIndex:j] removeFromSuperview];
        }
    }
}

-(void) toggleButton:(CameraButton)button withState:(BOOL)state
{
    MyButtonView* mybutton = (MyButtonView*)[mButtons objectAtIndex:button];
    [mybutton toggle:state];
}

-(void) toggleAutofocusWithState:(BOOL)state
{
    [mAutofocus toggle:state];
}

-(void) setGroups:(NSInteger)groups
{
    mGroups = groups;
    mPos = 0;
    [self removeAll];
    [self setGroupsHelp:groups];
}

-(NSInteger) getGroups
{
    return mGroups;
}

-(void) setToggleSources:(bool)value
{
    mToggleSources = value;
    mPos = 0;
    [self removeAll];
    [self setGroupsHelp:mGroups];
}

-(void) setGroupsHelp:(NSInteger)groups
{
    NSMutableArray *toLayer = [[NSMutableArray alloc] init];
    float bm = [MySizes buttonMargin];
    mPos = bm;
    
    if((groups & RibbonGroup_CameraColors) != 0)
    {
        [self setupColors:[mGroupControls objectAtIndex:kColorsCamera]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Colors","")];
    }
    if((groups & RibbonGroup_CameraMagnification) != 0){
        [self setupMagnification:[mGroupControls objectAtIndex:kMagnification]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Magnification","")];
    }
    if((groups & RibbonGroup_CameraMultiCam) != 0){
        [self setupMultiCam:[mGroupControls objectAtIndex:kMultiCam]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"MultipleCameras","")];
    }
    if((groups & RibbonGroup_CameraPanTilt) != 0){
        [self setupPanTilt:[mGroupControls objectAtIndex:kPanTilt]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"PanAndTilt","")];
    }
    if((groups & RibbonGroup_CameraPresets) != 0){
        [self setupPresets:[mGroupControls objectAtIndex:kPresets]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Preset","")];
    }
    if((groups & RibbonGroup_CameraFocus) != 0){
        [self setupFocus:[mGroupControls objectAtIndex:kFocus]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Focus","")];
    }
    if((groups & RibbonGroup_CameraManualFocus) != 0){
        [self setupManualFocus:[mGroupControls objectAtIndex:kManualFocus]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"ManualFocus","")];
    }
    if((groups & RibbonGroup_CameraContrast) != 0){
        [self setupContrast:[mGroupControls objectAtIndex:kContrast]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Contrast","")];
    }
    if((groups & RibbonGroup_CameraReferenceLine) != 0){
        [self setupLineCurtain:[mGroupControls objectAtIndex:kLineCurtain]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"RefLineCurtain","")];
    }
    if((groups & RibbonGroup_CameraLight) != 0){
        [self setupLight:[mGroupControls objectAtIndex:kLight]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Light","")];
    }
    if((groups & RibbonGroup_CameraPicture) != 0){
        [self setupPicture:[mGroupControls objectAtIndex:kPicture]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Picture","")];
    }
    if((groups & RibbonGroup_CameraVideo) != 0){
        [self setupVideo:[mGroupControls objectAtIndex:kVideo]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Video","")];
    }
    if((groups & RibbonGroup_CameraFunctions) != 0){
        [self setupFunctions:[mGroupControls objectAtIndex:kFunctions]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Functions","")];
    }
    if((groups & RibbonGroup_CameraOCR) != 0){
        [self setupOcr:[mGroupControls objectAtIndex:kOcr]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"OCR","")];
    }
    if((groups & RibbonGroup_CameraHelp) != 0){
        [self setupHelp:[mGroupControls objectAtIndex:kHelpCamera]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Help","")];
    }

    mPos += bm;
    mDrawArray = toLayer;
    [self setNeedsDisplay:YES];

    [self setFrameSize:NSMakeSize(mPos, [self frame].size.height)];
}

#pragma mark setup methods

- (void) setupColors:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

-(void) setupMagnification:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
    [self setupButtonHelp:[array objectAtIndex:2]];
}

-(void) setupMultiCam:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    if(mToggleSources){
        [self setupButtonHelp:[array objectAtIndex:0]];
    }
    [self setupButtonHelp:[array objectAtIndex:1]];
    [self setupButtonHelp:[array objectAtIndex:2]];
    [self setupButtonHelp:[array objectAtIndex:3]];
    [self setupButtonHelp:[array objectAtIndex:4]];
}

-(void) setupPanTilt:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
    [self setupButtonHelp:[array objectAtIndex:2]];
    [self setupButtonHelp:[array objectAtIndex:3]];
}

-(void) setupPresets:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
    [self setupButtonHelp:[array objectAtIndex:2]];
}


-(void) setupFocus:(NSArray*)array
{
    MyCheckBoxView *cb = (MyCheckBoxView*) [array objectAtIndex:0];
    float bo = [MySizes groupLabelHeight];
    float bm = [MySizes buttonMargin];
    mPos+=bm;
    
    [cb resize];
    [cb setFrameOrigin:NSMakePoint(mPos, bo)];
    [self addSubview:cb];
    mPos+= [cb bounds].size.width;
    mPos+=bm;
}

-(void) setupManualFocus:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

-(void) setupContrast:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

-(void) setupLineCurtain:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

-(void) setupLight:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

-(void) setupPicture:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

-(void) setupVideo:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

-(void) setupFunctions:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
    [self setupButtonHelp:[array objectAtIndex:2]];
}

-(void) setupOcr:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

-(void) setupHelp:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
    [self setupButtonHelp:[array objectAtIndex:2]];
}

- (void) setupButtonHelp:(MyButtonView*)button
{
    float bo = [MySizes groupLabelHeight];
    float bm = [MySizes buttonMargin];
    
    [button resize];
    [button setFrameOrigin:NSMakePoint(mPos, bo)];
    [self addSubview:button];
    mPos += [button bounds].size.width + bm;
}

-(BOOL) acceptsFirstResponder
{
    return YES;
}

#ifdef DEBUG

-(void) takeScreenShot
{
    NSRect cf = [self frame];
    NSRect frame = [self window].frame;
    frame.size.width = cf.size.width + 20;
    
    [[self window] setFrame:frame display:YES animate:NO];
    ScreenShot *ss = [[ScreenShot alloc] init];
    
    NSRect ribbonFrame = [[[[self superview] superview] superview] frame];
    NSSize s = ribbonFrame.size;
    s.height += 85;
    
    float dist = frame.size.height - (ribbonFrame.origin.y + ribbonFrame.size.height);
    ribbonFrame.size.height += dist;
    
    int numberCount = 1;
    int buttonCount = 0;
    
    [ss begin:s];
    [ss takeScreenShot:ribbonFrame];
    float arrowOff = 0.65;
    
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    
    NSPoint point = NSMakePoint([mAutofocus frame].origin.x + [mAutofocus frame].size.width*0.5, [mAutofocus frame].origin.y + [mAutofocus frame].size.height*arrowOff);
    [ss addArrow:[NSString stringWithFormat:@"%d",numberCount++] atPosition:point];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
//    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
//    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    
    [ss saveToFile:@"/Users/erik/Desktop/Camera.png"];
}

-(void)buttonHelp:(int)number index:(int)index ScreenShot:(ScreenShot*)ss
{
    float arrowOff = 0.75;
    NSPoint point = NSMakePoint([mButtons[index] frame].origin.x + [mButtons[index] frame].size.width*0.5, [mButtons[index] frame].origin.y + [mButtons[index] frame].size.height*arrowOff);
    [ss addArrow:[NSString stringWithFormat:@"%d",number] atPosition:point];
}

#endif


@end
