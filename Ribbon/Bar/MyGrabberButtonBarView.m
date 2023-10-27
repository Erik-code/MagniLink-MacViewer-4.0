//
//  MyGrabberButtonBarView.m
//  MagniLink MacViewer
//
//  Created by Erik Sandström on 2021-01-07.
//  Copyright © 2021 LVI Low Vision International AB. All rights reserved.
//

#import "MyGrabberButtonBarView.h"
#import "MyButtonView.h"
#import "MySizes.h"
#import "Localization.h"


@interface MyGrabberButtonBarView()
{
    float mPos;
    NSArray *mGroupControls;
    NSArray *mOutsideButtons;
    NSMutableArray *mButtons;
    
}
@end

@implementation MyGrabberButtonBarView
@synthesize delegate;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void) viewDidUnhide
{
   [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(keyViewsTimerTick:) userInfo:nil repeats:NO];
}

- (void) keyViewsTimerTick: (NSTimer*) timer {
    [self initKeyViews];
}

-(void)initKeyViews
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

-(void) setupWithGroups:(NSMutableArray*)groups andButtons:(NSArray*)buttons
{
    mOutsideButtons = buttons;
    mButtons = [[NSMutableArray alloc] initWithCapacity:kNumberGrabberButtons];
    
    NSArray* colors = [self createColors];
    NSArray* contrast = [self createContrast];
    NSArray* refline = [self createRefline];
    NSArray* functions = [self createFunctions];
    NSArray* ocr = [self createOCR];
    NSArray* help = [self createHelp];
    
    mGroupControls = [[NSArray alloc] initWithObjects:colors, contrast, refline, functions,ocr,help,
                 nil];
    
    [self setGroupsHelp:groups];
    
    [self setFrameSize:NSMakeSize(mPos, [self frame].size.height)];
  
    [self setNeedsDisplay:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(keyViewsTimerTick:) userInfo:nil repeats:NO];
}

-(MyButtonView*) createButton:(GrabberButton)button file:(NSString*)filename caption:(NSString*)text
{
    MyButtonView *mybutton = [[MyButtonView alloc] initWithFilename:filename andCaption:text andButton:button];
    [mybutton setDelegate:self];
    [mButtons insertObject:mybutton atIndex:button];
    return mybutton;
}

-(NSArray*) createColors
{
    MyButtonView *button1 = [self createButton:kGrabberNatural file:@"stripedmoon2.png" caption:NSLocalizedString(@"Natural",@"")];
    [button1 setAccessibilityLabel:@"NaturalColors".localized];
    
    MyButtonView *button2 = [self createButton:kGrabberArtificial file:@"halfmoon2.png" caption:NSLocalizedString(@"Artificial",@"")];
    [button2 setAccessibilityLabel:@"ArtificialColors".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createContrast
{
    MyButtonView *button1 = [self createButton:kGrabberDecreaseContrast file:@"sunsmall2.png" caption:NSLocalizedString(@"Decrease","")];
    [button1 setAccessibilityLabel:@"DecreaseContrast".localized];
    MyButtonView *button2 = [self createButton:kGrabberIncreaseContrast file:@"sunlarge2.png" caption:NSLocalizedString(@"Increase","")];
    [button2 setAccessibilityLabel:@"IncreaseContrast".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createRefline
{
    MyButtonView *button1 = [self createButton:kGrabberLineLeftUp file:@"left2.png" caption:NSLocalizedString(@"LeftUp","")];
    [button1 setAccessibilityLabel:@"GuidingLineLeftUp".localized];
    MyButtonView *button2 = [self createButton:kGrabberLineRightDown file:@"right2.png" caption:NSLocalizedString(@"RightDown","")];
    [button2 setAccessibilityLabel:@"GuidingLineRightDown".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createFunctions
{
    MyButtonView *button1 = [self createButton:kGrabberRotate file:@"rotate2.png" caption:NSLocalizedString(@"Rotate","")];
    [button1 setAccessibilityLabel:@"Rotate".localized];
    MyButtonView *button2 = [self createButton:kGrabberMirror file:@"mirror2.png" caption:NSLocalizedString(@"Mirror","")];
    [button2 setAccessibilityLabel:@"Mirror".localized];
    [button2 setToggleButton:kToggle];
//    MyButtonView *button3 = [self createButton:kGrabberFreeze file:@"stop2.png" caption:NSLocalizedString(@"FreezeImage","")];
//    [button3 setAccessibilityLabel:@"FreezeImage".localized];
//    [button3 setToggleButton:kToggle];
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createOCR
{
//    MyButtonView *button1 = [self createButton:kGrabberOCR file:@"ocr2.png" caption:NSLocalizedString(@"OCR","")];
//    [button1 setAccessibilityLabel:@"StartOcr".localized];
    MyButtonView *button2 = [self createButton:kGrabberLetterBox file:@"letter2.png" caption:NSLocalizedString(@"Whole","")];
    [button2 setAccessibilityLabel:@"Whole".localized];
    [button2 setToggleButton:kToggle];
    return [[NSArray alloc] initWithObjects:button2, nil];
}

-(NSArray*) createHelp
{
    MyButtonView *button1 = [self createButton:kGrabberSplitMode file:@"change_window2.png" caption:NSLocalizedString(@"SplitModes","")];
    [button1 setAccessibilityLabel:@"SplitModes".localized];
    MyButtonView *button2 = [self createButton:kGrabberAlwaysOnTop file:@"button_pin2.png" caption:NSLocalizedString(@"AlwaysOnTop","")];
    [button2 setAccessibilityLabel:@"AlwaysOnTop".localized];
    [button2 setToggleButton:kToggle];
    MyButtonView *button3 = [self createButton:kGrabberHelp file:@"help2.png" caption:NSLocalizedString(@"Help","")];
    [button3 setAccessibilityLabel:@"OpenManual".localized];
    return [[NSArray alloc] initWithObjects:button1, button2, button3, nil];
}

#pragma mark delegate methods

-(void) handleClicked:(int)button withModifier:(NSUInteger)mod
{
    [delegate handleGrabberButtonClicked:button withModifier:mod];
}

-(void) handlePress:(int)button
{
    [delegate handleGrabberButtonPress:button];
}

-(void) handleRelease:(int)button
{
    [delegate handleGrabberButtonRelease:button];
}

-(void) handleButtonBecomesFirstResponder:(MyButtonView*)button
{
    [delegate handleButtonBecomesFirstResponder:button];
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

-(void) toggleButton:(GrabberButton)button withState:(BOOL)state
{
    MyButtonView* mybutton = (MyButtonView*)[mButtons objectAtIndex:button];
    [mybutton toggle:state];
}

-(void) setGroups:(NSMutableArray*)groups
{
    mPos = 0;
    [self removeAll];
    [self setGroupsHelp:groups];
}

-(void) setGroupsHelp:(NSMutableArray*)groups
{
    NSMutableArray *toLayer = [[NSMutableArray alloc] init];
    float bm = [MySizes buttonMargin];
    mPos = bm;
    
    if([[groups objectAtIndex:kColorsGrabber] boolValue]){
        [self setupColors:[mGroupControls objectAtIndex:kColorsGrabber]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Colors","")];
    }

    if([[groups objectAtIndex:kContrastGrabber] boolValue]){
        [self setupContrast:[mGroupControls objectAtIndex:kContrastGrabber]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Contrast","")];
    }
    if([[groups objectAtIndex:kReferenceLineGrabber] boolValue]){
        [self setupLineCurtain:[mGroupControls objectAtIndex:kReferenceLineGrabber]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"RefLineCurtain","")];
    }
    if([[groups objectAtIndex:kFunctionsGrabber] boolValue]){
        [self setupFunctions:[mGroupControls objectAtIndex:kFunctionsGrabber]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Functions","")];
    }
    if([[groups objectAtIndex:kOCRGrabber] boolValue]){
        [self setupOcr:[mGroupControls objectAtIndex:kOCRGrabber]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Whole","")];
    }
    if([[groups objectAtIndex:kHelpGrabber] boolValue]){
        [self setupHelp:[mGroupControls objectAtIndex:kHelpGrabber]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Help","")];
    }
//    [layer setGroups:toLayer];
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

-(void) setupFunctions:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
//    [self setupButtonHelp:[array objectAtIndex:2]];
}

-(void) setupOcr:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
//    [self setupButtonHelp:[array objectAtIndex:1]];
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


@end
