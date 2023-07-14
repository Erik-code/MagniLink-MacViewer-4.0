//
//  CurrentColorPalQuery.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2014-05-09.
//  Copyright (c) 2014 Prevas AB. All rights reserved.
//

#import "RegisterFileQuery.h"
#import "CameraControlTypes.h"

@interface CurrentColorPalQuery : RegisterFileQuery{
    @private ColorPalette colorPal;
    @private ColorPaletteType type;  
}

- (ColorPalette) getColorPal;
- (ColorPaletteType) getType;
@end
