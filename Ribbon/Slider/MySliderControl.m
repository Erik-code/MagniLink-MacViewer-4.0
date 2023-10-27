//
//  MySliderControl.m
//  MagniLink
//
//  Created by Erik Sandström on 2019-09-30.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import "MySliderControl.h"
#import "MySizes.h"
#import <Quartz/Quartz.h>

@interface MySliderControl()
{
    CALayer *knobLayer;
    CALayer *trackLayerLeft;
    CALayer *trackLayerRight;
    CALayer *layer;
    
    float mFloatValue;
    float mMinValue;
    float mMaxValue;
    bool mousePressed;
}
@end

@implementation MySliderControl

-(id) initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(self){
        [self setup];
    }
    return self;
}

-(id) init
{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setup
{
    mousePressed = false;
    [self setWantsLayer:YES];
    layer = [self layer];
    
    layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    [self setAccessibilityElement:YES];
    
    knobLayer = [CALayer layer];
    
    trackLayerLeft = [CALayer layer];
    trackLayerRight = [CALayer layer];

    [layer addSublayer:trackLayerRight];
    [layer addSublayer:trackLayerLeft];
    [layer addSublayer:knobLayer];
    
    mMinValue = 0;
    mMaxValue = 10;
    mFloatValue = 5;
    [self resize];
    
    [layer setNeedsDisplay];
    [trackLayerLeft setNeedsDisplay];
    [trackLayerRight setNeedsDisplay];

    [knobLayer setNeedsDisplay];
    
    NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect |
                                     NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
    
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                        options:options
                                                          owner:self
                                                       userInfo:nil];
    [self addTrackingArea:area];
    
}

- (void)drawRect:(NSRect)dirtyRect {
    //[super drawRect:dirtyRect];
}

-(BOOL) isFlipped
{
    return NO;
}

-(BOOL) needsPanelToBecomeKey
{
    return YES;
}

- (NSRect)focusRingMaskBounds
{
    NSRect b = [self bounds];
    b = NSInsetRect(b, 1, 1);
    return b;
}

-(void) drawFocusRingMask
{
    float radius = [MySizes knobSize];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path appendBezierPathWithRoundedRect:[knobLayer frame] xRadius:radius yRadius:radius];

    [path fill];
}

-(BOOL) acceptsFirstResponder{
    return YES;
}

-(void) setKnob:(float)xPos
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];
    
    if(xPos < trackLayerRight.frame.origin.x){
        xPos = trackLayerRight.frame.origin.x;
    }
    else if(xPos > trackLayerRight.frame.origin.x + trackLayerRight.frame.size.width){
        xPos = trackLayerRight.frame.origin.x + trackLayerRight.frame.size.width;
    }
    
    NSRect frame = trackLayerLeft.frame;
    trackLayerLeft.frame = NSMakeRect(trackLayerRight.frame.origin.x, frame.origin.y, xPos - trackLayerRight.frame.origin.x, frame.size.height);
    
    float width = [self bounds].size.width;
    float radius = [MySizes knobSize];
    float trackWidth = width - radius * 1.1;
        
    knobLayer.position = NSMakePoint(xPos, knobLayer.position.y);
    
    [CATransaction commit];
        
    id target = [self target];
    if(target != nil){
        [target performSelector:[self action] withObject:self];
    }
    
    [self noteFocusRingMaskChanged];
}

- (void) resize
{
    float height = [self bounds].size.height;
    float width = [self bounds].size.width;
    
    float radius = [MySizes knobSize];
    float trackWidth = width - radius * 1.1;
    float trackHeight = [MySizes trackHeight];
    float trackRadius = [MySizes trackHeight] / 2;
    float trackPosY = (height - trackHeight) * 0.5;
    
    float percent = (mFloatValue - mMinValue) / (mMaxValue - mMinValue);
    
    CGRect rect = CGRectMake(radius*0.55 + trackWidth * percent, (height - radius) * 0.5, radius, radius);
    
    knobLayer.frame = rect;
    
    knobLayer.cornerRadius = radius * 0.5;
    knobLayer.borderColor = [[NSColor grayColor] CGColor];
    knobLayer.backgroundColor = [[NSColor whiteColor] CGColor];
    knobLayer.borderWidth = radius * 0.01;
    knobLayer.shadowOpacity = 0.7;
    knobLayer.shadowRadius = radius * 0.1;
    knobLayer.shadowOffset = NSMakeSize(radius * 0.1, -radius * 0.1);
    
    CGRect rect_t = CGRectMake(radius*0.55, trackPosY, trackWidth * percent, trackHeight);
    
    trackLayerLeft.bounds = rect_t;
    trackLayerLeft.frame = rect_t;
    trackLayerLeft.cornerRadius = trackRadius;
    trackLayerLeft.borderColor = [[NSColor grayColor] CGColor];
    trackLayerLeft.backgroundColor = [[NSColor systemOrangeColor] CGColor];
    trackLayerLeft.borderWidth = 0.0;
    trackLayerLeft.shadowOpacity = 0.0;
    trackLayerLeft.shadowRadius = 0.0;
    trackLayerLeft.shadowOpacity = 0.0;

    rect_t = CGRectMake(radius*0.55, trackPosY, trackWidth, trackHeight);
    
    trackLayerRight.bounds = rect_t;
    trackLayerRight.frame = rect_t;
    trackLayerRight.cornerRadius = trackRadius;
    trackLayerRight.borderColor = [[NSColor grayColor] CGColor];
    trackLayerRight.backgroundColor = [[NSColor lightGrayColor] CGColor];
    trackLayerRight.borderWidth = 0.0;
    trackLayerRight.shadowOpacity = 0.0;
    trackLayerRight.shadowRadius = 0.0;
    trackLayerRight.shadowOpacity = 0.0;

    [layer setNeedsDisplay];
    [trackLayerLeft setNeedsDisplay];
    [trackLayerRight setNeedsDisplay];
    [knobLayer setNeedsDisplay];
    [self setFloatValue:mFloatValue];
}

-(void) setMaxValue:(double)value
{
    mMaxValue = value;
    if(mFloatValue > mMaxValue)
        mFloatValue = mMaxValue;
}

-(double) maxValue
{
    return mMaxValue;
}

-(void) setMinValue:(double)value
{
    mMinValue = value;
    if(mFloatValue > mMinValue)
        mFloatValue = mMinValue;
}

-(double) minValue
{
    return mMinValue;
}

-(float) floatValue
{
    return mFloatValue;
}

-(void) setFloatValue:(float)floatValue
{
    mFloatValue = floatValue;
    float percent = (floatValue - mMinValue) / (mMaxValue - mMinValue);
    
    float xpos = trackLayerRight.frame.origin.x + trackLayerRight.frame.size.width * percent;
        
    [self setAccessibilityValue:[NSNumber numberWithFloat:roundf(mFloatValue)]];
    
    [self setKnob:xpos];
}

-(void) mouseEntered:(NSEvent *)event
{
    
}

-(void) mouseExited:(NSEvent *)event
{
    
}

-(void) mouseDown:(NSEvent *)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    NSLog(@"Location %f %f",location.x,location.y);
    [self setKnob:location.x];
    [self actionHelp];
}

-(void) mouseUp:(NSEvent *)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    NSLog(@"Location %f %f",location.x,location.y);
}

-(void) mouseMoved:(NSEvent *)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    NSLog(@"Location %f %f",location.x,location.y);
}

-(void) mouseDragged:(NSEvent *)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    NSLog(@"Dragged %f %f",location.x,location.y);
    [self setKnob:location.x];
    [self actionHelp];
}

-(void) actionHelp
{
    float percent = (knobLayer.position.x - trackLayerRight.frame.origin.x) / trackLayerRight.frame.size.width;
    mFloatValue = mMinValue + percent * ( mMaxValue - mMinValue);
    id target = [self target];
    [self setAccessibilityValue:[NSNumber numberWithFloat:roundf(mFloatValue)]];
    if(target != nil){
        [target performSelector:[self action] withObject:self];
    }
}


@end
