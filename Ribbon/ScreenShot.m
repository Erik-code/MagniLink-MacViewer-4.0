//
//  ScreenShot.m
//  MagniLink
//
//  Created by Erik Sandström on 2019-11-05.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import "ScreenShot.h"
#import <Cocoa/Cocoa.h>
@import CoreServices; // or `@import CoreServices;` on Mac
@import ImageIO;

@interface ScreenShot()
{
    NSSize imageSize;
    NSSize ribbonSize;
    NSImage *image;
}
@end

@implementation ScreenShot

-(NSImage*) getScreenShot
{
    NSArray<NSRunningApplication*> *apps =
        [NSRunningApplication runningApplicationsWithBundleIdentifier:
            /* Bundle ID of the application, e.g.: */ @"se.lvi.MacViewer"];
    if (apps.count == 0) {
        // Application is not currently running
        puts("The application is not running");
        return nil; // Or whatever
    }
    pid_t appPID = apps[0].processIdentifier;
    
    NSArray<NSDictionary*> *windowInfoList = (__bridge_transfer id)
    CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
    
    NSMutableArray<NSDictionary*> *appWindowsInfoList = [NSMutableArray new];
    for (NSDictionary *info in windowInfoList) {
        if ([info[(__bridge NSString *)kCGWindowOwnerPID] integerValue] == appPID) {

            CGRect bounds;
        CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)info[(id)kCGWindowBounds], &bounds);

            if(bounds.size.width > 1200 && bounds.size.height > 900){
                [appWindowsInfoList addObject:info];
            }
        }
    }
    
    NSDictionary *appWindowInfo = appWindowsInfoList[0];
    CGWindowID windowID = [appWindowInfo[(__bridge NSString *)kCGWindowNumber] unsignedIntValue];
    
    CGImageRef ref = CGWindowListCreateImage(CGRectNull,
    kCGWindowListOptionIncludingWindow,
    windowID,
    kCGWindowImageBoundsIgnoreFraming | kCGWindowImageBestResolution);
    
    int width = (int)CGImageGetWidth(ref);
    int height = (int)CGImageGetHeight(ref);

    NSImage* image = [[NSImage alloc] initWithCGImage:ref size:NSMakeSize(width, height)];
    return image;
}

-(void) begin:(NSSize) size
{
    imageSize = size;
    image = [[NSImage alloc] initWithSize:imageSize];
    [image lockFocus];
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path appendBezierPathWithRect:NSMakeRect(0, 0, size.width, size.height)];
    [[NSColor whiteColor] set];
    [path fill];
}

-(void) takeScreenShot:(NSRect) rect
{
    NSImage *screen = [self getScreenShot];
    NSRect drawRect = rect;
    drawRect.origin.y = 0;
    
    [screen drawInRect:drawRect fromRect:rect operation:NSCompositingOperationCopy fraction:1.0];
}

-(void) addArrow:(NSString*)number atPosition:(NSPoint)position
{
    float x = position.x;
    float y = position.y;
    
    NSBezierPath *path = [[NSBezierPath alloc] init];
    float arrowWidthHalf = 10;
    float arrowHeight = 30;
    float widthHalf = 2;
    float circleWidth = 48;
    float circleThickness = 4;
    float topMargin = 10;
 
    [[NSColor grayColor] set];
    
    [path moveToPoint:position];
    [path lineToPoint:NSMakePoint(x - arrowWidthHalf , y + arrowHeight)];
    [path lineToPoint:NSMakePoint(x - widthHalf , y + arrowHeight-widthHalf)];
    [path lineToPoint:NSMakePoint(x - widthHalf , imageSize.height - topMargin - circleWidth)];
    [path lineToPoint:NSMakePoint(x + widthHalf , imageSize.height - topMargin - circleWidth)];
    [path lineToPoint:NSMakePoint(x + widthHalf , y + arrowHeight-widthHalf)];
    [path lineToPoint:NSMakePoint(x + arrowWidthHalf , y + arrowHeight)];
    [path closePath];
    [path fill];
    
    path = [[NSBezierPath alloc] init];
    [path setLineWidth:circleThickness];
    [path appendBezierPathWithOvalInRect:NSMakeRect(x -circleWidth*0.5, imageSize.height - topMargin - circleWidth , circleWidth, circleWidth)];
    [path stroke];
    
    NSMutableParagraphStyle * paragraphStyle =
        [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];

    NSDictionary *attributes =
    @{ NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:32.0],
    NSForegroundColorAttributeName : NSColor.blackColor ,
       NSParagraphStyleAttributeName : paragraphStyle
    };
    
    [number drawInRect:NSMakeRect(x -circleWidth*0.5, imageSize.height - topMargin - circleWidth - 5 , circleWidth, circleWidth) withAttributes:attributes];
    
}

-(void) saveToFile:(NSString*)path
{
    [image unlockFocus];
    [[image TIFFRepresentation] writeToFile:path atomically:YES];
}

@end
