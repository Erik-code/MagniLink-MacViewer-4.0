/*
 *  CameraControlTypes.h
 *  CameraControl
 *
 *  Created by Torbjörn Näslund on 2/18/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>

typedef enum {
	TiltState_Reading,
	TiltState_Distance,
	TiltState_Off
} TiltState;

/*
typedef enum {
	ProductConfiguration_NoConfiguration,
	ProductConfiguration_MLS = 1,
	ProductConfiguration_MLSA = 2,
	ProductConfiguration_MLS_PRO = 3,
	ProductConfiguration_MLV_HR = 4,
	ProductConfiguration_MLV_HD = 5,
    ProductConfiguration_MLS_C01 = 0xA,
    ProductConfiguration_MLS_C02 = 0xB,
    ProductConfiguration_MLS_CM01 = 0xC,
    ProductConfiguration_MLS_CM02 = 0xD,
    ProductConfiguration_MLS_CM03 = 0xE,
    ProductConfiguration_ML_PRO_HD = 0x15,
    ProductConfiguration_ML_PRO_FHD = 0x16,
    ProductConfiguration_MLV_HD_V2 = 0x17,
    ProductConfiguration_MLV_FHD_V2 = 0x18,
    ProductConfiguration_MLZ_HD_V2 = 0x19,
    ProductConfiguration_MLZ_FHD_V2 = 0x1A,
    ProductConfiguration_MLZ_HD_13_V2 = 0x1B,
    ProductConfiguration_MLZ_FHD_13_V2 = 0x1C,
    ProductConfiguration_MLS_M01_V2 = 0x1D,
    ProductConfiguration_MLS_M02_V2 = 0x2E,
    ProductConfiguration_MLS_C01_V2 = 0x1F,
    ProductConfiguration_MLS_C02_V2 = 0x20,
    ProductConfiguration_MLS_CM01_V2 = 0x21,
    ProductConfiguration_MLS_CM02_V2 = 0x22,
    ProductConfiguration_MLS_CM03_V2 = 0x23,
} ProductConfiguration;
*/

typedef enum {
	CIFCardStatus_Startup,
	CIFCardStatus_BridgeStop,
	CIFCardStatus_BridgeStart,
    CIFCardStatus_Standby,
	CIFCardStatus_E2PUpdate,
	CIFCardStatus_VideoEnable,
	CIFCardStatus_VideoStandby,
	CIFCardStatus_VideoDisable,
	CIFCardStatus_VideoStart,
	CIFCardStatus_VideoShow,
    CIFCardStatus_VideoStop,
	CIFCardStatus_ExternPowerLow
} CIFCardStatus;

typedef enum {
	Sony_IX45,
	Videology_20Z404,
	Sony_EX45C,
	Sony_IX10,
	Sony_IX11,
	Sony_H10,
	Sony_H11,
	Sony_EX11,
	Sony_EX48E,
	Sony_EX490E,
	Sony_EVI_D70,
	Sony_EVI_HD3V
} CameraType;

typedef enum {
	Autofocus_On,
	Autofocus_Off
} AutofocusState;

typedef enum {
	Pan_Stop,
	Pan_Right,
	Pan_Left
} PanStateDistance;

typedef enum {
	Tilt_Stop,
	Tilt_Up,
	Tilt_Down
} TiltStateDistance;

typedef enum {
    Palette_0,
    Palette_1,
    Palette_2,
    Palette_3,
    Palette_4,
    Palette_5,
    Palette_6,
    Palette_7,
    Palette_8,
    Palette_9,
    Palette_10,
    Palette_11,
    Palette_12,
    Palette_13,
    Palette_14,
    Palette_15,
    
    Palette_Numbers
} ColorPalette;

typedef enum {
    Unused,
    Natural,
    Positive,
    Negative,
} ColorPaletteType;

typedef enum {
    ReferenceLine,
    Curtain
} ReferenceLineType;

typedef enum {
    OutsideLowerLeft,
    OutsideUpperRight,
    Vertical,
    Horizontal,
} ReferenceLineOrient;

typedef enum {
    LineActive,
    CurtainActive,
    BothActive
} ActivatedFunctions;


typedef struct _MyColor
{
    uint8 red;
    uint8 green;
    uint8 blue;
} MyColor;


NS_INLINE MyColor MyMakeColor(uint8 r, uint8 g, uint8 b) {
    MyColor c;
    c.red = r;
    c.green = g;
    c.blue = b;
    return c;
}

typedef struct _MyRange
{
    UInt16 min;
    UInt16 max;
} MyRange;

NS_INLINE MyRange MyMakeRange(uint16 min, uint16 max) {
    MyRange r;
    r.min = min;
    r.max = max;
    return r;
}




