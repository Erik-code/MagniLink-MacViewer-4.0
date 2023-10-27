//
//  Localization.m
//  MagniLink
//
//  Created by Erik Sandström on 2019-11-01.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#define BL 50

#import "Localization.h"

@implementation NSString (Localizable)

-(void)setLocalized:(NSString *)localized
{
}

-(NSString*) localized
{
    return NSLocalizedString(self, @"");
}

@end


@implementation NSTextField(Localizable)

-(void) setXibLocKey:(NSString *)xibLocKey
{
    self.stringValue = xibLocKey.localized;
}

-(NSString*)xibLocKey
{
    return nil;
}

@end

@implementation NSButton(Localizable)

-(void) setXibLocKey:(NSString *)xibLocKey
{
    NSString *title = xibLocKey.localized;
    
    self.title = title;
    float length = [[self attributedTitle] size].width;
    NSRect frame = [self frame];
    frame.size.width = length + BL;
    
    [self setFrame:frame];
}

-(NSString*)xibLocKey
{
    return nil;
}

@end

@implementation NSTabViewItem(Localizable)

-(void) setXibLocKey:(NSString *)xibLocKey
{
    self.label = xibLocKey.localized;
}

-(NSString*)xibLocKey
{
    return nil;
}

@end
