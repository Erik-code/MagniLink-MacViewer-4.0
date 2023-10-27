//
//  MyButtonView.m
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-21.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import "MyButtonView.h"
#import "MySizes.h"

@interface MyButtonView()
{
    NSImage* image;
    ToggleOption isToggleButton;
    BOOL isToggled;
    CALayer *layer;
    int button;
}
@end

@implementation MyButtonView
@synthesize delegate;

- (instancetype)initWithFilename:(NSString*)filename andCaption:(NSString*)caption andButton:(int)aButton;
{
    self = [super init];
    if (self) {
        button = aButton;
        image = [NSImage imageNamed:filename];
        isToggleButton = NO;
        isToggled = NO;
        self.title = caption;
        
        [self resize];
        
        [self setWantsLayer:YES];
        layer = self.layer;
//        layer = [[MyButtonLayer alloc] initWithFilename:filename andCaption:caption];
//        layer.backgroundColor = [[NSColor whiteColor] CGColor];
        layer.bounds = [self bounds];
        layer.cornerRadius = 0.0;
        layer.borderColor = [[NSColor whiteColor] CGColor];
        layer.borderWidth = 1.0;
        //layer.shadowOpacity = 1.0;
        layer.shadowRadius = 0.0;
//        layer.shadowColor = [[NSColor whiteColor] CGColor];
        layer.contentsScale = 2;
        layer.opacity = 1.0f;

        [self setWantsLayer:YES];

        self.layer = layer;
                
        [[self window] setAcceptsMouseMovedEvents:YES];
        
        NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect |
                                         NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
        
        NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                            options:options
                                                              owner:self
                                                           userInfo:nil];
        [self addTrackingArea:area];
                
        [layer setNeedsDisplay];

    }
    return self;
}

- (void) resize
{
    float w = [MySizes buttonWidth];
    float h = [MySizes buttonHeight];

    float textWidth = [MySizes measureText:self.title].width;

    w = MAX(w, textWidth)+[MySizes buttonInteralMargin];
    
    [self setFrameSize:NSMakeSize(w, h)];
}

- (void) setToggleButton:(ToggleOption)value
{
    isToggleButton = value;
}

- (void) toggle:(BOOL)value
{
    isToggled = value;
    if(isToggleButton == kImage){
        //[layer setToggle:value];
    }
    else{
        if(isToggled){
            layer.backgroundColor = [[MySizes mainColor] CGColor];

        }
        else{
            layer.backgroundColor = [[NSColor whiteColor] CGColor];
        }
    }
}

-(BOOL) isFlipped
{
    return NO;
}

- (bool) isToggled
{
    return isToggled;
}

- (void) setAlternativeFilename:(NSString*)filename andCaption:(NSString*)caption
{
    [self setToggleButton:kImage];
}

- (void)drawRect:(NSRect)dirtyRect {
    //[super drawRect:dirtyRect];
    
    float margin = [MySizes imageMargin];
    CGRect rect = [self bounds];
    
    NSSize imageSize = CGSizeMake([MySizes buttonImageSize],[MySizes buttonImageSize]);
    NSRect imageRect = NSMakeRect(0, 0, imageSize.width, imageSize.height);
    
    imageRect.origin.x += (rect.size.width - imageSize.width) * 0.5;
    imageRect.origin.y = rect.size.height - imageRect.size.height - margin;
    
    [image drawInRect:imageRect];
    
    NSDictionary *attr = [MySizes fontAttributes];
    NSRect textRect = [self bounds];
    textRect.size.height = [MySizes fontSize] * 1.4;
    textRect.origin.y = ([self bounds].size.height - imageRect.size.height) * 0.5 - [MySizes imageTextMargin];
    
    [[self title] drawInRect:textRect withAttributes:attr];
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
    [delegate handleButtonBecomesFirstResponder:self];
    
    return YES;
}

-(BOOL)resignFirstResponder
{
    layer.borderColor = [[NSColor whiteColor] CGColor];
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

- (void) keyDown:(NSEvent *)event
{
    NSLog(@"KeyDown %d",[event keyCode]);
    if([event keyCode] == 0x31)
    {
        NSUInteger modifierFlags = [event modifierFlags];
//        BOOL altIsPressed = (modifierFlags & NSAlternateKeyMask) != 0;
        [delegate handleClicked:button withModifier:modifierFlags];
        [delegate handlePress:button];
    }
    else{
        [super keyDown:event];
    }
}

-(void) keyUp:(NSEvent *)event
{
    if([event keyCode] == 0x31)
    {
        [delegate handleRelease:button];
    }
    else{
        [super keyUp:event];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent
{
//    layer.backgroundColor = [[NSColor colorWithRed:0.5 green:0.5 blue:1 alpha:1] CGColor];
    layer.backgroundColor = [[MySizes hooverColor] CGColor];
}

- (void)mouseExited:(NSEvent *)theEvent {
    if(isToggled && isToggleButton == kToggle){
        layer.backgroundColor = [[MySizes toggleColor] CGColor];
    }
    else{
        layer.backgroundColor = [[NSColor whiteColor] CGColor];
    }
}

-(void) mouseDown:(NSEvent *)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    [delegate handlePress:button];
    
    //NSLog(@"Location %f %f",location.x,location.y);
}

-(void) mouseUp:(NSEvent *)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    //NSLog(@"Location %f %f",location.x,location.y);
    if(NSPointInRect(location, [self bounds]))
    {
        if(isToggleButton != kNoToggle){
            isToggled = !isToggled;
            [self toggle:isToggled];
        }
        NSUInteger modifierFlags = [event modifierFlags];
//        BOOL shiftIsPressed = (modifierFlags & NSShiftKeyMask) != 0;
        [delegate handleClicked:button withModifier:modifierFlags];
    }
    [delegate handleRelease:button];
}

@end
