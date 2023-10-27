//
//  MyRibbonView.m
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-21.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import "MyRibbonView.h"
#import "MyButtonView.h"
#import "MyButtonBarView.h"
#import "MyCameraButtonBarView.h"
#import "MyOcrButtonBarView.h"
#import "MyGrabberButtonBarView.h"
//#import "Preferences.h"
#import "MyCheckBoxView.h"
#import "MyScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "MySizes.h"
#import "ScreenShot.h"

@implementation MyRibbonTab

-(id)initWithBackground:(NSColor*)back andForeground:(NSColor*)fore
{
    self = [super init];
    if(self){
        mBackground = back;
        mForeground = fore;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    //NSLog(@"drawRect %f %f %f %f", dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width, dirtyRect.size.height);
    
    NSRect rect = [self bounds];
    
    //NSLog(@"rect %f %f %f %f \n", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path appendBezierPathWithRect:dirtyRect];
    [mBackground setFill];
    [path fill];
    
    if(dirtyRect.size.width > rect.size.width * 0.5)
    {
        NSRect textRect = dirtyRect;
        textRect.origin.y += textRect.size.height * 0.10;
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attr = @{NSFontAttributeName:[NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]],NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:mForeground};
            
        [[self title] drawInRect:textRect withAttributes:attr];
    }
}

-(void) drawFocusRingMask
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path appendBezierPathWithRoundedRect:[self bounds] xRadius:1.5 yRadius:1.5];
    [path fill];
}

-(BOOL) acceptsFirstResponder
{
    return YES;
}

-(BOOL) needsPanelToBecomeKey
{
    return YES;
}

@end

@interface MyRibbonView()
{
    MyCameraButtonBarView *cameraView;
    MyOCRButtonBarView *ocrView;
//    MyGrabberButtonBarView *grabberView;

    MyScrollView *scrollView;

    MyRibbonTab *settingsTab;
    MyRibbonTab *cameraTab;
    MyRibbonTab *ocrTab;
//    MyRibbonTab *grabberTab;

    //MyRibbonLayer *layer;
    
    float originalHeight;
    float originalLayerPosition;

    NSInteger cameraGroups;
    NSInteger ocrGroups;
//    NSMutableArray *grabberGroups;
    NSArray *menuWidths;
    
    bool hasOCR;
}
@end

@implementation MyRibbonView
@synthesize delegate;

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark initialization methods

- (void)setup
{
    if (@available(macOS 10.14, *)) {
        [self setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
    }
    
    hasOCR = true;
    
    for(int i = 0 ; i < kNumberOfCameraGroups ; i++)
    {
//        [cameraGroups addObject:[NSNumber numberWithBool:YES]];
    }
    
    for(int i = 0 ; i < kNumberOfOcrGroups ; i++)
    {
//        [ocrGroups addObject:[NSNumber numberWithBool:YES]];
    }
    
//    grabberGroups = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < kNumberOfGrabberGroups ; i++)
    {
//        [grabberGroups addObject:[NSNumber numberWithBool:YES]];
    }
    
    [MySizes setSize:[self frame].size.height];
    
    NSRect rect = NSMakeRect(0, [self frame].size.height*0.01, [self frame].size.width, [self frame].size.height - [MySizes menuSize]-[self frame].size.height*0.01);

    scrollView = [[MyScrollView alloc] initWithFrame: rect];

    [scrollView setAutoresizingMask:NSViewWidthSizable];
    [MySizes setBarSize:[self frame].size.height - [MySizes menuSize] ];
    
    settingsTab = [[MyRibbonTab alloc] initWithBackground:[NSColor systemOrangeColor] andForeground:[NSColor whiteColor]];

    [settingsTab setTitle:NSLocalizedString(@"Settings","")];
    [settingsTab setTarget:self];
    [settingsTab setAction:@selector(tabAction:)];
    if (@available(macOS 10.12, *)) {
        [settingsTab setAccessibilityRole:NSAccessibilityMenuBarItemRole];
    }
    [self addSubview:settingsTab];
    
    cameraTab = [[MyRibbonTab alloc] initWithBackground:[NSColor whiteColor] andForeground:[NSColor blackColor]];
    [cameraTab setTitle:NSLocalizedString(@"Camera","")];
    [cameraTab setTarget:self];
    if (@available(macOS 10.12, *)) {
        [cameraTab setAccessibilityRole:NSAccessibilityMenuBarItemRole];
    }
    [cameraTab setAction:@selector(tabAction:)];

    [self addSubview:cameraTab];
    NSLog(@"MyRibbonView setup 4");

    ocrTab = [[MyRibbonTab alloc] initWithBackground:[NSColor whiteColor] andForeground:[NSColor blackColor]];
    [ocrTab setTitle:NSLocalizedString(@"OCR","")];
    [ocrTab setTarget:self];
    [ocrTab setAction:@selector(tabAction:)];
    if (@available(macOS 10.12, *)) {
        [ocrTab setAccessibilityRole:NSAccessibilityMenuBarItemRole];
    }
    [self addSubview:ocrTab];
    
    originalHeight = [self frame].size.height;
    
    [self setupCamera];
    [self setupOCR];
    [self setupGrabber];

    [scrollView setDocumentView:cameraView];
    
    [self addSubview:scrollView];
            
    [[self window] setAcceptsMouseMovedEvents:YES];
    
    NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect |
                                     NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
    
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                        options:options
                                                          owner:self
                                                       userInfo:nil];
    [self addTrackingArea:area];
    
    NSLog(@"MyRibbonView setup exit");
}

- (void) setupCamera
{
    NSRect rect = NSMakeRect(0, 0, [self frame].size.width, [MySizes buttonBarSize]);
    cameraView = [[MyCameraButtonBarView alloc] initWithFrame:rect];
    [cameraView setDelegate:self];
    [cameraView setHidden:NO];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    [buttons addObject:settingsTab];
    [buttons addObject:cameraTab];
    [buttons addObject:ocrTab];
    [buttons addObject:[scrollView getLeftButton]];
    [buttons addObject:[scrollView getRightButton]];

    [cameraView setupWithGroups:cameraGroups andButtons:buttons];
}

- (void) setupOCR
{
    NSRect rect = NSMakeRect(0, 0, [self frame].size.width, [MySizes buttonBarSize]);
    ocrView = [[MyOCRButtonBarView alloc] initWithFrame:rect];
    [ocrView setDelegate:self];
    [ocrView setHidden:YES];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    [buttons addObject:settingsTab];
    [buttons addObject:cameraTab];
    [buttons addObject:ocrTab];
    [buttons addObject:[scrollView getLeftButton]];
    [buttons addObject:[scrollView getRightButton]];

    [ocrView setupWithGroups:ocrGroups andButtons:buttons];
}

- (void) setupGrabber
{
//    NSRect rect = NSMakeRect(0, 0, [self frame].size.width, [MySizes buttonBarSize]);
//    grabberView = [[MyGrabberButtonBarView alloc] initWithFrame:rect];
//    [grabberView setDelegate:self];
//    [grabberView setHidden:YES];
//    [grabberTab setHidden:YES];
//    
//    NSMutableArray *buttons = [[NSMutableArray alloc] init];
//    [buttons addObject:settingsTab];
//    [buttons addObject:cameraTab];
//    [buttons addObject:ocrTab];
//    [buttons addObject:[scrollView getLeftButton]];
//    [buttons addObject:[scrollView getRightButton]];
//
//    [grabberView setupWithGroups:ocrGroups andButtons:buttons];
}

#pragma mark getter and setter

-(void) setScale:(float)scaleFactor
{
    NSRect selfRect = [self frame];
    selfRect.size.height = originalHeight * scaleFactor;
    [self setFrame:selfRect];
//    [layer setFrame:selfRect];
    
    [MySizes setSize:[self frame].size.height];
    [MySizes setBarSize:[self frame].size.height - [MySizes menuSize]];

    selfRect = NSMakeRect(0, [self frame].size.height*0.01, [self frame].size.width, [self frame].size.height - [MySizes menuSize]-[self frame].size.height*0.01);

    NSRect cr = [cameraView frame];
    cr.size.height = selfRect.size.height;
    [cameraView setFrame:cr];
    
    NSRect or = [ocrView frame];
    or.size.height = selfRect.size.height;
    [ocrView setFrame:or];
    
//    NSRect gr = [ocrView frame];
//    gr.size.height = selfRect.size.height;
//  [grabberView setFrame:gr];
    
    float mh = [MySizes menuSize];
    
    NSString *settings = NSLocalizedString(@"Settings","");
    float settingsWidth = [MySizes measureText:settings].width + [MySizes menuMargin];

    NSString *camera = NSLocalizedString(@"Camera","");
    float cameraWidth = [MySizes measureText:camera].width+[MySizes menuMargin];

    NSString *ocr = NSLocalizedString(@"OCR","");
    float ocrWidth = [MySizes measureText:ocr].width+[MySizes menuMargin];

//    NSString *grabber = NSLocalizedString(@"Grabber","");
//    float grabberWidth = [MySizes measureText:grabber].width+[MySizes menuMargin];

    float positions[3] = {settingsWidth,settingsWidth + cameraWidth, settingsWidth + cameraWidth + ocrWidth /*, settingsWidth + cameraWidth + ocrWidth + grabberWidth */};
    
    float space = mh * 0.05;
    
    [settingsTab setFrame:NSMakeRect(0, [self bounds].size.height - mh + space, positions[0] - space, mh - space*2)];
    [cameraTab setFrame:NSMakeRect(positions[0] + space, [self bounds].size.height - mh + space, positions[1] - positions[0] - space*2, mh - space*2)];
    [ocrTab setFrame:NSMakeRect(positions[1] + space, [self bounds].size.height - mh + space, positions[2] - positions[1] - space*2, mh - space*2)];

//    [grabberTab setFrame:NSMakeRect(positions[2] + space, [self bounds].size.height - mh + space, positions[3] - positions[2] - space*2, mh - space*2)];

    [cameraView setGroups:cameraGroups];
    [ocrView setGroups:ocrGroups];
//    [grabberView setGroups:grabberGroups];

    [scrollView setFrame:selfRect];    
}

-(void) toggleCameraButton:(int)button withState:(bool)state
{
    [cameraView toggleButton:(button) withState:state];
}

-(void) toggleAutofocusWithState:(bool)state
{
    [cameraView toggleAutofocusWithState:state];
}

-(void) toggleOcrButton:(int)button withState:(bool)state
{
    [ocrView toggleButton:(button) withState:state];
}

//-(void) toggleGrabberButton:(int)button withState:(bool)state
//{
//    [grabberView toggleButton:button withState:state];
//}

-(void) tabAction:(MyRibbonTab*)tab
{
    if(tab == settingsTab){
        [delegate handleSettings];
    }
    else if(tab == cameraTab && [cameraView isHidden]){
        [self setTab:kTabCamera];
        [delegate handleTabSwitch:kTabCamera];
    }
    else if(tab == ocrTab && [ocrView isHidden]){
        [self setTab:kTabOcr];
        [delegate handleTabSwitch:kTabOcr];
    }
//    else if(tab == grabberTab && [grabberView isHidden]){
//        [self setTab:kTabGrabber];
//        [delegate handleTabSwitch:kTabGrabber];
//    }
}

-(void) setTab:(RibbonTab)tab
{
    if(tab == kTabCamera){
        [cameraView setHidden:NO];
        [ocrView setHidden:YES];
//        [grabberView setHidden:YES];
        [scrollView setDocumentView:cameraView];
        [self setNeedsDisplay:YES];
        [settingsTab setNeedsDisplay:YES];
        [cameraTab setNeedsDisplay:YES];
        [ocrTab setNeedsDisplay:YES];
//       [grabberTab setNeedsDisplay:YES];
    }
    else if(tab == kTabOcr){
        [cameraView setHidden:YES];
        [ocrView setHidden:NO];
//        [grabberView setHidden:YES];
        [scrollView setDocumentView:ocrView];
        [self setNeedsDisplay:YES];
        [settingsTab setNeedsDisplay:YES];
        [cameraTab setNeedsDisplay:YES];
        [ocrTab setNeedsDisplay:YES];
//        [grabberTab setNeedsDisplay:YES];
    }
    else if(tab == kTabGrabber){
        [cameraView setHidden:YES];
        [ocrView setHidden:YES];
//        [grabberView setHidden:NO];
//        [scrollView setDocumentView:grabberView];
        [self setNeedsDisplay:YES];
        [settingsTab setNeedsDisplay:YES];
        [cameraTab setNeedsDisplay:YES];
        [ocrTab setNeedsDisplay:YES];
//        [grabberTab setNeedsDisplay:YES];
    }
}

-(RibbonTab) getTab
{
    if(![cameraView isHidden]){
        return kTabCamera;
    }
    else if(![ocrView isHidden]){
        return kTabOcr;
    }
    else{
        return kTabGrabber;
    }
}

-(void) setFont:(NSString*)name
{
    [ocrView setFont:name];
}

-(void) setFontSize:(int)size
{
    [ocrView setFontSize:size];
}

-(void) setVolume:(double)volume
{
    [ocrView setVolume:volume];
}

-(void) setSpeed:(double)speed
{
    [ocrView setSpeed:speed];
}

-(void) setFunctions:(Functions)functions
{
    hasOCR = functions.ocr;
    
    cameraGroups = functions.manualFocus ? cameraGroups | RibbonGroup_CameraManualFocus : cameraGroups & ~RibbonGroup_CameraManualFocus;

    cameraGroups = functions.recording ? cameraGroups | RibbonGroup_CameraVideo : cameraGroups & ~RibbonGroup_CameraVideo;

    cameraGroups = functions.recording ? cameraGroups | RibbonGroup_CameraPicture : cameraGroups & ~RibbonGroup_CameraPicture;

    cameraGroups = functions.light ? cameraGroups | RibbonGroup_CameraLight : cameraGroups & ~RibbonGroup_CameraLight;

    cameraGroups = functions.ocr ? cameraGroups | RibbonGroup_CameraOCR : cameraGroups & ~RibbonGroup_CameraOCR;
                          
    [ocrTab setHidden:functions.ocr == false];
    [ocrTab setEnabled:functions.ocr == true];
    [cameraView setGroups:cameraGroups];
}

//-(void) setGrabber:(bool)enable
//{
////    [grabberTab setHidden:!enable];
////    [grabberTab setEnabled:enable];
//}
//
//-(bool) getGrabber
//{
//    return [grabberTab isHidden] == false;
//}

-(NSInteger) getCameraGroups
{
    return cameraGroups;
}

-(void) setAllCameraGroups
{
    [self setCameraGroups:RibbonGroup_CameraAll];
}

-(void) setCameraGroups:(NSInteger)groups
{
    cameraGroups = groups;
    [cameraView setGroups:groups];
}

-(NSInteger) getOcrGroups
{
    return ocrGroups;
}

-(void) setAllOcrGroups
{
    [self setOcrGroups:RibbonGroup_OcrAll];
}

-(void) setOcrGroups:(NSInteger)groups
{
    ocrGroups = groups;
    [ocrView setGroups:groups];
}

-(void) setToggleSources:(bool)value
{
    [cameraView setToggleSources:value];
}

-(void) setPageNumber:(int)number andCount:(int)count
{
    [ocrView setPageNumber:number andCount:count];
}

#pragma mark delegate methods

-(void) handleCameraButtonClicked:(CameraButton)button withModifier:(NSUInteger)mod
{
    [delegate handleCameraButtonClicked:button withModifier:mod];
}

-(void) handleCameraButtonPress:(CameraButton)button
{
    [delegate handleCameraButtonPress:button];
}

-(void) handleCameraButtonRelease:(CameraButton)button
{
    [delegate handleCameraButtonRelease:button];
}

-(void) handleAutofocusClicked;
{
    [delegate handleAutofocusClicked];
}

-(void) handleOcrButtonClicked:(OcrButton)button withModifier:(NSInteger)mod
{
    [delegate handleOcrButtonClicked:button withModifier:mod];
}

//- (void) handleGrabberButtonClicked:(GrabberButton)button withModifier:(bool)mod
//{
//    [delegate handleGrabberButtonClicked:button withModifier:mod];
//}

- (void) handleGrabberButtonPress:(GrabberButton)button
{
    [delegate handleGrabberButtonPress:button];
}

- (void) handleGrabberButtonRelease:(GrabberButton)button
{
    [delegate handleGrabberButtonRelease:button];
}

-(void) handleVolumeChanged:(double)value
{
    if(delegate != nil){
        [delegate handleVolumeChanged:value];
    }
}

-(void) handleSpeedChanged:(double)value
{
    [delegate handleSpeedChanged:value];
}

-(void) handleFontChanged:(NSString*)name
{
    [delegate handleFontChanged:name];
}

-(void) handleFontSizeChanged:(int)size
{
    [delegate handleFontSizeChanged:size];
}

-(void) handlePages:(int)pages
{
    [delegate handlePages:pages];
}

-(void) handleButtonBecomesFirstResponder:(MyButtonView*)button
{
    [scrollView controlFocus:[button frame]];
}

#pragma mark mouse methods

- (void)drawRect:(NSRect)dirtyRect {
    
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path appendBezierPathWithRect:dirtyRect];
    [[NSColor whiteColor] set];
    [path fill];
    
    float mh = [MySizes menuSize];
    float space = mh * 0.05;
    NSRect frame = [settingsTab frame];
    frame.origin.y -= space;
    frame.size.height += space*2;
    
    path = [NSBezierPath bezierPath];
    [path appendBezierPathWithRect:frame];
    [[NSColor systemOrangeColor] setFill];
    [path fill];

    NSString *settings = NSLocalizedString(@"Settings","");
    float settingsWidth = [MySizes measureText:settings].width + [MySizes menuMargin];

    NSString *camera = NSLocalizedString(@"Camera","");
    float cameraWidth = [MySizes measureText:camera].width+[MySizes menuMargin];

    NSString *ocr = NSLocalizedString(@"OCR","");
    float ocrWidth = [MySizes measureText:ocr].width+[MySizes menuMargin];

    NSString *grabber = NSLocalizedString(@"Grabber","");
    float grabberWidth = [MySizes measureText:grabber].width+[MySizes menuMargin];

    float positions[4] = {settingsWidth,settingsWidth + cameraWidth, settingsWidth + cameraWidth + ocrWidth, settingsWidth + cameraWidth + ocrWidth + grabberWidth};

    int selected = 0;
    if(![ocrView isHidden]){
        selected = 1;
    }
//    else if(![grabberView isHidden]){
//        selected = 2;
//    }
    
    path = [NSBezierPath bezierPath];
    [path setLineWidth:0.4]; //bör ändras
    [[NSColor blackColor] set];
    [path moveToPoint:NSMakePoint(settingsWidth, [self bounds].size.height - mh)];
    [path lineToPoint:NSMakePoint(positions[selected], [self bounds].size.height - mh)];
    [path lineToPoint:NSMakePoint(positions[selected], [self bounds].size.height)];
    [path lineToPoint:NSMakePoint(positions[selected+1], [self bounds].size.height)];
    [path lineToPoint:NSMakePoint(positions[selected+1], [self bounds].size.height - mh)];
    [path lineToPoint:NSMakePoint([self bounds].size.width, [self bounds].size.height - mh)];

    [path stroke];
}

-(BOOL) acceptsFirstMouse:(NSEvent *)event
{
    return YES;
}

-(BOOL) acceptsFirstResponder
{
    return NO;
}

int counter = 0;
- (BOOL)becomeFirstResponder
{
//    [layer setResponder:0];
    return YES;
}

-(BOOL)resignFirstResponder
{
//    [layer setResponder:-1];
    counter--;
    NSLog(@"Counter %d",counter);
    if(counter <= 0){
        return YES;
    }
    else{
        return NO;
    }
}

- (void)mouseEntered:(NSEvent *)theEvent
{
}

- (void)mouseExited:(NSEvent *)theEvent {
}

-(void) mouseDown:(NSEvent *)event
{
//    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
//    //NSLog(@"Location %f %f",location.x,location.y);
//
//    if(location.y > [self bounds].size.height - [MySizes menuSize])
//    {
//        //NSLog(@"Menu Location %f %f",location.x,location.y);
//        if(location.x < [[menuWidths objectAtIndex:0] floatValue]){
//            [delegate handleSettings];
//            NSLog(@"Settings");
//        }
//        if(hasOCR){
//            if([layer getSelected] != 0 && location.x < [[menuWidths objectAtIndex:0] floatValue] + [[menuWidths objectAtIndex:1] floatValue]){
//                [delegate handleTabSwitch:kTabCamera];
//                [self setTab:kTabCamera];
//                NSLog(@"Camera");
//            }
//            else if([layer getSelected] != 1 && [[menuWidths objectAtIndex:0] floatValue] + [[menuWidths objectAtIndex:1] floatValue] < location.x && location.x < [[menuWidths objectAtIndex:0] floatValue] + [[menuWidths objectAtIndex:1] floatValue] + [[menuWidths objectAtIndex:2] floatValue]){
//                [delegate handleTabSwitch:kTabOcr];
//                [self setTab:kTabOcr];
//                NSLog(@"OCR");
//            }
//        }
//    }
}

-(void) mouseUp:(NSEvent *)event
{
    //NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    //NSLog(@"Location %f %f",location.x,location.y);
}

/*
- (void) keyDown:(NSEvent *)event
{
    NSLog(@"KeyDown %d",[event keyCode]);
    if([event keyCode] == 0x31) //Space
    {
        NSUInteger modifierFlags = [event modifierFlags];
        BOOL altIsPressed = (modifierFlags & NSAlternateKeyMask) != 0;
    }
    else if([event keyCode] == 0x30)
    {
        
    }
    else{
        [super keyDown:event];
    }
}

-(void) keyUp:(NSEvent *)event
{
    if([event keyCode] == 0x31)
    {
    }
    else{
        [super keyUp:event];
    }
}
*/

#ifdef DEBUG

-(void) takeScreenShot
{
    if([ocrView isHidden])
    {
        [cameraView takeScreenShot];
    }
    else{
        [ocrView takeScreenShot];
    }
}

#endif


@end
