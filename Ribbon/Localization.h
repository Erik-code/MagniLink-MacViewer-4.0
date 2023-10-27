//
//  Localization.h
//  MagniLink
//
//  Created by Erik Sandström on 2019-11-01.
//  Copyright © 2019 LVI Low Vision International AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Localizable <NSObject>
    @property NSString* localized;
@end

@interface NSString (Localizable) <Localizable>

@property NSString* localized;

@end

@protocol XIBLocalizable <NSObject>
    @property NSString* xibLocKey;
@end

IB_DESIGNABLE
@interface NSTextField (Localizable) <XIBLocalizable>

@property IBInspectable NSString* xibLocKey;

@end

@interface NSButton (Localizable) <XIBLocalizable>

@property IBInspectable NSString* xibLocKey;

@end

@interface NSTabViewItem (Localizable) <XIBLocalizable>

@property IBInspectable NSString* xibLocKey;

@end


NS_ASSUME_NONNULL_END
