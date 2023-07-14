//
//  ColorPairQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-07.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorPairQuery : RegisterFileQuery
{
    int mPalette;
    @private ColorPaletteType mType;
    @private NSColor* mForeColor;
    @private NSColor* mBackColor;
}

- (id) initWithPalette:(int)palette;

-(ColorPaletteType) type;
-(NSColor*) foreColor;
-(NSColor*) backColor;

@end

NS_ASSUME_NONNULL_END
