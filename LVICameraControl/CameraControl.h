//
//  CameraControl.h
//  LVICameraControl
//
//  Created by Torbjörn Näslund on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CameraControlTypes.h"

typedef enum _ExposureMode
{
    Automatic,
    Manual,
    ShutterPriority,
} ExposureMode;

typedef enum _PnMode
{
    PnNatural,
    PnArtificial,
} PnMode;

typedef enum _CameraMode
{
    Undefined,
    Reading,
    Distance,
} CameraMode;

@interface ColorPair : NSObject

@property NSColor* foreColor;
@property NSColor* backColor;
@property bool positive;
@property bool negative;

-(ColorPair*)switchColors;

@end

// Interface for controlling the camera. In case of errors, CameraControlExceptions may be thrown.

@protocol CameraControl<NSObject>

- (void) connectWithKeepAliveTime:(UInt8) keepAliveTimeInSeconds;
- (void) disconnect;
- (BOOL) isConnected;
- (int) getProductConfiguration;
- (CameraType) getCameraType;
- (NSString*) getSerialNumber;
- (NSData*) getLicenseKey;
- (void) setLicenseKey:(NSData*) key;
- (NSData*) getCryptoKey;
- (TiltState) getTiltState;
- (BOOL) isTiltModeEnabled;
- (CIFCardStatus) getCIFCardStatus;
- (NSString*) getRegisterFileVersion;
- (BOOL) isAutofocusEnabled;
- (ColorPalette) getCurrentColorPal;
- (void) setColorPal:(ColorPalette)number;
- (NSColor*) getBackColor;
- (NSColor*) getForeColor;
- (int) getDeviceSpeed;
- (SInt32) getParameter:(NSString*)paramName;
- (void) setParameter:(NSString*)paramName withData:(SInt32)data;

- (void) enableTiltMode;
- (void) disableTiltMode;
- (void) setVideoFrequency: (UInt8) frequency;
- (void) setApplicationVersion: (NSString*) applicationVersion;
- (void) setImageWidth: (UInt16) width andHeight: (UInt16) height;
- (void) setApplicationStatusMinimized:(BOOL) minimized andLive:(BOOL) live andMegaPixel:(BOOL) megaPixel;
- (void) stopZoom;
- (void) startZoomIn;
- (void) startZoomOut;
- (int) getZoomPosition;
- (int) getMinZoomPosition;
- (void) startZoomToPosition:(int)position;
- (void) zoom:(int)aAmount;
- (bool) isZooming;
- (void) stopPan;
- (void) startPanLeft;
- (void) startPanRight;
- (void) stopTilt;
- (void) startTiltDown;
- (void) startTiltUp;
- (void) stopContrastChange;
- (void) startDecreaseContrast;
- (void) startIncreaseContrast;
- (void) setMiddleContrast;
- (void) setManualContrast;
- (void) setAutoContrast;
- (void) increaseNaturalColors;
- (void) decreaseNaturalColors;
- (void) increaseNegativeColors;
- (void) decreaseNegativeColors;
- (void) increasePositiveColors;
- (void) decreasePositiveColors;
- (void) increaseArtificialColors;
- (void) decreaseArtificialColors;
- (void) startMoveReferenceLineDownOrRight;
- (void) startMoveReferenceLineUpOrLeft;
- (void) stopReferenceLine;
- (int) getReferenceLinePosition;
- (void) setReferenceLinePosition:(int)position;
- (ReferenceLineOrient) getReferenceLineOrientation;
- (ReferenceLineType) getReferenceLineType;
- (void) setReferenceLineType:(ReferenceLineType)type andOrientation:(ReferenceLineOrient)orientation;
- (void) toggleAutofocus;
- (void) startFocusIn;
- (void) startFocusOut;
- (void) stopFocus;
- (bool) isRunning;
- (void) toggleColumnSelector;
- (BOOL) isColumnSelectorActive;
- (void) toggleMirrorImage;
- (BOOL) isMirrorImage;
- (void) setMirrorImage:(bool)mirror;
- (NSArray*) getAvailableResolutions;

#pragma mark Configuration

- (void) unlockRegFile;
- (void) disableWriteAndSave;
- (int) getCameraId;
- (CameraMode)getCameraMode;
- (NSMutableArray*) getColorPairs;
- (ColorPair*)getColorPair:(int)palette;
- (void)setColorPair:(int)palette withColors:(ColorPair*)pair;
- (ActivatedFunctions) getLineAndCurtain;
- (void) setLineAndCurtain:(ActivatedFunctions)val;
- (bool) hasGrayscale;
- (void) setGrayscale:(bool)enable;
- (int) getReferenceLineWidth;
- (void) setReferenceLineWidth:(int)width;
- (NSColor*) getGuidingLineColor:(int)palette;
- (void) setGuidingLineColor:(NSColor*)color forPalette:(int)palette;
- (void) setGuidingLineColor:(NSColor*)color;
- (void) setGuidingLinesSamaAsText;
- (bool) hasGuidingLineChanged;
- (void) setMinZoom:(int)value;
- (void) setMaxZoom:(int)value;
- (int) getMinZoom;
- (int) getMaxZoom;
- (int) getLight;
- (void) setLight:(int)value;

#pragma mark Camera Natural Colors
- (int) getCameraShutterTimeNaturalColors;
- (void) setCameraShutterTimeNaturalColors:(int)value;
- (int) getCameraExposureNaturalColors;
- (void) setCameraExposureNaturalColors:(int)value;
- (int) getCameraApertureNaturalColors;
- (void) setCameraApertureNaturalColors:(int)value;
- (int) getCameraRGain;
- (void) setCameraRGain:(int)value;
- (int) getCameraBGain;
- (void) setCameraBGain:(int)value;
- (ExposureMode)getCameraExposureMode:(PnMode)pnMode and:(CameraMode)camMode;
- (void) setCameraExposureMode:(ExposureMode)expMode for:(PnMode)pnMode and:(CameraMode)camMode;

#pragma mark Camera Artificial Colors
- (int) getCameraShutterTimeArtificialColors;
- (void) setCameraShutterTimeArtificialColors:(int)value;
- (int) getCameraExposureArtificialColors;
- (void) setCameraExposureArtificialColors:(int)value;
- (int) getCameraApertureArtificialColors;
- (void) setCameraApertureArtificialColors:(int)value;

#pragma mark Monitor Natural Colors
- (MyColor) getMonitorColorTempFor:(CameraMode)mode;
- (void) setMonitorColorTemp:(MyColor)value for:(CameraMode)mode;

-(MyRange) getMonitorBrightnessFor:(CameraMode)mode andGrayscale:(bool)grayscale;
-(void) setMonitorBrightness:(MyRange)range for:(CameraMode)mode andGrayscale:(bool)grayscale;

-(MyRange) getMonitorContrastFor:(CameraMode)mode andGrayscale:(bool)grayscale;
-(void) setMonitorContrast:(MyRange)range for:(CameraMode)mode andGrayscale:(bool)grayscale;

-(MyRange) getMonitorColorFor:(CameraMode)mode;
-(void) setMonitorColor:(MyRange)range for:(CameraMode)mode;

#pragma mark Monitor Artificial Colors

-(MyRange) getMonitorAutoPnFor:(CameraMode)mode;
-(void) setMonitorAutoPn:(MyRange)range for:(CameraMode)mode;

-(int) getMonitorContrastArtificialFor:(CameraMode)mode;
-(void) setMonitorContrastArtificial:(int)value for:(CameraMode)mode;

-(int) getMonitorBrightnessArtificialFor:(CameraMode)mode;
-(void) setMonitorBrightnessArtificial:(int)value for:(CameraMode)mode;

-(int) getPnStartLevel;
-(void) setPnStartLevel:(int)value;


@end
