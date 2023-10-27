//
//  MyButtonBarView.h
//  TestNSView
//
//  Created by Erik Sandström on 2019-05-21.
//  Copyright © 2019 Erik Sandström. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum RibbonGroupsCamera : NSUInteger {
    RibbonGroup_CameraColors =          (1 << 0),
    RibbonGroup_CameraMagnification =   (1 << 1),
    RibbonGroup_CameraMultiCam =        (1 << 2),
    RibbonGroup_CameraPanTilt =         (1 << 3),
    RibbonGroup_CameraPresets =         (1 << 4),
    RibbonGroup_CameraFocus =           (1 << 5),
    RibbonGroup_CameraManualFocus =     (1 << 6),
    RibbonGroup_CameraContrast =        (1 << 7),
    RibbonGroup_CameraReferenceLine =   (1 << 8),
    RibbonGroup_CameraLight =           (1 << 9),
    RibbonGroup_CameraPicture =         (1 << 10),
    RibbonGroup_CameraVideo =           (1 << 11),
    RibbonGroup_CameraFunctions =       (1 << 12),
    RibbonGroup_CameraOCR =             (1 << 13),
    RibbonGroup_CameraHelp =            (1 << 14),
    RibbonGroup_CameraNumbers =         15,
    RibbonGroup_CameraAll =             0xFFFFF

} RibbonGroupsCamera;

typedef enum RibbonGroupsOCR : NSUInteger {
    
    RibbonGroup_OcrDocument =           (1 << 0),
    RibbonGroup_OcrColors =             (1 << 1),
    RibbonGroup_OcrFont =               (1 << 2),
    RibbonGroup_OcrSpeech =             (1 << 3),
    RibbonGroup_OcrNavigation =         (1 << 4),
    RibbonGroup_OcrVolumeAndSpeed =     (1 << 5),
    RibbonGroup_OcrPages =              (1 << 6),
    RibbonGroup_OcrHelp =               (1 << 7),
    RibbonGroup_OcrNumbers =            8,
    RibbonGroup_OcrAll =                0xFFFFF
    
} RibbonGroupsOCR;

NS_ASSUME_NONNULL_BEGIN

@interface MyButtonBarView : NSView
{
    NSArray* mDrawArray;
}

@end

NS_ASSUME_NONNULL_END
