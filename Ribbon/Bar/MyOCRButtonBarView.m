//
//  MyOCRButtonBarView.m
//  TestNSView
//
//  Created by Erik Sandström on 2019-06-25.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import "MyOCRButtonBarView.h"
#import "MyButtonView.h"
#import "MyPagesView.h"
#import "MySizes.h"
#import "MySliderControl.h"
#import "ScreenShot.h"
#import "Localization.h"
//#import "Preferences.h"

@interface MyOCRButtonBarView()
{
    float mPos;
    MyPagesView *pages;
    NSTextField* volumeLabel;
    NSTextField* speedLabel;
    MySliderControl* volumeSlider;
    MySliderControl* speedSlider;
    NSArray *mOutsideButtons;
    NSPopUpButton* fontNamePopup;
    NSPopUpButton* fontSizePopup;
    
    NSArray *mControls;
    NSMutableArray *mButtons;
}
@end

@implementation MyOCRButtonBarView
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
    for(NSArray *arr in mControls)
    {
        for(NSView *v in arr){
            if(v == pages){
                NSArray *arr = [pages getButtons];
                [temp addObjectsFromArray:arr];
            }
            else{
                [temp addObject:v];
            }
        }
    }
    for(int i = 0 ; i < [temp count] ; i++)
    {
        [[temp objectAtIndex:i] setNextKeyView:[temp objectAtIndex:(i+1) % [temp count]]];
    }
}

#pragma mark initialization methods

-(void) setupWithGroups:(NSMutableArray*)groups  andButtons:(NSArray*)buttons;
{
    //[self setWantsLayer:YES];
    mOutsideButtons = buttons;
    
    mButtons = [[NSMutableArray alloc] initWithCapacity:kNumberOcrButtons];
    
    NSArray* document = [self createDocument];
    NSArray* color = [self createColor];
    NSArray* font = [self createFont];
    NSArray* speech = [self createSpeech];
    NSArray* navigation = [self createNavigation];

    NSArray* volume = [self createVolumeAndSpeed];
    NSArray* pages = [self createPages];
    NSArray* help = [self createHelp];
    
    mControls = [[NSArray alloc] initWithObjects:document, color, font, speech, navigation, volume, pages, help, nil];
    
    [self setGroupsHelp:groups];
    
    [self setFrameSize:NSMakeSize(mPos, [self frame].size.height)];
    
    [self setNeedsDisplay:YES];
}

-(MyButtonView*) createButton:(int)button file:(NSString*)filename caption:(NSString*)text
{
    MyButtonView *mybutton = [[MyButtonView alloc] initWithFilename:filename andCaption:text andButton:button];
    [mybutton setDelegate:self];
    [mButtons insertObject:mybutton atIndex:button];
    return mybutton;
}

-(NSArray*) createDocument
{
    MyButtonView *button1 = [self createButton:kOcrSave file:@"close_save2.png" caption:NSLocalizedString(@"Save","")];
    [button1 setAccessibilityLabel:@"SaveDocument".localized];
    MyButtonView *button2 = [self createButton:kOcrOpen file:@"open2.png" caption:NSLocalizedString(@"Open","")];
    [button2 setAccessibilityLabel:@"OpenDocument".localized];
 
    [button1 setNextKeyView:button2];
    
    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createColor
{
    MyButtonView *button1 = [self createButton:kOcrNatural file:@"stripedmoon2.png" caption:NSLocalizedString(@"Natural","")];
    [button1 setAccessibilityLabel:@"NaturalColors".localized];

    MyButtonView *button2 = [self createButton:kOcrArtificial file:@"halfmoon2.png" caption:NSLocalizedString(@"Artificial","")];
    [button2 setAccessibilityLabel:@"ArtificialColors".localized];

    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createFont
{
    fontNamePopup = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, [MySizes fontPopUpWidth], [MySizes popUpHeight]) pullsDown:YES];
    
    [fontNamePopup setBezelStyle:NSBezelStyleRegularSquare ];
    
    [fontNamePopup.cell setArrowPosition:NSPopUpArrowAtBottom];
    
    [fontNamePopup setFont: [NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]]];
    
    [fontNamePopup setBordered:YES];
    
    [self populateFont];
    
    [fontNamePopup setAction:@selector(popupValueChanged:)];
    [fontNamePopup setTarget:self];
    [fontNamePopup setAccessibilityLabel:@"Font".localized];
    
    fontSizePopup = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0,  [MySizes sizePopUpWidth], [MySizes popUpHeight]) pullsDown:YES];
    NSArray *fontsizes = [MySizes fontSizes];
    
    [fontSizePopup addItemWithTitle:@"0"];
    for(NSString* size in fontsizes){
        [fontSizePopup addItemWithTitle:size];
    }
    [fontSizePopup setTitle:[fontsizes objectAtIndex:0]];
    [fontSizePopup setBezelStyle:NSBezelStyleRegularSquare ];
    
    [fontSizePopup.cell setArrowPosition:NSPopUpArrowAtBottom];
    [fontSizePopup setAccessibilityLabel:@"FontSize".localized];
    
    [fontSizePopup setFont: [NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]]];
    
    [fontSizePopup setBordered:YES];
    
    [fontSizePopup setAction:@selector(popupValueChanged:)];
    [fontSizePopup setTarget:self];
    
    return [[NSArray alloc] initWithObjects:fontNamePopup, fontSizePopup, nil];
}

-(void) populateFont
{
    NSArray *fonts = [[NSFontManager sharedFontManager] availableFontFamilies];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    [fontNamePopup addItemWithTitle:@"Foo"];
    for(NSString* font in fonts)
    {
        [fontNamePopup addItemWithTitle:font];
    }
    
    for(int i = 1 ; i <= [fonts count] ; i++)
    {
        NSAttributedString *name= [[NSAttributedString alloc] initWithString:[fonts objectAtIndex:i-1]
        attributes:[NSDictionary
                    dictionaryWithObjectsAndKeys:[NSFont fontWithName:[fonts objectAtIndex:i-1] size:[MySizes fontSize]],
                    NSFontAttributeName,
                    paragraphStyle, NSParagraphStyleAttributeName,
                    [NSColor blackColor],NSForegroundColorAttributeName
                    ,nil]];
        
        NSMenuItem* item = [fontNamePopup itemAtIndex:i];
        [item setAttributedTitle:name];
    }

    [fontNamePopup setTitle:[fonts objectAtIndex:0]];
}

-(NSArray*) createSpeech
{
    MyButtonView *button1 = [self createButton:kOcrStart file:@"play2.png" caption:NSLocalizedString(@"Play","")];
    [button1 setAlternativeFilename:@"paus2.png" andCaption:NSLocalizedString(@"Pause","")];
    [button1 setAccessibilityLabel:@"StartSpeech".localized];

    MyButtonView *button2 = [self createButton:kOcrStop file:@"stop2.png" caption:NSLocalizedString(@"Stop","")];
    [button2 setAccessibilityLabel:@"StopSpeech".localized];

    return [[NSArray alloc] initWithObjects:button1, button2, nil];
}

-(NSArray*) createNavigation
{
    MyButtonView *button1 = [self createButton:kOcrDisplayMode file:@"navigation42.png" caption:NSLocalizedString(@"ViewModes","")];
    [button1 setAccessibilityLabel:@"ViewModes".localized];

    MyButtonView *button2 = [self createButton:kOcrQuietMode file:@"quiet2.png" caption:NSLocalizedString(@"Quiet","")];
    [button2 setAccessibilityLabel:@"QuietMode".localized];

    MyButtonView *button3 = [self createButton:kOcrNavigateBack file:@"navigation22.png" caption:NSLocalizedString(@"Back","")];
    [button3 setAccessibilityLabel:@"Back".localized];

    MyButtonView *button4 = [self createButton:kOcrNavigateForward file:@"navigation32.png" caption:NSLocalizedString(@"Forward","")];
    [button4 setAccessibilityLabel:@"Forward".localized];

    MyButtonView *button5 = [self createButton:kOcrReadMode file:@"navigation12.png" caption:NSLocalizedString(@"ReadMode","")];
    [button5 setAccessibilityLabel:@"ReadMode".localized];

    return [[NSArray alloc] initWithObjects:button1, button2, button3, button4, button5, nil];
}

-(NSArray*) createVolumeAndSpeed
{
    volumeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 80, 20)];
    
    [volumeLabel setStringValue:NSLocalizedString(@"Volume","")];
    [volumeLabel setBezeled:NO];
    [volumeLabel setDrawsBackground:NO];
    [volumeLabel setEditable:NO];
    [volumeLabel setSelectable:NO];
    [volumeLabel setFont:[NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]]];
    
    float volumeWidth = [MySizes measureText:[volumeLabel stringValue]].width + 2 * [MySizes buttonMargin];
    [volumeLabel setFrame:NSMakeRect(0, 0, volumeWidth, [MySizes sliderHeight])];
    
    volumeSlider = [[MySliderControl alloc] initWithFrame:NSMakeRect(0, 0, [MySizes sliderWidth], [MySizes sliderHeight])];
    [volumeSlider setMinValue:10];
    [volumeSlider setMaxValue:100];
    [volumeSlider setTarget:self];
    [volumeSlider setAction:@selector(sliderValueChanged:)];
        
    [volumeSlider setAccessibilityLabel:@"Volume".localized];
    [volumeSlider setAccessibilityRole:NSAccessibilitySliderRole];
    
    speedLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 80, 20)];
    [speedLabel setStringValue:NSLocalizedString(@"Speed","")];
    [speedLabel setBezeled:NO];
    [speedLabel setDrawsBackground:NO];
    [speedLabel setEditable:NO];
    [speedLabel setSelectable:NO];
    [speedLabel setFont:[NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]]];
    float speedWidth = [MySizes measureText:[speedLabel stringValue]].width + 2*[MySizes buttonMargin];
    [speedLabel setFrame:NSMakeRect(0, 0, speedWidth, [MySizes sliderHeight])];
    
    speedSlider = [[MySliderControl alloc] initWithFrame:NSMakeRect(0, 0, [MySizes sliderWidth], [MySizes sliderHeight])];
    [speedSlider setMinValue:90];
    [speedSlider setMaxValue:350];
    [speedSlider setTarget:self];
    [speedSlider setAction:@selector(sliderValueChanged:)];
    [speedSlider setAccessibilityLabel:@"Speed".localized];
    [speedSlider setAccessibilityRole:NSAccessibilitySliderRole];
/*
    [speedSlider setAccessibilityValue:[NSNumber numberWithFloat:50]];
    [speedSlider setAccessibilityElement:NO];
    
    [speedSlider setAccessibilityContents:nil];
    [speedSlider setAccessibilityLabelUIElements:nil];
    [speedSlider setAccessibilityLabelValue:45];
*/
    
    [volumeLabel setTextColor: [NSColor blackColor]];
    speedLabel.textColor = [NSColor blackColor];
    
    return [[NSArray alloc] initWithObjects:volumeLabel, volumeSlider, speedLabel, speedSlider, nil];
}

-(NSArray*) createPages
{
    pages = [[MyPagesView alloc] init];
    pages.delegate = self;
    return [[NSArray alloc] initWithObjects:pages, nil];
}

-(NSArray*) createHelp
{
    MyButtonView *button1 = [self createButton:kOcrSplit file:@"change_window2.png" caption:NSLocalizedString(@"SplitModes","")];
    [button1 setAccessibilityLabel:@"SplitModes".localized];

    MyButtonView *button2 = [self createButton:kOcrAlwaysOnTop file:@"button_pin2.png" caption:NSLocalizedString(@"AlwaysOnTop","")];
    [button2 setAccessibilityLabel:@"AlwaysOnTop".localized];
    [button2 setToggleButton:kToggle];
    
    MyButtonView *button3 = [self createButton:kOcrHelp file:@"help2.png" caption:NSLocalizedString(@"Help","")];
    [button3 setAccessibilityLabel:@"OpenManual".localized];

    return [[NSArray alloc] initWithObjects:button1, button2, button3, nil];
}

#pragma mark getter and setter

-(void) removeAll
{
    for(int i = 0; i < [mControls count] ; i++){
        NSArray *arr = [mControls objectAtIndex:i];
        for(int j = 0; j < [arr count]; j++)
        {
            [[arr objectAtIndex:j] removeFromSuperview];
        }
    }
}

-(void) setGroups:(NSInteger)groups
{
    mPos = 0;
    [self removeAll];
    [self setGroupsHelp:groups];
}

-(void) setGroupsHelp:(NSInteger)groups
{
    NSMutableArray *toLayer = [[NSMutableArray alloc] init];
    float bm = [MySizes buttonMargin];
    mPos = bm;
    
    if((groups & RibbonGroup_OcrDocument) != 0){
        [self setupDocument:[mControls objectAtIndex:kDocument]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Document","")];
    }
    if((groups & RibbonGroup_OcrColors) != 0){
        [self setupColor:[mControls objectAtIndex:kColorsOcr]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Colors","")];
    }
    if((groups & RibbonGroup_OcrFont) != 0){
        [self setupFonts:[mControls objectAtIndex:kFonts]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Font","")];
    }
    if((groups & RibbonGroup_OcrSpeech) != 0){
        [self setupSpeech:[mControls objectAtIndex:kSpeech]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Speech","")];
    }
    if((groups & RibbonGroup_OcrNavigation) != 0){
        [self setupNavigation:[mControls objectAtIndex:kNavigation]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Navigate","")];
    }
    if((groups & RibbonGroup_OcrVolumeAndSpeed) != 0){
        [self setupVolumeAndSpeed:[mControls objectAtIndex:kVolumeAndSpeed]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"VolumeAndSpeed","")];
    }
    if((groups & RibbonGroup_OcrPages) != 0){
        [self setupPages:[mControls objectAtIndex:kPages]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Pages","")];
    }
    if((groups & RibbonGroup_OcrHelp) != 0){
        [self setupHelp:[mControls objectAtIndex:kHelpOcr]];
        [toLayer addObject:[NSNumber numberWithFloat:mPos]];
        [toLayer addObject:NSLocalizedString(@"Help","")];
    }
    
//    [layer setGroups:toLayer];
    mDrawArray = toLayer;
    [self setNeedsDisplay:YES];
    
    mPos += bm;
    
    [self setFrameSize:NSMakeSize(mPos, [self frame].size.height)];
}

-(void) toggleButton:(int)button withState:(BOOL)state
{
    MyButtonView* mybutton = (MyButtonView*)[mButtons objectAtIndex:button];
    [mybutton toggle:state];
}

-(void) setFont:(NSString*)name
{
    [fontNamePopup selectItemWithTitle:name];
    [fontNamePopup setTitle:name];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
     
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSMenuItem* item = [fontNamePopup itemAtIndex:0];
    NSAttributedString *aname= [[NSAttributedString alloc] initWithString:name
    attributes:[NSDictionary
                dictionaryWithObjectsAndKeys:[NSFont fontWithName:name size:[MySizes fontSize]],
                NSFontAttributeName,
                paragraphStyle, NSParagraphStyleAttributeName,
                [NSColor blackColor],NSForegroundColorAttributeName
                ,nil]];
    
    [item setAttributedTitle:aname];
}

-(void) setFontSize:(int)size
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSString *val = [NSString stringWithFormat:@"%d",size ];
               
    NSMenuItem* item = [fontSizePopup itemAtIndex:0];
    NSAttributedString *aname= [[NSAttributedString alloc] initWithString:val
    attributes:[NSDictionary
                dictionaryWithObjectsAndKeys:[NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]],
                NSFontAttributeName,
                paragraphStyle, NSParagraphStyleAttributeName,
                [NSColor blackColor],NSForegroundColorAttributeName
                ,nil]];
    
    [fontSizePopup selectItemWithTitle:val];
    [item setAttributedTitle:aname];
}

-(void) setVolume:(double)volume
{
    [volumeSlider setFloatValue:volume];
}

-(void) setSpeed:(double)speed
{
    [speedSlider setFloatValue:speed];
}

-(void) setPageNumber:(int)number andCount:(int)count
{
    [pages setPageNumber:number andCount:count];
}

#pragma mark delegate methods

-(void) handleClicked:(int)button withModifier:(NSUInteger)mod
{
    [delegate handleOcrButtonClicked:button withModifier:mod];
}

-(void) handlePages:(int)pages
{
    [delegate handlePages:pages];
}

-(void) handlePress:(int)button
{
}

-(void) handleRelease:(int)button
{
}

-(void) handleButtonBecomesFirstResponder:(MyButtonView*)button
{
    [delegate handleButtonBecomesFirstResponder:button];
}

-(void)sliderValueChanged:(MySliderControl *)sender{
    if(sender == volumeSlider){
        [delegate handleVolumeChanged:[sender floatValue]];
    }
    else if(sender == speedSlider){
        [delegate handleSpeedChanged:[sender floatValue]];
    }
}

- (IBAction)popupValueChanged:(id)sender
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;

    if(sender == fontNamePopup){
        NSString *name = [fontNamePopup titleOfSelectedItem];
        
        NSMenuItem* item = [fontNamePopup itemAtIndex:0];
        NSAttributedString *aname= [[NSAttributedString alloc] initWithString:name
        attributes:[NSDictionary
                    dictionaryWithObjectsAndKeys:[NSFont fontWithName:name size:[MySizes fontSize]],
                    NSFontAttributeName,
                    paragraphStyle, NSParagraphStyleAttributeName,
                    [NSColor blackColor],NSForegroundColorAttributeName
                    ,nil]];
        
        [item setAttributedTitle:aname];
        
        [delegate handleFontChanged:name];
    }
    else if(sender == fontSizePopup){
        [(NSPopUpButton *) sender setTitle:[(NSPopUpButton *) sender titleOfSelectedItem]];
        int size = [[fontSizePopup titleOfSelectedItem] intValue];
        
        NSString *name = [fontSizePopup titleOfSelectedItem];
                
        NSMenuItem* item = [fontSizePopup itemAtIndex:0];
        NSAttributedString *aname= [[NSAttributedString alloc] initWithString:name
        attributes:[NSDictionary
                    dictionaryWithObjectsAndKeys:[NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]],
                    NSFontAttributeName,
                    paragraphStyle, NSParagraphStyleAttributeName,
                    [NSColor blackColor],NSForegroundColorAttributeName
                    ,nil]];
        
        [item setAttributedTitle:aname];
        
        [delegate handleFontSizeChanged:size];
    }

    NSLog(@"My NSPopupButton selected value is: %@", [(NSPopUpButton *) sender titleOfSelectedItem]);
}

#pragma mark setup methods

- (void) setupDocument:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

- (void) setupColor:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

- (void) setupFonts:(NSArray*)array
{
    float bo = [MySizes groupLabelHeight];
    float bm = [MySizes buttonMargin];

    mPos += bm;
    NSPopUpButton *button = [array objectAtIndex:0];
    [button setFrameSize:NSMakeSize( [MySizes fontPopUpWidth], [MySizes popUpHeight] )];
    [button setFrameOrigin:NSMakePoint(mPos, /*[self bounds].size.height*/ bo*2.1)];
    [self addSubview:button];
    mPos += [button bounds].size.width + bm;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSString *name = [fontNamePopup titleOfSelectedItem];
    if(name != nil){
            
        NSMenuItem* item = [fontNamePopup itemAtIndex:0];
        NSAttributedString *aname= [[NSAttributedString alloc] initWithString:name
        attributes:[NSDictionary
                    dictionaryWithObjectsAndKeys:[NSFont fontWithName:name size:[MySizes fontSize]],
                    NSFontAttributeName,
                    paragraphStyle, NSParagraphStyleAttributeName,
                    [NSColor blackColor],NSForegroundColorAttributeName
                    ,nil]];
                
        [item setAttributedTitle:aname];
    }
    
    name = [fontSizePopup titleOfSelectedItem];
    if(name != nil){
            
        NSMenuItem* item = [fontSizePopup itemAtIndex:0];
        NSAttributedString *aname= [[NSAttributedString alloc] initWithString:name
        attributes:[NSDictionary
                    dictionaryWithObjectsAndKeys:[NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]],
                    NSFontAttributeName,
                    paragraphStyle, NSParagraphStyleAttributeName,
                    [NSColor blackColor],NSForegroundColorAttributeName
                    ,nil]];
        
        [item setAttributedTitle:aname];
    }

    button = [array objectAtIndex:1];
    [button setFrameSize:NSMakeSize( [MySizes sizePopUpWidth], [MySizes popUpHeight] )];
    [button setFrameOrigin:NSMakePoint(mPos, /*[self bounds].size.height*/ bo*2.1)];
    [self addSubview:button];

    mPos += [button bounds].size.width + bm;
}

- (void) setupSpeech:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
}

- (void) setupNavigation:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    mPos += bm;
    [self setupButtonHelp:[array objectAtIndex:0]];
    [self setupButtonHelp:[array objectAtIndex:1]];
    [self setupButtonHelp:[array objectAtIndex:2]];
    [self setupButtonHelp:[array objectAtIndex:3]];
    [self setupButtonHelp:[array objectAtIndex:4]];
}

- (void) setupVolumeAndSpeed:(NSArray*)array
{
    float bo = [MySizes groupLabelHeight];
    float bm = [MySizes buttonMargin];
    
    mPos += bm;
    
    NSTextField *textfield1 = [array objectAtIndex:0];
    [textfield1 setFont:[NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]]];
    
    NSSize size = [MySizes measureText:[textfield1 stringValue]];
    size.width += bm;
    
    [textfield1 setFrameSize:size];
    [textfield1 setFrameOrigin:NSMakePoint(mPos, /*[self bounds].size.height*/ + bo*3.2)];
    [self addSubview:textfield1];
    
    NSTextField *textfield2 = [array objectAtIndex:2];
    [textfield2 setFont:[NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]]];
    size = [MySizes measureText:[textfield2 stringValue]];
    size.width += bm;
    
    [textfield2 setFrameSize:size];
    [textfield2 setFrameOrigin:NSMakePoint(mPos, /*[self bounds].size.height*/ + bo*1.7)];
    [self addSubview:textfield2];
    
    mPos += MAX([textfield1 bounds].size.width, [textfield2 bounds].size.width) + bm;
    
    MySliderControl *slider = [array objectAtIndex:1];
    [slider setFrameSize:NSMakeSize([MySizes sliderWidth], [MySizes sliderHeight])];
    [slider setFrameOrigin:NSMakePoint(mPos, /*[self bounds].size.height*/ + bo*2.9)];
    [slider resize];
    [self addSubview:slider];
    
    slider = [array objectAtIndex:3];
    [slider setFrameSize:NSMakeSize([MySizes sliderWidth], [MySizes sliderHeight])];
    [slider setFrameOrigin:NSMakePoint(mPos, /*[self bounds].size.height*/ + bo*1.4)];
    [slider resize];
    [self addSubview:slider];

    mPos += [slider bounds].size.width + bm;
}

- (void) setupPages:(NSArray*)array
{
    float bm = [MySizes buttonMargin];
    float bo = [MySizes groupLabelHeight];
    
    mPos += bm;
    MyPagesView *pages = (MyPagesView*)[array objectAtIndex:0];
    [pages resize];
    [pages setFrameOrigin:NSMakePoint(mPos, bo)];
    mPos += [pages bounds].size.width + bm;
    [self addSubview:pages];
}

- (void) setupHelp:(NSArray*)array
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
    
    float arrowOff = 0.65;

    [ss begin:s];
    [ss takeScreenShot:ribbonFrame];
    
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    NSPoint point = NSMakePoint([fontNamePopup frame].origin.x + [fontNamePopup frame].size.width*0.5, [fontNamePopup frame].origin.y + [fontNamePopup frame].size.height*arrowOff);
    [ss addArrow:[NSString stringWithFormat:@"%d",numberCount++] atPosition:point];

    point = NSMakePoint([fontSizePopup frame].origin.x + [fontSizePopup frame].size.width*0.5, [fontSizePopup frame].origin.y + [fontSizePopup frame].size.height*arrowOff);
    [ss addArrow:[NSString stringWithFormat:@"%d",numberCount++] atPosition:point];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    point = NSMakePoint([volumeSlider frame].origin.x + [volumeSlider frame].size.width*0.25, [volumeSlider frame].origin.y + [volumeSlider frame].size.height*arrowOff);
    [ss addArrow:[NSString stringWithFormat:@"%d",numberCount++] atPosition:point];

    point = NSMakePoint([speedSlider frame].origin.x + [speedSlider frame].size.width*0.75, [speedSlider frame].origin.y + [speedSlider frame].size.height*arrowOff);
    [ss addArrow:[NSString stringWithFormat:@"%d",numberCount++] atPosition:point];

    point = NSMakePoint([pages frame].origin.x + [pages frame].size.width*0.5, [pages frame].origin.y + [pages frame].size.height*arrowOff);
    [ss addArrow:[NSString stringWithFormat:@"%d",numberCount++] atPosition:point];
    
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];
    [self buttonHelp:numberCount++ index:buttonCount++ ScreenShot:ss];

    [ss saveToFile:@"/Users/erik/Desktop/OCR.png"];
}

-(void)buttonHelp:(int)number index:(int)index ScreenShot:(ScreenShot*)ss
{
    float arrowOff = 0.75;
    NSPoint point = NSMakePoint([mButtons[index] frame].origin.x + [mButtons[index] frame].size.width*0.5, [mButtons[index] frame].origin.y + [mButtons[index] frame].size.height*arrowOff);
    [ss addArrow:[NSString stringWithFormat:@"%d",number] atPosition:point];
}

#endif

@end
