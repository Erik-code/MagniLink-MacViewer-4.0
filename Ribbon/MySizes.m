//
//  MySizes.m
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-22.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "MySizes.h"

@implementation MySizes

static float size;
static float barSize;

+(void) setSize:(float)height
{
    size = height;
}

+(void) setBarSize:(float)height
{
    barSize = height * 0.98;
}

+(float) menuSize
{
    return 0.2 * size;
}

+(float) buttonBarSize
{
    return barSize;
}

+(float) buttonWidth
{
    return 0.45 * barSize;
}

+(float) buttonImageSize
{
    return 0.40 * barSize;
}

+(float) buttonHeight
{
    return 0.72 * barSize;
}

+(float) groupLabelHeight
{
    return 0.2 * barSize;
}

+(float) imageMargin
{
    return 0.035 * barSize;
}

+(float) imageTextMargin
{
    return 0.080 * barSize;
}

+(float) buttonInteralMargin
{
    return 0.10 * barSize;
}

+(float) buttonMargin
{
    return 0.06 * barSize;
}

+(float) groupMargin
{
    return 0.12 * barSize;
}

+(float) separatorVerticalMargin
{
    return 0.10 * barSize;
}

+(float) sliderWidth
{
    return 1.5 * barSize;
}

+(float) sliderHeight
{
    return 0.30 * barSize;
}

+(float) fontPopUpWidth
{
    return 1.3 * barSize;
}


+(float) sizePopUpWidth
{
    return 0.90 * barSize;
}

+(float) popUpHeight
{
    return 0.35 * barSize;
}

+(float) fontSize
{
    return 0.14 * barSize;
}

+(float) knobSize
{
    return 0.19 * barSize;
}

+(float) trackWidth
{
    return 0.55 * barSize;
}

+(float) trackHeight
{
    return 0.06 * barSize;
}

+(float) pageMargin
{
    return 0.10f;
}

+(float) pageFormat
{
    return M_SQRT2;
}

+(int) minFontSize
{
    return 14;
}

+(float) fontDiff
{
    return 1.0833333f;
}

+(int) maxFontSize
{
    return 240;
}

+(NSArray*) fontSizes
{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    int size = [self minFontSize];
    while(size < [self maxFontSize])
    {
        [arr addObject:[NSString stringWithFormat:@"%d",size ]];
        size = (int)(size * [self fontDiff]);
    }
    
    return [[NSArray alloc] initWithArray:arr];
}

+ (NSSize) measureText:(NSString*)caption
{
    NSDictionary *attr = [MySizes fontAttributes];
    return [caption sizeWithAttributes:attr];
}

+ (NSDictionary*) fontAttributes
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attr = @{NSFontAttributeName:[NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]],NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[NSColor blackColor]};
    
    return attr;
}

+ (NSDictionary*) fontWhiteAttributes
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attr = @{NSFontAttributeName:[NSFont fontWithName:[MySizes fontName] size:[MySizes fontSize]],NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[NSColor whiteColor]};
    
    return attr;
}

+(float) menuMargin
{
    return 0.40 * barSize;
}

+(NSString*) fontName;
{
    return @"Helvetica";
}

+(NSColor*) mainColor
{
    return [NSColor colorWithRed:251.0f/255 green:134.0f/255 blue:51.0f/255 alpha:1.0f];
}

+(NSColor*) toggleColor
{
    //return [NSColor colorWithRed:255.0f/255 green:162.0f/255 blue:0.0f/255 alpha:0.5f];
    return [self mainColor];
}

+(NSColor*) hooverColor
{
    return [NSColor colorWithRed:255.0f/255 green:162.0f/255 blue:0.0f/255 alpha:0.5f];
}

@end
