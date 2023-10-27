//
//  CheckBoxView.m
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-21.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import "MyCheckBoxView.h"
#import "MySizes.h"
#import <QuartzCore/QuartzCore.h>

@interface MyCheckBoxView()
{
    CALayer *layer;
    CALayer *knobLayer;
    CALayer *trackLayer;
    bool mToggled;
    
    float width;
    float height;
    float radius;
    float trackWidth; //Track Width
    float trackHeight; //Track height
    float trackRadius;
    float trackPosY;
}
@end

@implementation MyCheckBoxView
@synthesize delegate;

- (instancetype)initWithString:(NSString*)caption
{
    self = [super init];
    if (self) {
        
        [self setWantsLayer:YES];
        
        self.title = caption;
        mToggled = YES;
        height = [MySizes buttonHeight];
        width = [MySizes measureText:caption].width + [MySizes buttonInteralMargin];
        radius = [MySizes knobSize];
        trackWidth = [MySizes trackWidth]; //Track Width
        trackHeight = [MySizes trackHeight]; //Track height
        trackRadius = [MySizes trackHeight] / 2;
        trackPosY = height * 0.6;
        
        [self setFrameSize:NSMakeSize(width, height)];
        
//        layer = [[MyCheckBoxLayer alloc] initWithCaption:caption];;
        layer = self.layer;
        
        layer.backgroundColor = [[NSColor whiteColor] CGColor];
        layer.borderColor = [[NSColor whiteColor] CGColor];
        layer.borderWidth = 1.0;
        CGRect b = [self bounds];
        layer.bounds = b;
        layer.contentsScale = 2;

        //CGRect rect = CGRectMake((width-radius)*0.5, (height-radius)*0.5 , radius, radius);
        CGRect rect = CGRectMake((width + trackWidth)*0.5 -radius, trackPosY - radius * 0.5 , radius, radius);
  
        knobLayer = [CALayer layer];
//        knobLayer.bounds = rect;
        knobLayer.frame = rect;
        
        knobLayer.cornerRadius = radius*0.5;
        knobLayer.borderColor = [[NSColor grayColor] CGColor];
        knobLayer.backgroundColor = [[NSColor whiteColor] CGColor];
        knobLayer.borderWidth = radius * 0.01;
        knobLayer.shadowOpacity = 1.0;
        knobLayer.shadowRadius = radius * 0.01;
        
        trackLayer = [CALayer layer];
        CGRect rect_t = CGRectMake((width-trackWidth)*0.5, trackPosY - trackHeight * 0.5, trackWidth, trackHeight);
        trackLayer.bounds = rect_t;
        trackLayer.frame = rect_t;
        trackLayer.cornerRadius = trackRadius;
        trackLayer.borderColor = [[NSColor grayColor] CGColor];
        trackLayer.backgroundColor = [NSColor systemOrangeColor].CGColor;
        trackLayer.borderWidth = radius * 0.01;
        trackLayer.shadowOpacity = 1.0;
        trackLayer.shadowRadius = radius * 0.01;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSAttributedString *string= [[NSAttributedString alloc] initWithString:caption
                                                                    attributes:[NSDictionary
                                                                                dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:[MySizes fontSize]],
                                                                                NSFontAttributeName,
                                                                                paragraphStyle, NSParagraphStyleAttributeName,
                                                                                [NSColor blackColor],NSForegroundColorAttributeName
                                                                                ,nil]];
        
        
        [layer addSublayer:trackLayer];
        [layer addSublayer:knobLayer];
        
        self.layer = layer;
        
        
        
        [layer setNeedsDisplay];
        [trackLayer setNeedsDisplay];
        [knobLayer setNeedsDisplay];
        
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

- (void) resize
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];
    
    height = [MySizes buttonHeight];
    width = [MySizes measureText:self.title].width + [MySizes buttonInteralMargin];
    radius = [MySizes knobSize];
    trackWidth = [MySizes trackWidth]; //Track Width
    trackHeight = [MySizes trackHeight]; //Track height
    trackRadius = [MySizes trackHeight] / 2;
    trackPosY = height * 0.6;
    
    [self setFrameSize:NSMakeSize(width, height)];
    
    CGRect rect = CGRectMake((width + trackWidth)*0.5 -radius, trackPosY - radius * 0.5 , radius, radius);
      
    knobLayer.frame = rect;
    knobLayer.cornerRadius = radius*0.5;
    knobLayer.borderWidth = radius * 0.01;
    knobLayer.shadowOpacity = 0.7;
    knobLayer.shadowRadius = radius * 0.1;
    knobLayer.shadowOffset = NSMakeSize(radius * 0.1, -radius * 0.1);
    
    CGRect rect_t = CGRectMake((width-trackWidth)*0.5, trackPosY - trackHeight * 0.5, trackWidth, trackHeight);
    trackLayer.bounds = rect_t;
    trackLayer.frame = rect_t;
    trackLayer.cornerRadius = trackRadius;
    trackLayer.borderWidth = radius * 0.00;
    trackLayer.shadowOpacity = 0.0;
    trackLayer.shadowRadius = 0.0;
    trackLayer.shadowOffset = NSMakeSize(radius * 0.0, -radius * 0.0);

    
    [layer setNeedsDisplay];
    [trackLayer setNeedsDisplay];
    [knobLayer setNeedsDisplay];
    
    [CATransaction commit];
}

- (void)drawRect:(NSRect)dirtyRect {
    //[super drawRect:dirtyRect];
    
    CGRect rect = [self bounds];

    CGSize imageSize = CGSizeMake([MySizes buttonImageSize],[MySizes buttonImageSize]);
    CGRect imageRect;
    imageRect.size = imageSize;

    NSDictionary *attr = [MySizes fontAttributes];

    CGRect textRect = rect;
    textRect.size.height = [MySizes fontSize] * 1.4;
    textRect.origin.y = (rect.size.height - imageRect.size.height) * 0.5 - [MySizes imageTextMargin];
    
    [[self title] drawInRect:textRect withAttributes:attr];
    
    // Drawing code here.
}

-(BOOL) acceptsFirstMouse:(NSEvent *)event
{
    return YES;
}

-(BOOL) acceptsFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    //layer.borderColor = [[NSColor blueColor] CGColor];
    return YES;
}

-(BOOL)resignFirstResponder
{
    //layer.borderColor = [[NSColor whiteColor] CGColor];
    return YES;
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


-(BOOL) isFlipped
{
    return NO;
}

- (void) toggle:(BOOL)value
{
    mToggled = value;
    if(mToggled){
        CGRect rect = CGRectMake((width + trackWidth)*0.5 - radius, trackPosY - radius*0.5 , radius, radius);
        knobLayer.bounds = rect;
        knobLayer.frame = rect;
        trackLayer.backgroundColor = [NSColor systemOrangeColor].CGColor;

    }
    else{
        CGRect rect = CGRectMake((width - trackWidth)*0.5, trackPosY - radius*0.5 , radius, radius);
        knobLayer.bounds = rect;
        knobLayer.frame = rect;
        trackLayer.backgroundColor = [[NSColor lightGrayColor] CGColor];;
    }
}

- (void) keyDown:(NSEvent *)event
{
    NSLog(@"KeyDown %d",[event keyCode]);
    if([event keyCode] == 0x31)
    {
        mToggled = !mToggled;
        [self toggle:mToggled];
        [delegate handleCheckBoxClicked];
    }
    else{
        [super keyDown:event];
    }
}


- (void)mouseEntered:(NSEvent *)theEvent
{
    layer.backgroundColor = [[MySizes hooverColor] CGColor];
}

- (void)mouseExited:(NSEvent *)theEvent {
    layer.backgroundColor = [[NSColor whiteColor] CGColor];
}
/*
height = [MySizes buttonHeight];
width = [MySizes measureText:caption].width;
radius = [MySizes knobSize];
trackWidth = [MySizes trackWidth]; //Track Width
trackHeight = [MySizes trackHeight]; //Track height
trackRadius = [MySizes trackHeight] / 2;
*/
-(void) mouseDown:(NSEvent *)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    //NSLog(@"Location %f %f",location.x,location.y);
    mToggled = !mToggled;
    [self toggle:mToggled];
    [delegate handleCheckBoxClicked];
}

-(void) mouseUp:(NSEvent *)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    //NSLog(@"Location %f %f",location.x,location.y);
}

@end
