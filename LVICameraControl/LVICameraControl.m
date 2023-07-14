//
//  CameraControl.m
//  CameraControl
//
//  Created by Torbjörn Näslund on 2/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LVICameraControl.h"
#import "VersionRegisterFileQuery.h"
#import "SetKeepAliveTime.h"
#import "SetVideoFrequency.h"
#import "SetApplicationVersion.h"
#import "SetImageWidth.h"
#import	"SetImageHeight.h"
#import	"ProductConfigurationQuery.h"
#import "SerialNumberQuery.h"
#import "LicenseKeyQuery.h"
#import "CryptoKeyQuery.h"
#import "TiltStateQuery.h"
#import "SetApplicationStatus.h"
#import "CIFCardStatusQuery.h"
#import "LockCamera.h"
#import "SetZoom.h"
#import "KeepAlive.h"
#import "SetContrast.h"
#import "SetColorPalette.h"
#import "SetTiltState.h"
#import "SetReferenceLine.h"
#import "CameraControlException.h"
#import "SetLicenseKey.h"
#import "SetUserAreaControl.h"
#import "AutofocusQuery.h"
#import "SetAutoFocus.h"
#import "SetPanAndTilt.h"
#import "PanAndTiltQuery.h"
#import "CameraTypeQuery.h"
#import "CurrentColorPalQuery.h"
#import "BackColorQuery.h"
#import "ForeColorQuery.h"
#import "ShownObjectsQuery.h"
#import "SetShownObjects.h"
#import "SetControlCurrentColorPal.h"
#import "ZoomPositionQuery.h"
#import "SetControlZoomPosition.h"
#import "MinZoomPositionQuery.h"
#import "SetControlReferenceLine.h"
#import "ReferenceLineQuery.h"
#import "ReferenceLineOrientationQuery.h"
#import "SetControlReferenceLineOrientation.h"
#import "VideoGenQuery.h"
#import "VideoWidthQuery.h"
#import "VideoHeightQuery.h"
#import "SetFocus.h"
#import "UserPanelStateQuery.h"
#import "IsZoomingQuery.h"
#import "ColorPairQuery.h"
#import "SetRegFile.h"
#import "ColorPairCommand.h"
#import "ActivatedFunctionsQuery.h"
#import "ActivatedFunctionsCommand.h"
#import "GeneralQuery.h"
#import "GeneralCommand.h"
#import "CameraMap.h"

static const NSTimeInterval KEEP_ALIVE_SAFTY_MARGIN = 1.5;

@implementation ColorPair

@synthesize foreColor;
@synthesize backColor;
@synthesize positive;
@synthesize negative;

-(ColorPair*) switchColors
{
    ColorPair* colors = [[ColorPair alloc] init];
    colors.foreColor = self.backColor;
    colors.backColor = self.foreColor;
    colors.positive = self.positive;
    colors.negative = self.negative;
    return colors;
}

@end

@interface LVICameraControl()
{
    bool mRefColorChanged;
}
- (void) updateVersion;
- (void) tryLockCamera;
- (void) setRegisterFileVersion: (NSString*) v;
- (void) setKeepAliveTime: (UInt8) keepAliveTimeInSeconds;
- (void) startKeepAliveTimer: (NSTimeInterval) timeIntervalInSeconds;
- (void) keepAliveTimerTick: (NSTimer*) timer;
- (void) trySetupControlChannel: (UInt8) keepAliveTimeInSeconds;
@end

@implementation LVICameraControl

-(id) init {
	ControlChannelFactory* defaultFactory = [[ControlChannelFactory alloc] init];
	return [self initWithControlChannelFactory: defaultFactory];
}

- (id) initWithControlChannelFactory: (ControlChannelFactory*) factory {
	self = [super init];
	if (self) {
		controlChannelFactory = factory;
        mRefColorChanged = false;
        [CameraMap initMap];
	}
	return self;
}

- (void) dealloc {
	[self disconnect];
}

- (void) connectWithKeepAliveTime: (UInt8) keepAliveTimeInSeconds {
	if (!controlChannel) {
		controlChannel = [controlChannelFactory createControlChannel];
		[self trySetupControlChannel: keepAliveTimeInSeconds];
	}	
}

- (void) trySetupControlChannel: (UInt8) keepAliveTimeInSeconds {
	@try {
		[self setKeepAliveTime: keepAliveTimeInSeconds];
		[self updateVersion];
	}
	@catch (CameraControlException* e) {
		[self disconnect];
		@throw e;
	}
}

- (void) disconnect {
	if (keepAliveTimer) {
		[keepAliveTimer invalidate];
		keepAliveTimer = nil;
	}
	if (controlChannel) {
		[self tryLockCamera];
		controlChannel = nil;
	}			
}

- (BOOL) isConnected {
	return (controlChannel != nil);	
}

- (int) getDeviceSpeed
{
    return [controlChannel getDeviceSpeed];
}

- (void) updateVersion {
	VersionRegisterFileQuery* query = [[VersionRegisterFileQuery alloc] init];
	[query execute:controlChannel];
	[self setRegisterFileVersion: [query getVersion]];
}

- (SInt32) getParameter:(NSString*)paramName
{
    NSRange range = [CameraMap getCameraParameter:paramName];
    GeneralQuery *query = [[GeneralQuery alloc] initWithCommand:range.location andLength:range.length];
    [query execute:controlChannel];
    return [query getData];
}

- (void) setParameter:(NSString*)paramName withData:(SInt32)data
{
    NSRange range = [CameraMap getCameraParameter:paramName];
    GeneralCommand *command = [[GeneralCommand alloc] initWithCommand:range.location andLength:range.length andData:data];
    [command execute:controlChannel];
}

- (void) setRegisterFileVersion: (NSString*) v {
	registerFileVersion = v;
}

- (NSString*) getRegisterFileVersion {
	return registerFileVersion;
}

- (void) setKeepAliveTime: (UInt8) keepAliveTimeInSeconds {
	SetKeepAliveTime* command = [[SetKeepAliveTime alloc] initWithKeepAliveTimeInSeconds:keepAliveTimeInSeconds];
	[command execute:controlChannel];
	[self startKeepAliveTimer: (NSTimeInterval) keepAliveTimeInSeconds / KEEP_ALIVE_SAFTY_MARGIN];
}

- (void) startKeepAliveTimer: (NSTimeInterval) timeIntervalInSeconds {
	if (keepAliveTimer) {
		[keepAliveTimer invalidate];
		keepAliveTimer = nil;
	}
	if (timeIntervalInSeconds > 0.0) {
		keepAliveTimer = [NSTimer scheduledTimerWithTimeInterval:timeIntervalInSeconds target:self selector:@selector(keepAliveTimerTick:) userInfo:nil repeats:YES];
	}
}

- (void) keepAliveTimerTick: (NSTimer*) timer {
	KeepAlive* command = [[KeepAlive alloc] init];
	[command execute:controlChannel];	
}


- (int) getProductConfiguration {
	ProductConfigurationQuery* query = [[ProductConfigurationQuery alloc] init];
	[query execute:controlChannel];
	return [query getConfiguration];	
}

- (CameraType) getCameraType {
	CameraTypeQuery* query = [[CameraTypeQuery alloc] init ];
	[query execute:controlChannel];
	return [query getCameraType];
}

- (NSString*) getSerialNumber {
	SerialNumberQuery* query = [[SerialNumberQuery alloc] init];
	[query execute:controlChannel];
	return [query getSerialNumber];
}

- (NSData*) getLicenseKey {
	LicenseKeyQuery* query = [[LicenseKeyQuery alloc] init];
	[query execute:controlChannel];
	return [query getLicenseKey];
}

- (void) setLicenseKey:(NSData*) key {
	SetUserAreaControl* enableUserArea = [[SetUserAreaControl alloc] initWithCommand:SetUserAreaControl_On];
	[enableUserArea execute:controlChannel];
	SetLicenseKey* setLicenseKeyCommand = [[SetLicenseKey alloc] initWithKey:key];
	[setLicenseKeyCommand execute:controlChannel];
	SetUserAreaControl* disableUserArea = [[SetUserAreaControl alloc] initWithCommand:SetUserAreaControl_Off];
	[disableUserArea execute:controlChannel];
}

- (NSData*) getCryptoKey {
	CryptoKeyQuery* query = [[CryptoKeyQuery alloc] init];
	[query execute:controlChannel];
	return [query getCryptoKey];
}

- (TiltState) getTiltState {
	TiltStateQuery* query = [[TiltStateQuery alloc] init];
	[query execute:controlChannel];
	return [query getTiltState];	
}

- (BOOL) isTiltModeEnabled {
	return [self getTiltState] != TiltState_Off;
}

- (void) enableTiltMode {
	if (![self isTiltModeEnabled]) {
		SetTiltState* command = [[SetTiltState alloc] initWithState:TiltState_Reading];
		[command execute:controlChannel];
	}
}

- (void) disableTiltMode {
	if ([self isTiltModeEnabled]) {
		SetTiltState* command = [[SetTiltState alloc] initWithState:TiltState_Off];
		[command execute:controlChannel];
	}
}

- (void) setVideoFrequency: (UInt8) frequency {
	SetVideoFrequency* command = [[SetVideoFrequency alloc] initWithFrequency:frequency];
	[command execute:controlChannel];
}

- (void) setApplicationVersion: (NSString*) applicationVersion {
	SetApplicationVersion* command = [[SetApplicationVersion alloc] initWithVersion:applicationVersion];
	[command execute:controlChannel];	
}

- (void) setImageWidth: (UInt16) width andHeight: (UInt16) height {
	SetImageWidth* widthCommand = [[SetImageWidth alloc] initWithWidth:width];
	[widthCommand execute:controlChannel];
	SetImageHeight* heightCommand = [[SetImageHeight alloc] initWithHeight:height];
	[heightCommand execute:controlChannel];	
}

- (void) setApplicationStatusMinimized:(BOOL) minimized andLive:(BOOL) live andMegaPixel:(BOOL) megaPixel {
	SetApplicationStatus* command = [[SetApplicationStatus alloc]
									  initWithStatusMinimized:minimized andLive:live andMegaPixel:megaPixel];
	[command execute:controlChannel];
}

- (CIFCardStatus) getCIFCardStatus {
	CIFCardStatusQuery* query = [[CIFCardStatusQuery alloc] init];
	[query execute:controlChannel];
	return [query getStatus];
}

- (void) tryLockCamera {
	@try {
		LockCamera* command = [[LockCamera alloc] init];
		[command execute:controlChannel];
	}
	@catch (CameraControlException* exception) {
		// Have to catch and ignore this exception since it can be thrown
		// if the camera's usb cable is disconnected and we are trying
		// deallocate this object.
	}
}

- (void) stopZoom {
	SetZoom* command = [[SetZoom alloc] initWithCommand:SetZoom_Stop];
	[command execute:controlChannel];
}

- (void) startZoomIn {
	SetZoom* command = [[SetZoom alloc] initWithCommand:SetZoom_In];
	[command execute:controlChannel];
	
}

- (void) startZoomOut {
	SetZoom* command = [[SetZoom alloc] initWithCommand:SetZoom_Out];
	[command execute:controlChannel];	
}

- (void) zoom:(int)aAmount
{
    if ([self isZooming]) return;
    
    int zoomMax = [self getMaxZoom];
    int zoomMin = [self getMinZoom];
    
    int zoomPos = [self getZoomPosition];

    zoomPos += aAmount;
    
    if (zoomPos > zoomMax)
        zoomPos = zoomMax;
    if (zoomPos < zoomMin)
        zoomPos = zoomMin;
    
    [self startZoomToPosition:zoomPos];
}

- (int) getZoomPosition
{
    ZoomPositionQuery* query = [[ZoomPositionQuery alloc] init];
    [query execute:controlChannel];
    return (int)[query getZoomPos];
}

- (int) getMinZoomPosition
{
    TiltStateQuery* query = [[TiltStateQuery alloc] init];
    [query execute:controlChannel];
    
    MinZoomPositionQuery* query2 = [[MinZoomPositionQuery alloc] initWithTiltState:[query getTiltState] ];
    [query2 execute:controlChannel];
    
    return [query2 getZoomPosition];
}

- (void) startZoomToPosition:(int)position
{
    SetControlZoomPosition* command = [[SetControlZoomPosition alloc] initWithPosition:position];
    [command execute:controlChannel];
    
    SetZoom *command2 = [[SetZoom alloc] initWithCommand:SetZoom_Position];
    [command2 execute:controlChannel];
}

- (bool) isZooming
{
    IsZoomingQuery* query = [[IsZoomingQuery alloc] init];
    [query execute:controlChannel];
    return [query isZooming];
}

- (void) stopPan {
	PanAndTiltQuery* query = [[PanAndTiltQuery alloc] init];
	[query execute:controlChannel];
	if ([query getTiltState] == Tilt_Stop) {
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Stop_Stop];
		[command execute:controlChannel];
	}
	else if([query getTiltState] == Tilt_Up){
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Stop_Up];
		[command execute:controlChannel];
	}
	else{
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Stop_Down];
		[command execute:controlChannel];
	}	
}

- (void) startPanLeft {
	PanAndTiltQuery* query = [[PanAndTiltQuery alloc] init];
	[query execute:controlChannel];
	if ([query getTiltState] == Tilt_Stop) {
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Left_Stop];
		[command execute:controlChannel];
	}
	else if([query getTiltState] == Tilt_Up){
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Left_Up];
		[command execute:controlChannel];
	}
	else{
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Left_Down];
		[command execute:controlChannel];
	}
}

- (void) startPanRight {
	PanAndTiltQuery* query = [[PanAndTiltQuery alloc] init];
	[query execute:controlChannel];
	if ([query getTiltState] == Tilt_Stop) {
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Right_Stop];
		[command execute:controlChannel];
	}
	else if([query getTiltState] == Tilt_Up){
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Right_Up];
		[command execute:controlChannel];
	}
	else{
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Right_Down];
		[command execute:controlChannel];
	}
}

- (void) stopTilt {
	PanAndTiltQuery* query = [[PanAndTiltQuery alloc] init];
	[query execute:controlChannel];
	if ([query getPanState] == Pan_Stop) {
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Stop_Stop];
		[command execute:controlChannel];
	}
	else if([query getPanState] == Pan_Right){
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Right_Stop];
		[command execute:controlChannel];
	}
	else{
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Left_Stop];
		[command execute:controlChannel];
	}
}

- (void) startTiltDown
{
	PanAndTiltQuery* query = [[PanAndTiltQuery alloc] init];
	[query execute:controlChannel];
	if ([query getPanState] == Pan_Stop) {
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Stop_Down];
		[command execute:controlChannel];
	}
	else if([query getPanState] == Pan_Right){
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Right_Down];
		[command execute:controlChannel];
	}
	else{
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Left_Down];
		[command execute:controlChannel];
	}
}

- (void) startTiltUp
{
	PanAndTiltQuery* query = [[PanAndTiltQuery alloc] init];
	[query execute:controlChannel];
	if ([query getPanState] == Pan_Stop) {
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Stop_Up];
		[command execute:controlChannel];
	}
	else if([query getPanState] == Pan_Right){
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Right_Up];
		[command execute:controlChannel];
	}
	else{
		SetPanAndTilt* command = [[SetPanAndTilt alloc] initWithCommand:SetPanAndTilt_Left_Up];
		[command execute:controlChannel];
	}
}

- (void) stopContrastChange {
	SetContrast* command = [[SetContrast alloc] initWithCommand:SetContrast_Stop];
	[command execute:controlChannel];	
}

- (void) startDecreaseContrast {
	SetContrast* command = [[SetContrast alloc] initWithCommand:SetContrast_Decrease];
	[command execute:controlChannel];
}

- (void) startIncreaseContrast {
	SetContrast* command = [[SetContrast alloc] initWithCommand:SetContrast_Increase];
	[command execute:controlChannel];
}

- (void) setMiddleContrast {
	SetContrast* command = [[SetContrast alloc] initWithCommand:SetContrast_Middle];
	[command execute:controlChannel];
}

- (void) setManualContrast {
	SetContrast* command = [[SetContrast alloc] initWithCommand:SetContrast_Manual];
	[command execute:controlChannel];
}

- (void) setAutoContrast {
	SetContrast* command = [[SetContrast alloc] initWithCommand:SetContrast_Auto];
	[command execute:controlChannel];
}

- (void) increaseNaturalColors {
	SetColorPalette* command = [[SetColorPalette alloc] initWithCommand:SetColorPalette_IncreaseNaturalColors];
	[command execute:controlChannel];
}

- (void) decreaseNaturalColors {
	SetColorPalette* command = [[SetColorPalette alloc] initWithCommand:SetColorPalette_DecreaseNaturalColors];
	[command execute:controlChannel];
}

- (void) increaseNegativeColors {
	SetColorPalette* command = [[SetColorPalette alloc] initWithCommand:SetColorPalette_IncreaseNegativeColors];
	[command execute:controlChannel];
}

- (void) decreaseNegativeColors {
	@synchronized(self) {
		SetColorPalette* command = [[SetColorPalette alloc] initWithCommand:SetColorPalette_DecreaseNegativeColors];
		[command execute:controlChannel];
	}	
}

- (void) increasePositiveColors
{
    NSRange range = [CameraMap getCameraParameter:@"wCmdColorPal"];
    SInt32 data = 0x84;
    GeneralCommand* gc = [[GeneralCommand alloc] initWithCommand:range.location andLength:range.length andData:data];
    [gc execute:controlChannel];
    
    /*
	SetColorPalette* command = [[SetColorPalette alloc] initWithCommand:SetColorPalette_IncreasePositiveColors];
	[command execute:controlChannel];
     */
}

- (void) decreasePositiveColors {
	SetColorPalette* command = [[SetColorPalette alloc] initWithCommand:SetColorPalette_DecreasePositiveColors];
	[command execute:controlChannel];
}

- (void) increaseArtificialColors {
	SetColorPalette* command = [[SetColorPalette alloc] initWithCommand:SetColorPalette_IncreaseArtificialColors];
	[command execute:controlChannel];
}

- (void) decreaseArtificialColors {
	SetColorPalette* command = [[SetColorPalette alloc] initWithCommand:SetColorPalette_DecreaseArtificialColors];
	[command execute:controlChannel];
}

- (void) startMoveReferenceLineDownOrRight {
	SetReferenceLine* command = [[SetReferenceLine alloc] initWithCommand:SetReferenceLine_DownOrRight];
	[command execute:controlChannel];
}

- (void) startMoveReferenceLineUpOrLeft {
	SetReferenceLine* command = [[SetReferenceLine alloc] initWithCommand:SetReferenceLine_UpOrLeft];
	[command execute:controlChannel];
}

- (void) stopReferenceLine {
	SetReferenceLine* command = [[SetReferenceLine alloc] initWithCommand:SetReferenceLine_Stop];
	[command execute:controlChannel];
}

- (int) getReferenceLinePosition
{
    ReferenceLineQuery* query = [[ReferenceLineQuery alloc] init];
    [query execute:controlChannel];
    return (int)[query getRefLinePosition];
}

- (void) setReferenceLinePosition:(int)position
{
    SetControlReferenceLine* command = [[SetControlReferenceLine alloc] initWithPosition:(uint16)position];
    [command execute:controlChannel];
    
    SetReferenceLine* command2 = [[SetReferenceLine alloc] initWithCommand:SetReferenceLine_GotoPosition];
    [command2 execute:controlChannel];
}

- (ReferenceLineOrient) getReferenceLineOrientation
{
    ReferenceLineOrientationQuery* query = [[ReferenceLineOrientationQuery alloc] init];
    [query execute:controlChannel];
    return [query getRefLineOrientation];
}

- (ReferenceLineType) getReferenceLineType
{
    ReferenceLineOrientationQuery* query = [[ReferenceLineOrientationQuery alloc] init];
    [query execute:controlChannel];
    return [query getRefLineType];
}

- (void) setReferenceLineType:(ReferenceLineType)type andOrientation:(ReferenceLineOrient)orientation
{
    SetControlReferenceLineOrientation* command = [[SetControlReferenceLineOrientation alloc] initWithType:type andOrientation:orientation];
    [command execute:controlChannel];
}

- (void) toggleAutofocus {
	AutofocusQuery* query = [[AutofocusQuery alloc] init];
	[query execute:controlChannel];
	if([query getAutofocusState] == Autofocus_On){
		SetAutofocus* command = [[SetAutofocus alloc] initWithCommand:SetAutofocus_Off];
		[command execute:controlChannel];
	}
	else {
		SetAutofocus* command = [[SetAutofocus alloc] initWithCommand:SetAutofocus_On];
		[command execute:controlChannel];
	}
}

- (void) startFocusIn
{
    SetFocus* command = [[SetFocus alloc] initWithCommand:SetFocus_In];
	[command execute:controlChannel];
}

- (void) startFocusOut
{
    SetFocus* command = [[SetFocus alloc] initWithCommand:SetFocus_Out];
	[command execute:controlChannel];    
}

- (void) stopFocus
{
    SetFocus* command = [[SetFocus alloc] initWithCommand:SetFocus_Stop];
	[command execute:controlChannel];
}

- (void) toggleColumnSelector
{
    ShownObjectsQuery* query = [[ShownObjectsQuery alloc ] init ];
    [query execute:controlChannel];
    uint8 shownObjects = [query getShownObjects];
    shownObjects ^= 1 << 3;
    SetShownObjects* command = [[SetShownObjects alloc] initWithCommand:shownObjects];
    [command execute:controlChannel];
}

- (BOOL) isColumnSelectorActive
{
    ShownObjectsQuery* query = [[ShownObjectsQuery alloc ] init ];
    [query execute:controlChannel];
    uint8 shownObjects = [query getShownObjects];
    return (shownObjects & 0x8) != 0;
}

- (void) toggleMirrorImage
{
    ShownObjectsQuery* query = [[ShownObjectsQuery alloc ] init ];
    [query execute:controlChannel];
    uint8 shownObjects = [query getShownObjects];
    shownObjects ^= 1 << 4;
    SetShownObjects* command = [[SetShownObjects alloc] initWithCommand:shownObjects];
    [command execute:controlChannel];    
}

- (BOOL) isMirrorImage;
{
    ShownObjectsQuery* query = [[ShownObjectsQuery alloc ] init ];
    [query execute:controlChannel];
    uint8 shownObjects = [query getShownObjects];
    return (shownObjects & 0x10) != 0;    
}

- (void) setMirrorImage:(bool)mirror
{
    ShownObjectsQuery* query = [[ShownObjectsQuery alloc ] init ];
    [query execute:controlChannel];
    uint8 shownObjects = [query getShownObjects];
    if(mirror){
        shownObjects |= 1 << 4;
    }
    else{
        shownObjects &= ~(1 << 4);
    }
    SetShownObjects* command = [[SetShownObjects alloc] initWithCommand:shownObjects];
    [command execute:controlChannel]; 
}

- (BOOL) isAutofocusEnabled {
    AutofocusQuery* query = [[AutofocusQuery alloc] init];
    [query execute:controlChannel];
    return [query getAutofocusState] == Autofocus_On;
}

- (ColorPalette) getCurrentColorPal{
    CurrentColorPalQuery* query = [[CurrentColorPalQuery alloc]init ];
    [query execute:controlChannel];
    return [query getColorPal];
}

- (void) setColorPal:(ColorPalette)number
{
    SetControlCurrentColorPal *command = [[SetControlCurrentColorPal alloc] initWithCommand:number];
    [command execute:controlChannel];
    SetColorPalette *command2 = [[SetColorPalette alloc] initWithCommand:SetColorPalette_FromControlRegister];
    [command2 execute:controlChannel];
}

- (NSColor*) getBackColor{
    int pal = [self getCurrentColorPal ];
    BackColorQuery* query = [[BackColorQuery alloc] initWithGroup:pal ];
    [query execute:controlChannel];
    return [query getBackColor];
}

- (NSColor*) getForeColor{
    int pal = [self getCurrentColorPal ];
    ForeColorQuery* query = [[ForeColorQuery alloc] initWithGroup:pal ];
    [query execute:controlChannel];
    return [query getForeColor];
}

- (NSArray*) getAvailableResolutions
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < 8 ; i++){
        VideoGenQuery* query = [[VideoGenQuery alloc] initWithGroup:i];
        [query execute:controlChannel];
        if([query isUsb] && [query isInterlaced] == NO){
            
            VideoWidthQuery *queryW = [[VideoWidthQuery alloc] initWithGroup:i];
            [queryW execute:controlChannel]; 

            VideoHeightQuery *queryH = [[VideoHeightQuery alloc] initWithGroup:i];
            [queryH execute:controlChannel]; 

            [array addObject:[NSValue valueWithSize:NSMakeSize([queryW getWidth], [queryH getHeight])]];
        }
    }
    return array;
}

- (bool) isRunning
{
    UserPanelStateQuery* query = [[UserPanelStateQuery alloc] init];
    [query execute:controlChannel];
    return [query isRunning];
}

#pragma mark Configuration

-(void) unlockRegFile
{
    SetRegFile* command = [[SetRegFile alloc] initWithCommand:0x80];
    [command execute:controlChannel];
}

-(void) disableWriteAndSave
{
    SetRegFile* command = [[SetRegFile alloc] initWithCommand:0x06];
    [command execute:controlChannel];
}

-(int) getCameraId
{
    return [self getParameter:@"confFd.bConfCameraType"];
}

- (CameraMode)getCameraMode
{
    SInt32 mode = [self getParameter:@"bStatusCameraMode"];
    mode = mode & 0x3;
    
    CameraMode cm = (mode & 0x3) == 0 ? Reading: Distance;
    return cm;
}

- (NSMutableArray*) getColorPairs
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    for(int i = 0 ; i < 6 ; i++)
    {
        ColorPair* pair = [self getColorPair:i];
        if(pair.negative || pair.positive)
        {
            [res addObject:pair];
        }
    }
    
    return res;
}

- (ColorPair*)getColorPair:(int)palette
{
    ColorPair* pair = [[ColorPair alloc] init];
    
    ColorPairQuery* query = [[ColorPairQuery alloc] initWithPalette:2*palette+1];
    [query execute:controlChannel];
    [pair setPositive:[query type] != Unused];
    [pair setBackColor:[query backColor]];
    [pair setForeColor:[query foreColor]];
    
    ColorPairQuery* query2 = [[ColorPairQuery alloc] initWithPalette:2*palette+2];
    [query2 execute:controlChannel];
    [pair setNegative:[query2 type] != Unused];
    
    return pair;
}

- (void) setColorPair:(int)palette withColors:(ColorPair*)pair
{
    ColorPaletteType typ = Unused;
    if(pair.positive)
        typ = Positive;
    int pal = palette*2+1;
    
    ColorPairCommand* command = [[ColorPairCommand alloc] initWithPalette:pal andType:typ andForeColor:pair.foreColor andBackColor:pair.backColor];
    [command execute:controlChannel];
    
    typ = Unused;
    if(pair.negative)
        typ = Negative;
    pal = palette*2+2;

    command = [[ColorPairCommand alloc] initWithPalette:pal andType:typ andForeColor:pair.backColor andBackColor:pair.foreColor];
    [command execute:controlChannel];
    
    if(mRefColorChanged == false){
        
        SInt32 color1 = [self intFromColor:[pair foreColor]];
        SInt32 color2 = [self intFromColor:[pair backColor]];

        NSString* name = [NSString stringWithFormat:@"confUd.colorPalette[%d].wConfColRefLine",palette*2+1];
        [self setParameter:name withData:color1];
        
        name = [NSString stringWithFormat:@"confUd.colorPalette[%d].wConfColRefLine",palette*2+2];
        [self setParameter:name withData:color2];
    }
}

- (ActivatedFunctions) getLineAndCurtain
{
    ActivatedFunctionsQuery *query = [[ActivatedFunctionsQuery alloc] init];
    [query execute:controlChannel];
    return [query getActivatedFunctions];
}

- (void) setLineAndCurtain:(ActivatedFunctions)value
{
    ActivatedFunctionsQuery *query = [[ActivatedFunctionsQuery alloc] init];
    [query execute:controlChannel];
    
    uint8 val = [query getVal];
    switch (value)
    {
        case LineActive:
            val = val | 0x4;
            val = val & ~(uint)0x8;
            break;
        case CurtainActive:
            val = val & ~(uint)0x4;
            val = val | 0x8;
            break;
        case BothActive:
            if ((val & 0x4) != 0)
                value = CurtainActive;
            else if ((val & 0x8) != 0)
                value = LineActive;
            val = val | 0xC;
            break;
    }
    
    ActivatedFunctionsCommand *command = [[ActivatedFunctionsCommand alloc] initWithCommand:val andLength:1];
    
    [command execute:controlChannel];
    
    ReferenceLineOrientationQuery* rquery = [[ReferenceLineOrientationQuery alloc] init];
    [rquery execute:controlChannel];
    val = [rquery getVal];
    
    if(value == LineActive){
        val = val & ~(uint)0x4;
    }
    else if(value == CurtainActive){
        val = val | 0x4;
    }
    
    SetControlReferenceLineOrientation *rcommand = [[SetControlReferenceLineOrientation alloc] initWithVal:val];
    [rcommand execute:controlChannel];
    
    ReferenceLineQuery* rlq = [[ReferenceLineQuery alloc] init];
    [rlq execute:controlChannel];
    uint16 pos = [rlq getRefLinePosition];
    
    SetControlReferenceLine *scfl = [[SetControlReferenceLine alloc] initWithPosition:pos];
    [scfl execute:controlChannel];
    
    SetReferenceLine *lcommand = [[SetReferenceLine alloc] initWithCommand:SetReferenceLine_GotoPosition];
    [lcommand execute:controlChannel];
}

- (bool) hasGrayscale
{
    ColorPairQuery* query = [[ColorPairQuery alloc] initWithPalette:Palette_15];
    [query execute:controlChannel];
    return [query type] != Unused;
}

- (void) setGrayscale:(bool)enable
{
    uint pal = 0;
    NSString* p_name = @"confUd.colorPalette[15].wConfColorGroup";
    if (enable)
    {
        [self setParameter:p_name withData:0x4000];
        p_name = @"confUd.colorPalette[15].wConfArtColPoint1";
        [self setParameter:p_name withData:0x1];
        [self setParameter:@"confUd.colorPalette[15].wConfArtColPoint4" withData:0x00];
    }
    else
    {
        pal = 0;
        [self setParameter:p_name withData:0x0000];
    }
    uint bits = 0x90;
    [self setParameter:@"wCntrlCurrentColorPal" withData:pal];
    [self setParameter:@"wCmdColorPal" withData:bits];

    bits = 0x82;
    [self setParameter:@"wCmdColorPal" withData:bits];
}

- (int) getReferenceLineWidth
{
    return [self getParameter:@"confUd.wConfReferenceLineWidth"];
}

- (void) setReferenceLineWidth:(int)width
{
    [self setParameter:@"confUd.wConfReferenceLineWidth" withData:width];
}

- (NSColor*) colorFromInt:(SInt32)col;
{
    float r = ((col & 0xFF00) >> 8) / 255.0;
    float g = ((col & 0xFF0000) >> 16) / 255.0;
    float b = ((col & 0xFF000000) >> 24) / 255.0;
    return [NSColor colorWithRed:r green:g blue:b alpha:1.0];
}

- (SInt32) intFromColor:(NSColor*)col;
{
    SInt32 res = 0;
    int r = [col redComponent] * 255;
    int g = [col greenComponent] * 255;
    int b = [col blueComponent] * 255;

    res = r << 8;
    res = res | g << 16;
    res = res | b << 24;
    return res;
}

- (NSColor*) getGuidingLineColor:(int)palette
{
    NSString* name = [NSString stringWithFormat:@"confUd.colorPalette[%d].wConfColRefLine",palette];
    SInt32 col = [self getParameter:name];
    return [self colorFromInt:col];
}

- (void) setGuidingLineColor:(NSColor*)color forPalette:(int)palette
{
    NSString* name = [NSString stringWithFormat:@"confUd.colorPalette[%d].wConfColRefLine",palette];
    SInt32 data = [self intFromColor:color];
    [self setParameter:name withData:data];
}

- (void) setGuidingLineColor:(NSColor*)color
{
    SInt32 icol = [self intFromColor:color];
    for (int i = Palette_0; i < Palette_Numbers; i++)
    {
        //Dont touch palette 13 and 14
        if (i == Palette_13 || i == Palette_14)
            continue;
        NSString* name = [NSString stringWithFormat:@"confUd.colorPalette[%d].wConfColRefLine",i];
        [self setParameter:name withData:icol];
    }
    //The following code is needed to get an immediate update of the color
    [self updatePn];
    mRefColorChanged = true;
}

- (void) setGuidingLinesSamaAsText
{
    [self setGuidingLineColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:1.0] forPalette:Palette_0];
    [self setGuidingLineColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:1.0] forPalette:Palette_15];
    for(int i = Palette_1 ; i < Palette_15 ; i++)
    {
        NSString* name = [NSString stringWithFormat:@"confUd.colorPalette[%d].wConfArtColPoint1",i];
        SInt32 val = [self getParameter:name];
        name = [NSString stringWithFormat:@"confUd.colorPalette[%d].wConfColRefLine",i];
        [self setParameter:name withData:val];
    }
    mRefColorChanged = false;
    [self updatePn];
}

-(void) updatePn
{
    SInt32 pal = [self getParameter:@"wStatusCurrentColorPal"];
    pal = pal & 0xF;
    [self setParameter:@"wCntrlCurrentColorPal" withData:pal];
    uint cBits = 0x90;
    [self setParameter:@"wCmdColorPal" withData:cBits];
    //mColorPal = 20;
}

- (bool) hasGuidingLineChanged
{
    NSColor *c1 = [self getGuidingLineColor:1];
    NSColor *c2 = [self getGuidingLineColor:2];
    if([c1 isEqual:c2]){
        mRefColorChanged = true;
    }
    
    return mRefColorChanged;
}

- (void) setMinZoom:(int)value
{
    //mMinZoom = value;
    NSString* name = @"confUdCameraMode[0].confCamera.wConfCameraZoomMin";
    [self updateCameraCommand:name withData:value andTrigger:0xC];
    name = @"confUdCameraMode[1].confCamera.wConfCameraZoomMin";
    [self updateCameraCommand:name withData:value andTrigger:0xC];
}

- (void) setMaxZoom:(int)value
{
    NSString* name = @"confUdCameraMode[0].confCamera.wConfCameraZoomMax";
    [self updateCameraCommand:name withData:value andTrigger:0xD];
    name = @"confUdCameraMode[1].confCamera.wConfCameraZoomMax";
    [self updateCameraCommand:name withData:value andTrigger:0xD];
}

- (int) getMinZoom
{
//    if (mMinZoom != -1)
//        return mMinZoom;
    NSString* name = @"confUdCameraMode[0].confCamera.wConfCameraZoomMin";
    uint value = [self getParameter:name];
    return value;
//    mMinZoom = (int)value;
//    return mMinZoom;
}

- (int) getMaxZoom
{
    NSString* name = @"confUdCameraMode[0].confCamera.wConfCameraZoomMax";
    uint value = [self getParameter:name];
    return value;
}

- (void) updateCameraCommand:(NSString*)regName withData:(SInt32)val andTrigger:(int)bitNr
{
    [self setParameter:regName withData:val];
    UInt16 bits = [self getParameter:@"wCmdCameraUpdate"];
    UInt16 c = (uint)(bits & (1 << bitNr));
    if (c != 0)
    {
        sleep(0.02);
        bits = [self getParameter:@"wCmdCameraUpdate"];
    }
    bits = bits | (uint)(1 << bitNr);
    [self setParameter:@"wCmdCameraUpdate" withData:bits ];
}

- (int) getLight
{
    SInt32 res = [self getParameter:@"confFd.bGeneralProductConfigArea[3]"];
    return res;
}

- (void) setLight:(int)value
{
    [self setParameter:@"confFd.bGeneralProductConfigArea[3]" withData:value];
}

#pragma mark Camera Natural Colors

- (int) getCameraShutterTimeNaturalColors
{
    return [self getParameter:@"confFd.wConfCameraShutterTimeNaturalColors"];
}

- (void) setCameraShutterTimeNaturalColors:(int)value
{
    NSString* name = @"confFd.wConfCameraShutterTimeNaturalColors";
    [self updateCameraCommand:name withData:value andTrigger:0x0];
}

- (int) getCameraExposureNaturalColors
{
    return [self getParameter:@"confFd.sbConfCameraExposureCompensationNaturalColors"];
}

- (void) setCameraExposureNaturalColors:(int)value
{
    NSString* name = @"confFd.sbConfCameraExposureCompensationNaturalColors";
    [self updateCameraCommand:name withData:value andTrigger:0x6];
}

- (int) getCameraApertureNaturalColors
{
    return [self getParameter:@"confFd.bConfCameraGainPeakNaturalColors"];
}

- (void) setCameraApertureNaturalColors:(int)value
{
    NSString* name = @"confFd.bConfCameraGainPeakNaturalColors";
    [self updateCameraCommand:name withData:value andTrigger:0x8];
}

- (int) getCameraRGain
{
    return [self getParameter:@"confFd.bConfCameraRGain"];
}

- (void) setCameraRGain:(int)value
{
    NSString* name = @"confFd.bConfCameraRGain";
    [self updateCameraCommand:name withData:value andTrigger:0xA];
}

- (int) getCameraBGain
{
    return [self getParameter:@"confFd.bConfCameraBGain"];
}

- (void) setCameraBGain:(int)value
{
    NSString* name = @"confFd.bConfCameraBGain";
    [self updateCameraCommand:name withData:value andTrigger:0xB];
}

- (ExposureMode)getCameraExposureMode:(PnMode)pnMode and:(CameraMode)camMode
{
    int cmode = camMode == Reading ? 0 : 1;
    NSString* str_pn_mode = (pnMode == PnNatural) ? @"Natural" : @"Artificial";
    NSString* name = [NSString stringWithFormat:@"confUdCameraMode[%d].confCamera.wConfCameraExposure%@Colors", cmode,str_pn_mode];
    SInt32 mode = [self getParameter:name];
    return (ExposureMode)mode;
}

- (void) setCameraExposureMode:(ExposureMode)expMode for:(PnMode)pnMode and:(CameraMode)camMode
{
    int cmode = camMode == Reading ? 0 : 1;
    NSString* str_pn_mode = (pnMode == PnNatural) ? @"Natural" : @"Artificial";
    NSString* name = [NSString stringWithFormat:@"confUdCameraMode[%d].confCamera.wConfCameraExposure%@Colors", cmode,str_pn_mode];
    [self updateCameraCommand:name withData:expMode andTrigger:0xE + pnMode];
}

#pragma mark Camera Artificial Colors
- (int) getCameraShutterTimeArtificialColors
{
    return [self getParameter:@"confFd.wConfCameraShutterTimeArtificialColors"];
}

- (void) setCameraShutterTimeArtificialColors:(int)value
{
    NSString* name = @"confFd.wConfCameraShutterTimeArtificialColors";
    [self updateCameraCommand:name withData:value andTrigger:0x1];
}

- (int) getCameraExposureArtificialColors
{
    return [self getParameter:@"confFd.sbConfCameraExposureCompensationArtificialColors"];
}

- (void) setCameraExposureArtificialColors:(int)value
{
    NSString* name = @"confFd.sbConfCameraExposureCompensationArtificialColors";
    [self updateCameraCommand:name withData:value andTrigger:0x7];
}

- (int) getCameraApertureArtificialColors
{
    return [self getParameter:@"confFd.bConfCameraGainPeakArtificialColors"];
}

- (void) setCameraApertureArtificialColors:(int)value
{
    NSString* name = @"confFd.bConfCameraGainPeakArtificialColors";
    [self updateCameraCommand:name withData:value andTrigger:0x8];
}

#pragma mark Monitor Natural Colors
- (MyColor) getMonitorColorTempFor:(CameraMode)mode
{
    int cm = mode == Reading ? 0: 1;
    NSString* redStr = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bColorTempR",cm];
    NSString* greenStr = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bColorTempG",cm];
    NSString* blueStr = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bColorTempB",cm];

    SInt32 red = [self getParameter:redStr];
    SInt32 green = [self getParameter:greenStr];
    SInt32 blue = [self getParameter:blueStr];

    return MyMakeColor(red, green, blue);
}

- (void) setMonitorColorTemp:(MyColor)value for:(CameraMode)mode
{
    int cm = mode == Reading ? 0: 1;
    NSString* redStr = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bColorTempR",cm];
    NSString* greenStr = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bColorTempG",cm];
    NSString* blueStr = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bColorTempB",cm];

    [self setParameter:redStr withData:value.red];
    [self setParameter:greenStr withData:value.green];
    [self setParameter:blueStr withData:value.blue];
}

-(MyRange) getMonitorBrightnessFor:(CameraMode)mode andGrayscale:(bool)grayscale
{
    if(grayscale == false)
    {
        int cm = mode == Reading ? 0: 1;
        NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorBrightnessDefaultNaturalColor",cm];
        SInt32 def = [self getParameter:str];
        str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorBrightnessCoficientNaturalColor",cm];
        SInt32 cof = [self getParameter:str];
        
        return MyMakeRange(def-cof, def);
    }
    else{
        NSString* str = @"confUd.colorPalette[15].wConfArtColPoint2";
        SInt32 val = [self getParameter:str];
        SInt32 cof = (val & 0xFF00) >> 8;
        SInt32 def = (val & 0x00FF);
        return MyMakeRange(def-cof, def);
    }
}

-(void) setMonitorBrightness:(MyRange)range for:(CameraMode)mode andGrayscale:(bool)grayscale
{
    if(grayscale == false)
    {
        int cm = mode == Reading ? 0: 1;
        NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorBrightnessDefaultNaturalColor",cm];
        [self setParameter:str withData:range.max];
        str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorBrightnessCoficientNaturalColor",cm];
        [self setParameter:str withData:range.max - range.min];
    }
    else{
        SInt32 cof = range.max - range.min;
        SInt32 def = range.max;
        SInt32 value = (cof << 8) | def;
        NSString* str = @"confUd.colorPalette[15].wConfArtColPoint2";
        [self setParameter:str withData:value];
    }
    
    const SInt32 cTrigger_bits = 0x88;
    SInt32 pn = [self getParameter:@"bStatusNaturalPnBrightness"];
    [self setParameter:@"wCntrlCurrentPnBrightness" withData:pn];
    [self setParameter:@"wCmdPnBrightness" withData:cTrigger_bits];
}

-(MyRange) getMonitorContrastFor:(CameraMode)mode andGrayscale:(bool)grayscale
{
        if(grayscale == false)
    {
        int cm = mode == Reading ? 0: 1;
        NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorContrastDefaultNaturalColor",cm];
        SInt32 def = [self getParameter:str];
        str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorContrastCoficientNaturalColor",cm];
        SInt32 cof = [self getParameter:str];
        
        return MyMakeRange(def-cof, def);
    }
    else{
        NSString* str = @"confUd.colorPalette[15].wConfArtColPoint3";
        SInt32 val = [self getParameter:str];
        SInt32 cof = (val & 0xFF00) >> 8;
        SInt32 def = (val & 0x00FF);
        return MyMakeRange(def-cof, def);
    }
}

-(void) setMonitorContrast:(MyRange)range for:(CameraMode)mode andGrayscale:(bool)grayscale
{
    if(grayscale == false)
    {
        int cm = mode == Reading ? 0: 1;
        NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorContrastDefaultNaturalColor",cm];
        [self setParameter:str withData:range.max];
        str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorContrastCoficientNaturalColor",cm];
        [self setParameter:str withData:range.max - range.min];
    }
    else{
        SInt32 cof = range.max - range.min;
        SInt32 def = range.max;
        SInt32 value = (cof << 8) | def;
        NSString* str = @"confUd.colorPalette[15].wConfArtColPoint3";
        [self setParameter:str withData:value];
    }
    const SInt32 cTrigger_bits = 0x88;
    SInt32 pn = [self getParameter:@"bStatusNaturalPnBrightness"];
    [self setParameter:@"wCntrlCurrentPnBrightness" withData:pn];
    [self setParameter:@"wCmdPnBrightness" withData:cTrigger_bits];
}

-(MyRange) getMonitorColorFor:(CameraMode)mode
{
    int cm = mode == Reading ? 0: 1;
    NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorColorDefaultNaturalColor",cm];
    SInt32 def = [self getParameter:str];
    str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorColorCoficientNaturalColor",cm];
    SInt32 cof = [self getParameter:str];
    
    return MyMakeRange(def-cof, def);
}

-(void) setMonitorColor:(MyRange)range for:(CameraMode)mode
{
    int cm = mode == Reading ? 0: 1;
    NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorColorDefaultNaturalColor",cm];
    [self setParameter:str withData:range.max];
    str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorColorCoficientNaturalColor",cm];
    [self setParameter:str withData:range.max - range.min];
    
    const SInt32 cTrigger_bits = 0x88;
    SInt32 pn = [self getParameter:@"bStatusNaturalPnBrightness"];
    [self setParameter:@"wCntrlCurrentPnBrightness" withData:pn];
    [self setParameter:@"wCmdPnBrightness" withData:cTrigger_bits];
}

#pragma mark Monitor Artificial Colors

-(MyRange) getMonitorAutoPnFor:(CameraMode)mode
{
    int cm = mode == Reading ? 0: 1;
    NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bAutoPnMin",cm];
    SInt32 min = [self getParameter:str];
    str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bAutoPnMax",cm];
    SInt32 max = [self getParameter:str];
    
    return MyMakeRange(min, max);
}

-(void) setMonitorAutoPn:(MyRange)range for:(CameraMode)mode
{
    int cm = mode == Reading ? 0: 1;
    NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bAutoPnMin",cm];
    [self setParameter:str withData:range.min];
    str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bAutoPnMax",cm];
    [self setParameter:str withData:range.max];
}

-(int) getMonitorContrastArtificialFor:(CameraMode)mode
{
    int cm = mode == Reading ? 0: 1;
    NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorContrastArtificalColor",cm];
    SInt32 val = [self getParameter:str];
    return val;
}

-(void) setMonitorContrastArtificial:(int)value for:(CameraMode)mode
{
    int cm = mode == Reading ? 0: 1;
    NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorContrastArtificalColor",cm];
    [self setParameter:str withData:value];
    
    [self updatePn];
}

-(int) getMonitorBrightnessArtificialFor:(CameraMode)mode
{
    int cm = mode == Reading ? 0: 1;
    NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorBrightnessArtificalColor",cm];
    SInt32 val = [self getParameter:str];
    return val;
}

-(void) setMonitorBrightnessArtificial:(int)value for:(CameraMode)mode
{
    int cm = mode == Reading ? 0: 1;
    NSString* str = [NSString stringWithFormat:@"confUdCameraMode[%d].confMonitor.bConfMonitorBrightnessArtificalColor",cm];
    [self setParameter:str withData:value];
    
    [self updatePn];
}

-(int) getPnStartLevel
{
    NSString* str = @"confFd.bGeneralProductConfigArea[4]";
    SInt32 val = [self getParameter:str];
    return val;
}

-(void) setPnStartLevel:(int)value
{
    NSString* str = @"confFd.bGeneralProductConfigArea[4]";
    [self setParameter:str withData:value];
}

@end
