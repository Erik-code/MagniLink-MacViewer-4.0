//
//  ColorPairCommand.h
//  LVICameraControl
//
//  Created by Erik Sandström on 2019-10-08.
//  Copyright © 2019 Prevas AB. All rights reserved.
//

#import "RegisterFileCommand.h"
#import "CameraControlTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorPairCommand : RegisterFileCommand

- (id) initWithPalette:(int)palette andType:(ColorPaletteType)type andForeColor:(NSColor*)fore andBackColor:(NSColor*)back;

- (id) initWithGrayscale:(bool)grayscale;

@end

NS_ASSUME_NONNULL_END
