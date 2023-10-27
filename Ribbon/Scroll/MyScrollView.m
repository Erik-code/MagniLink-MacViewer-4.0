//
//  MyScrollView.m
//  MagniLink
//
//  Created by Erik Sandström on 2019-10-01.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import "MyScrollView.h"
#import "MyScrollButton.h"

#define BUTTON_RATIO 0.2

@interface MyScrollView()
{
    NSView* mClipView;
    NSView* mDocumentView;
    MyScrollButton* mLeftButton;
    MyScrollButton* mRightButton;
    float mXPos;
    float mButtonWidth;
    
    NSTimer* mButtonTimer;
}
@end

@implementation MyScrollView

-(id) initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if(self){
        [self setup];
    }
    return self;
}

-(void) setup
{
    mButtonWidth = [self bounds].size.height * BUTTON_RATIO;
    mButtonTimer = nil;
    
    NSRect lr = NSMakeRect(0, 0, mButtonWidth, [self bounds].size.height);
    mLeftButton = [[MyScrollButton alloc] initWithFrame:lr];
    [mLeftButton setAutoresizingMask:NSViewMaxXMargin];
    [mLeftButton setDelegate:self];
    [mLeftButton setTitle:@"<"];
    [self addSubview:mLeftButton];
    
    NSRect rr = NSMakeRect([self bounds].size.width - mButtonWidth, 0, mButtonWidth, [self bounds].size.height);
    mRightButton = [[MyScrollButton alloc] initWithFrame:rr];
    [mRightButton setAutoresizingMask:NSViewMinXMargin];
    [mRightButton setDelegate:self];
    [mRightButton setTitle:@">"];
    [self addSubview:mRightButton];

    NSRect r = NSMakeRect(mButtonWidth, 0, [self bounds].size.width - mButtonWidth*2, [self bounds].size.height);
    mClipView = [[NSView alloc] initWithFrame:r];
    [mClipView setAutoresizingMask:NSViewWidthSizable];
    [self addSubview:mClipView];
    
    mXPos = 0;
}

-(void) setFrameSize:(NSSize)newSize
{
    [super setFrameSize:newSize];
    mButtonWidth = [self bounds].size.height * BUTTON_RATIO;
    
    NSRect lr = NSMakeRect(0, 0, mButtonWidth, [self bounds].size.height);
    [mLeftButton setFrame:lr];
    
    NSRect rr = NSMakeRect([self bounds].size.width - mButtonWidth, 0, mButtonWidth, [self bounds].size.height);
    [mRightButton setFrame:rr];
    [self setAll];
}

-(void) buttonPressed:(NSControl*)sender
{
    if(sender == mLeftButton){
        mXPos += 20;
        mButtonTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(leftPressed:) userInfo:nil repeats:YES];
    }
    else if(sender == mRightButton)
    {
        mXPos -= 20;
        mButtonTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rightPressed:) userInfo:nil repeats:YES];
    }
    [self setAll];
}

-(void) buttonReleased:(NSControl*)sender
{
    [mButtonTimer invalidate];
    mButtonTimer = nil;
}

-(void) leftPressed:(id)sender
{
    mXPos += 10;
    [self setAll];
}

-(void) rightPressed:(id)sender
{
    mXPos -= 10;
    [self setAll];
}

-(void) setDocumentView:(NSView*)view
{
    mDocumentView = view;
    [mClipView addSubview:view];
    mXPos = 0;
    [self setAll];
}

-(void) hideLeftButton
{
    if([mLeftButton isHidden] == NO){
        [mLeftButton setHidden:YES];
        if(mButtonTimer != nil){
            [mButtonTimer invalidate];
        }
    }
}

-(void) hideRightButton
{
    if([mRightButton isHidden] == NO){
        [mRightButton setHidden:YES];
        if(mButtonTimer != nil){
            [mButtonTimer invalidate];
        }
    }
}

-(void) setAll
{
    float width = [self bounds].size.width;
    float xpos1 = mXPos;
    float xpos2 = mXPos + [mDocumentView frame].size.width;
    
    bool leftHidden = xpos1 >= 0;
    bool rightHidden = xpos2 <= width;
    bool bothHidden = [mDocumentView frame].size.width < width;
    
    if((leftHidden && rightHidden) || bothHidden){
        [self hideLeftButton];
        [self hideRightButton];
        
        NSRect frame = [self bounds];
        [mClipView setFrame:frame];
        frame = [mDocumentView frame];
        frame.origin.x = 0;
        [mDocumentView setFrame:frame];
        mXPos = 0;
    }
    else if(leftHidden){
        [self hideLeftButton];
        [mRightButton setHidden:NO];
        NSRect frame = [self bounds];
        frame.size.width -= mButtonWidth;
        [mClipView setFrame:frame];
        frame = [mDocumentView frame];
        frame.origin.x = 0;
        [mDocumentView setFrame:frame];
    }
    else if(rightHidden){
        [mLeftButton setHidden:NO];
        [self hideRightButton];
        NSRect frame = [self bounds];
        frame.size.width -= mButtonWidth;
        frame.origin.x = mButtonWidth;
        [mClipView setFrame:frame];
        
        frame = [mDocumentView frame];
        if(frame.origin.x + frame.size.width + mButtonWidth < [self bounds].size.width)
        {
            mXPos += [self bounds].size.width - (frame.origin.x + frame.size.width + mButtonWidth);
            frame.origin.x = mXPos - mButtonWidth;
        }
        else
        {
            frame.origin.x = mXPos - mButtonWidth;
        }
        
        [mDocumentView setFrame:frame];
    }
    else{
        [mLeftButton setHidden:NO];
        [mRightButton setHidden:NO];
        NSRect frame = [self bounds];
        frame.size.width -= mButtonWidth*2;
        frame.origin.x = mButtonWidth;
        [mClipView setFrame:frame];
        
        frame = [mDocumentView frame];
        frame.origin.x = mXPos - mButtonWidth;
        [mDocumentView setFrame:frame];
    }
}

- (void)viewDidEndLiveResize
{
    [self setAll];
}

-(void) controlFocus:(NSRect)frame
{
    if(frame.origin.x + mXPos < mClipView.frame.origin.x)
    {
        float diff = mClipView.frame.origin.x - (frame.origin.x + mXPos);
        mXPos += diff;
        [self setAll];
    }
    else if(frame.origin.x + frame.size.width + mXPos > mClipView.frame.origin.x + mClipView.frame.size.width)
    {
        float diff = frame.origin.x + frame.size.width + mXPos - (mClipView.frame.origin.x + mClipView.frame.size.width);
        mXPos -= diff;
        [self setAll];
    }
}

-(MyScrollButton*) getLeftButton
{
    return mLeftButton;
}

-(MyScrollButton*) getRightButton
{
    return mRightButton;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
