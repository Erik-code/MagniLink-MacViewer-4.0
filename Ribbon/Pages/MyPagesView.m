//
//  MyPagesView.m
//  MagniLink
//
//  Created by Erik Sandström on 2019-08-29.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import "MyPagesView.h"
#import "MySizes.h"
#import "Localization.h"

@interface MyPagesButton()
{
    CALayer* pageLayer;
    NSImage* mImage;
}
@end

@implementation MyPagesButton : NSButton

-(id) initWithFrame:(NSRect)frameRect andImage:(NSString*)image
{
    self = [super initWithFrame:frameRect];
    if(self){
        [self setWantsLayer:YES];
        
        pageLayer = [self createLayerHelp];
        mImage = [NSImage imageNamed:image];
        
        [[self window] setAcceptsMouseMovedEvents:YES];
        
        NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect |
                                         NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
        
        NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                            options:options
                                                              owner:self
                                                           userInfo:nil];
        [self addTrackingArea:area];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    float m = 0.1;
    NSRect r = [self bounds];
    NSRect rect = NSMakeRect(r.size.width * m, r.size.height * m, r.size.width * (1-2*m), r.size.height * ( 1 - 2 * m));
    [mImage drawInRect:rect];
}

-(void) drawFocusRingMask
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path appendBezierPathWithRoundedRect:[self bounds] xRadius:1.5 yRadius:1.5];
    [path fill];
}

-(BOOL) needsPanelToBecomeKey
{
    return YES;
}

-(CALayer*) createLayerHelp
{
    CALayer* result = self.layer;
    result.cornerRadius = 0;
    result.borderColor = [[NSColor grayColor] CGColor];
    result.backgroundColor = [[NSColor whiteColor] CGColor];
    result.borderWidth = 1.0;
    result.shadowOpacity = 0.0;
    result.opacity = 1.0f;
    return result;
}

-(BOOL) acceptsFirstMouse:(NSEvent *)event
{
    return YES;
}

-(BOOL) acceptsFirstResponder
{
    return YES;
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    pageLayer.backgroundColor = [[MySizes hooverColor] CGColor];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    pageLayer.backgroundColor = [[NSColor whiteColor] CGColor];
}

@end

@interface MyPagesView()
{
    MyPagesButton *prevButton;
    MyPagesButton *nextButton;

    MyPagesButton *backButton;
    MyPagesButton *forwardButton;
    
    int mNumber;
    int mCount;
}
@end

@implementation MyPagesView

@synthesize delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [NSEvent addLocalMonitorForEventsMatchingMask:(NSEventMaskMouseMoved) handler:^NSEvent *(NSEvent *event)
         {
             [self mouseMoved:event];
             return event;
         }];
        
        float height = [MySizes buttonHeight];
        float pageHeight = height * (1 - [MySizes pageMargin] * 2);
        
        float pageWidth = pageHeight / [MySizes pageFormat];
        
        float pageMargin = height * [MySizes pageMargin];

        float buttonSize = height * (1 - [MySizes pageMargin]*3) * 0.5;
        
        float width = pageMargin * 4 + pageWidth + buttonSize * 2;

        [self setFrameSize:NSMakeSize(width, height)];
        
        [self setWantsLayer:YES];
        
        CGRect rect_t = CGRectMake((width-pageWidth)*0.5, pageMargin, pageWidth, pageHeight);
                
        rect_t = CGRectMake(pageMargin, pageMargin, buttonSize, buttonSize);
        backButton = [[MyPagesButton alloc] initWithFrame:rect_t andImage:@"back"];
        [backButton setTarget:self];
        [backButton setAction:@selector(buttonPressed:)];
        [backButton setAccessibilityLabel:@"Move5Back".localized];
        [self addSubview:backButton];
        
        rect_t = CGRectMake(pageMargin, buttonSize + pageMargin * 2, buttonSize, buttonSize);
        prevButton = [[MyPagesButton alloc] initWithFrame:rect_t andImage:@"previous"];
        [self addSubview:prevButton];
        [prevButton setTarget:self];
        [prevButton setAction:@selector(buttonPressed:)];
        [prevButton setAccessibilityLabel:@"MoveBack".localized];
        [self addSubview:prevButton];

        rect_t = CGRectMake((width-pageWidth)*0.5 + pageWidth + pageMargin, pageMargin, buttonSize, buttonSize);
        forwardButton = [[MyPagesButton alloc] initWithFrame:rect_t andImage:@"forward"];
        [self addSubview:forwardButton];
        [forwardButton setTarget:self];
        [forwardButton setAction:@selector(buttonPressed:)];
        [forwardButton setAccessibilityLabel:@"Move5Forward".localized];
        [self addSubview:forwardButton];

        rect_t = CGRectMake((width-pageWidth)*0.5 + pageWidth + pageMargin, buttonSize + pageMargin * 2, buttonSize, buttonSize);
        nextButton = [[MyPagesButton alloc] initWithFrame:rect_t andImage:@"next"];
        [self addSubview:nextButton];
        [nextButton setTarget:self];
        [nextButton setAction:@selector(buttonPressed:)];
        [nextButton setAccessibilityLabel:@"MoveForward".localized];
        [self addSubview:nextButton];
        
        [self setPageNumber:0 andCount:0];
    }
    return self;
}

-(void) resize
{
    float height = [MySizes buttonHeight];
    float pageHeight = height * (1 - [MySizes pageMargin] * 2);
    
    float pageWidth = pageHeight / [MySizes pageFormat];
    
    float pageMargin = height * [MySizes pageMargin];

    float buttonSize = height * (1 - [MySizes pageMargin]*3) * 0.5;
    
    float width = pageMargin * 4 + pageWidth + buttonSize * 2;

    [self setFrameSize:NSMakeSize(width, height)];
    
    CGRect rect_t = CGRectMake((width-pageWidth)*0.5, pageMargin, pageWidth, pageHeight);

    rect_t = CGRectMake(pageMargin, pageMargin, buttonSize, buttonSize);
    backButton.frame = rect_t;

    rect_t = CGRectMake(pageMargin, buttonSize + pageMargin * 2, buttonSize, buttonSize);
    prevButton.frame = rect_t;

    rect_t = CGRectMake((width-pageWidth)*0.5 + pageWidth + pageMargin, pageMargin, buttonSize, buttonSize);
    forwardButton.frame = rect_t;

    rect_t = CGRectMake((width-pageWidth)*0.5 + pageWidth + pageMargin, buttonSize + pageMargin * 2, buttonSize, buttonSize);
    nextButton.frame = rect_t;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
    
    NSRect r = [self bounds];
    NSRect insetRect = NSInsetRect(r, r.size.height * 0.02, r.size.height * 0.02);
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path setLineWidth:r.size.height * 0.01];
    [[NSColor blackColor] set];
    [path appendBezierPathWithRect:insetRect];
    [path stroke];
    
    if(mCount != 0)
    {
        NSDictionary *attr = [MySizes fontAttributes];
        
        NSString* top = [NSString stringWithFormat:@"%d",mNumber+1 ];
        NSString* bottom = [NSString stringWithFormat:@"%d",mCount ];

        float height = [MySizes buttonHeight];
        float pageHeight = height * (1 - [MySizes pageMargin] * 2);
        float pageWidth = pageHeight / [MySizes pageFormat];
        
        float pageMargin = height * [MySizes pageMargin];
        float buttonSize = height * (1 - [MySizes pageMargin]*3) * 0.5;
        float width = pageMargin * 4 + pageWidth + buttonSize * 2;
        r = CGRectMake((width-pageWidth)*0.5, pageMargin, pageWidth, pageHeight);

        NSRect topRect = NSMakeRect(r.origin.x, r.origin.y + r.size.height * 0.5, r.size.width*0.5, r.size.height*0.5);
          
        NSRect bottomRect = NSMakeRect(r.origin.x + r.size.width*0.5, r.origin.y, r.size.width*0.5, r.size.height*0.5);

        [top drawInRect:topRect withAttributes:attr];
        [bottom drawInRect:bottomRect withAttributes:attr];

        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:r.size.height * 0.01];
        [path appendBezierPathWithRect:r];
        [path stroke];
        
        path = [NSBezierPath bezierPath];
        [path setLineWidth:r.size.height * 0.01];
        [path moveToPoint:r.origin];
        [path lineToPoint:NSMakePoint(r.origin.x + r.size.width, r.origin.y + r.size.height)];
        [path stroke];
    }
}

-(void) setPageNumber:(int)number andCount:(int)count
{
    mNumber = number;
    mCount = count;
    
    [self setNeedsDisplay:YES];
}
     
-(void)buttonPressed:(MyPagesButton*)button
{
    if(button == prevButton){
        [delegate handlePages:-1];
    }
    else if(button == nextButton){
        [delegate handlePages:1];
    }
    else if(button == backButton){
        [delegate handlePages:-5];
    }
    else if(button == forwardButton){
        [delegate handlePages:5];
    }
}

-(NSArray*) getButtons
{
    return [NSArray arrayWithObjects:prevButton,nextButton,backButton,forwardButton, nil];
}

@end
