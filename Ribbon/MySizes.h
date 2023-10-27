//
//  MySizes.h
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-22.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MySizes : NSObject

+(void) setSize:(float)height;
+(void) setBarSize:(float)height;

+(float) menuSize;
+(float) buttonWidth;
+(float) buttonHeight;
+(float) groupLabelHeight;
+(float) buttonBarSize;
+(float) buttonMargin;
+(float) buttonInteralMargin;
+(float) groupMargin;
+(float) imageMargin;
+(float) buttonImageSize;
+(float) imageTextMargin;
+(float) separatorVerticalMargin;
+(float) fontSize;
+(float) fontPopUpWidth;
+(float) sizePopUpWidth;
+(float) popUpHeight;
+(float) sliderWidth;
+(float) sliderHeight;
+(float) knobSize;
+(float) trackWidth;
+(float) trackHeight;

+(float) pageMargin;
+(float) pageFormat;

+(int) minFontSize;
+(float) fontDiff;
+(int) maxFontSize;
+(NSArray*) fontSizes;

+(NSSize) measureText:(NSString*)caption;
+(NSDictionary*) fontAttributes;
+(NSDictionary*) fontWhiteAttributes;
+(NSString*) fontName;
+(float) menuMargin;

+(NSColor*) mainColor;
+(NSColor*) toggleColor;
+(NSColor*) hooverColor;

@end

NS_ASSUME_NONNULL_END
