//
//  OcrBitmap.h
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

#import <Foundation/Foundation.h>
#import "OcrBase.h"

@class NSImage;

NS_ASSUME_NONNULL_BEGIN

@interface OcrBitmap : OcrBase

-(id) initWithSettings:(OcrSettings*)settings;

-(BOOL) performOCRImage:(OcrArgument*)args;

@end

NS_ASSUME_NONNULL_END
