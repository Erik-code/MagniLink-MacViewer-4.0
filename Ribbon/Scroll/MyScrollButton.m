//
//  MyScrollButton.m
//  MagniLink
//
//  Created by Erik Sandström on 2019-10-01.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import "MyScrollButton.h"

@implementation MyScrollButton

@synthesize delegate;

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setup{
    [self setWantsLayer:YES];
    
    self.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [NSColor grayColor].CGColor;
    self.layer.cornerRadius = 3.0;
    
    [[self window] setAcceptsMouseMovedEvents:YES];
    
    NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect |
                                     NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
    
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                        options:options
                                                          owner:self
                                                       userInfo:nil];
    [self addTrackingArea:area];
    
    [self.layer setNeedsDisplay];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void) mouseEntered:(NSEvent *)event
{
    self.layer.backgroundColor = [NSColor grayColor].CGColor;
}

-(void) mouseExited:(NSEvent *)event
{
    self.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
}

-(void) mouseDown:(NSEvent *)event
{
    //[self.target performSelector:self.action withObject:self];
    [delegate buttonPressed:self];
}

-(void) mouseUp:(NSEvent *)event
{
    [delegate buttonReleased:self];
}

@end
