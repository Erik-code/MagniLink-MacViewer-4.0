//
//  MyButtonBarView.m
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-21.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import "MyButtonView.h"
#import "MyButtonBarView.h"
#import "MyCheckBoxView.h"
#import "MySizes.h"

@interface MyButtonBarView()
{
//    @protected MyButtonBarLayer *layer;
}
@end

@implementation MyButtonBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //[self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //[self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setup];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
        
    if(mDrawArray == nil){
        return;
    }
    
    float height = [self bounds].size.height;
    int oldpos = 0;
    CGContextRef ctx = [NSGraphicsContext currentContext].CGContext;

    CGContextSetFillColorWithColor(ctx,[NSColor whiteColor].CGColor);
    CGContextAddRect(ctx, dirtyRect);
    CGContextFillPath(ctx);
    for(int i = 0 ; i < [mDrawArray count] ; i+=2)
    {
        int pos = [[mDrawArray objectAtIndex:i] intValue];
        NSString* caption = [mDrawArray objectAtIndex:i + 1];
        
        
        if(i != [mDrawArray count] - 1){
            CGContextSetStrokeColorWithColor(ctx, [NSColor blackColor].CGColor);
            CGContextSetLineWidth(ctx, 0.4f);
            CGContextMoveToPoint(ctx, pos, [MySizes separatorVerticalMargin]);
            CGContextAddLineToPoint(ctx, pos, height - [MySizes separatorVerticalMargin]);
            CGContextStrokePath(ctx);
        }
        
        CGRect rect = CGRectMake(oldpos, [MySizes fontSize]*0.2 , pos - oldpos, [MySizes fontSize]*1.4);
        
        NSDictionary *attr = [MySizes fontAttributes];

        NSGraphicsContext *nsgc = [NSGraphicsContext graphicsContextWithCGContext:ctx flipped:NO];
        
        [NSGraphicsContext setCurrentContext:nsgc];
        
        CGContextSetTextDrawingMode(ctx, kCGTextFill);
        
        [caption drawInRect:rect withAttributes:attr];
        
        oldpos = pos;
    }
    
    // Drawing code here.
}

@end
