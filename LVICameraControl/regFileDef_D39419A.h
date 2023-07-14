
// REG_FILE_DEF:  V3

#ifndef __REGFILEDEF_H__
#define __REGFILEDEF_H__

  //typedef unsigned int size_t;
  //#define offsetof(s,m)   (size_t)&(((s *)0)->m)

  // Typedefs used in register-file.
  typedef unsigned char byte;
  typedef signed char sbyte;
  typedef unsigned short word;
  typedef signed short sword;
  typedef unsigned int dword;

// #define REG_FILE_SIZE 2108
 
#define mytype static

// Used to get "expanded" registerfile, all apps are not ready for this yet.

#ifdef __cplusplus
  namespace RegFileD39419A
  {
#endif // __cplusplus

#define REG_FILE_VIDEO_PALETTS_MAX 8
#define REG_FILE_COLOR_PALETTS_MAX 16
#define REG_FILE_BATTERY_CONFIGURATIONS_MAX 4

typedef union ErrorRegStruct
{
  dword complete;
  byte partial[4];
} errorRegStruct; 

typedef struct ColorConfigurationStruct
{
  word wConfColorGroup;                     // WR, Configuration register for colors.         
  word wNotUsed;                            // Padding.

  dword wConfArtColPoint1;                  // WR, Configuration register for artificiel color point 1.

  dword wConfArtColPoint2;                  // WR, Configuration register for artificiel color point 2.

  dword wConfArtColPoint3;                  // WR, Configuration register for artificiel color point 3.

  dword wConfArtColPoint4;                  // WR, Configuration register for artificiel color point 4.

  dword wConfColCameraBackground;           // WR, Configuration register for camera color background.

  dword wConfColRefLine;                    // WR, Configuration register for ref-line color.

  dword wConfColUndefined;                  // WR, Reserved configuration register.

} colorConfiguration;

typedef struct BatteryConfigurationStruct
{
                                              
  byte strConfBatteryType[8];                 // WR, Configuration register for battery type.

  word wConfBatteryNominellCapacity;          // TODO  // WR, Configuration register for nominell (new) battery capacity.
  word wConfBatteryTempCoficientCapacity;     // TODO  // WR, Configuration register for capacity temp coficient.
  
  word wConfBatteryAgeCoficientCapacity;      // TODO  // WR, Configuration register for capacity age coficient.
  word wConfBatteryLowCapacityLimit;          // TODO  // WR, Configuration register for low-capacity alarm limit.

  word wConfBatteryVoltageDisconnectLimit;    // TODO  // WR, Configuration register for low voltage limit when battery will be disconnected.
  word wConfBatteryNotUsed;                         // padding.
  
  dword dwReserved;                           // Spare.   
} batteryConfigurationStruct;


typedef struct StatusStructCm
{
  word wStatusCamera;         // OPTION       // RO, Status register for camera.
  word wStatusCameraFocus;    // OPTION       // RO, Status register for focus.

  word wStatusCameraFocusPosition; // OPTION  // RO, Status register for focus position.
  word wStatusCameraZoomPosition;             // RO, Status register for zoom-position.

  word wStatusCameraExposure; // OPTION       // RO, Status register for exposure.
  word wStatusCameraShutterTime;// OPTION     // RO, Status register for shutter time.

  word wStatusCameraWhiteBalance;// OPTION    // RO, Status register for white balance.
  word wStatusCurrentColorPal;					      // RO, Current selected palette info.

  word wStatusAllColorPal;                    // RO, Selected palette for each group.
  word wStatusCurrentPnBrightness;            // RO, Current PN/Brightness used.

  word wStatusReferenceLinesOrientation;      // RO, Status register for placement of reference-lines.   
  byte bStatusCameraZoom;     // OPTION       // RO, Status register for zoom.
  byte bStatusCameraBrightness;// OPTION      // RO, Status register for brightness.

  sword swStatusReferenceLine1Position;       // RO, Status register for reference-line 1.
  sword swStatusReferenceLine2Position;       // OPTION     // RO, Status register for reference-line 2.

  byte bStatusCameraIris;      // OPTION      // RO, Status register for Iris (bländare??).
  byte bStatusCameraRGain;      // OPTION     // RO, Status register for R-gain.
  byte bStatusCameraBGain;      // OPTION     // RO, Status register for B-gain. 
  byte bStatusNaturalPnBrightness;            // RO, Brightness for natural colors.

  byte bStatusPosArtPnBrightness;             // RO, Pn-level for positive art colors.
  byte bStatusNegArtPnBrightness;             // RO, Pn-level for negative art colors.
  byte bStatusShownObjects;   // OPTION     // RO, Status register for shown objects.
  byte bNotUsed;

  dword dwStatusCameraPanTilt;		// RO, Status register for camera PanTilt. NEW: LE-110310
  //dword dwReserved1;    	// Replaced 
  dword dwReserved2;        	// Spare.
} statusStructCm;

typedef struct VideoGenStruct
{
  word wConfVideoGen;                                   // WR, Configuration register for video generating.
  word wConfVideoUsbPixel;                              // OPTION WR, Configuration register for usb-video pixel.
  
  word wConfVideoUsbHeader;                             // OPTION// WR, Configuration register for usb-video header.
  word wConfVideoLinesPerFrame;                         // WR, Configuration register for number of lines in one frame.
  
  byte bConfVideoVerticalSyncLength;                    // WR, Configuration register for vertical sync length.
  byte bConfVideoEqualizationPulses;                    // WR, Configuration register for equalization pulses.        
  word wConfVideoHorizontalLengthOfVerticalSync;        // WR, Configuration register for horizontal length of vertical sync.
  
  word wConfVideoHorizontalLengthOfEqualizationPulses;  // WR, Configuration register for horizontal length of equalization-pulses.
  word wConfVideoFirstActiveLine;                       // WR, Configuration register for first active line.
  
  word wConfVideoLinesActiveinCompletePicture;          // WR, Configuration register for total number of lines in a complete frame (picture).
  word wConfVideoHorizontalTotalLength;                 // WR, Configuration register for total lenght of a horizontal line.
  
  word wConfVideoHorizontalSyncLength;                  // WR, Configuration register for lenght of a horizontal sync.
  word wConfVideoColorBurstStart;                       // WR, Configuration register for start of color burst.
  
  dword dwConfVideoColorCarrierPhaseIncrement;          // WR, Configuration register for color carriers phase increment.
  
  word wConfVideoColorBurstLength;                      // WR, Configuration register for length of color burst.
  word wConfVideoHorizontalActiveVideoStart;            // WR, Configuration register for start of horizontal active video.
  
  word wConfVideoHorizontalActiveVideoLength;           // WR, Configuration register for length of horizontal active video.
  byte bConfVideoVoltageDac;                            // WR, Configuration register for DAC-voltage.
  byte bConfVideoAmplitudeY;                            // WR, Configuration register for Y-amplitude.
  
  byte bConfVideoAmplitudeU;                            // WR, Configuration register for U-amplitude.
  byte bConfVideoAmplitudeV;                            // WR, Configuration register for V-amplitude.
  byte bConfVideoAmplitudeBurst;                        // WR, Configuration register for Burst-amplitude.
  byte bConfVideoSyncLevel;                             // WR, Configuration register for Sync-level.
  
  byte bConfVideoBlankingLevel;                         // WR, Configuration register for Blanking-level.
  byte bConfVideoSyncRgb;                               // WR, Configuration register for Sync and RGB-out.
  word wConfVideoAspectRatio;                           // WR, Configuration register for aspect ratio of physical monitor.        
  
  dword wConfVideoFilter;                               // OPTION // WR, Configuration register for video filter.

  dword dwReserved1;                           // Spare.
  dword dwReserved2;                           // Spare.   
} videoGenStruct;

typedef struct ConfStructFactory
{
                                                  
  byte bConfUsbInterface;                         // OPTION // WR, Configuration register for USB-interface.
  byte bConfCameraType;	                          // WR, Configuration register for camera type.
  byte bConfCameraRGain;                          // OPTION     // WR, Configuration register for R-gain.
  byte bConfCameraBGain;                          // OPTION     // WR, Configuration register for B-gain.  
  
  dword dwConfActivatedFunctions1;                // OPTION // WR, Configuration register for activated functions.
   
  dword dwConfActivatedFunctions2;                // OPTION // WR, Configuration register for activated functions.
  
  byte bConfHysteresCurrentLimit;                 // TODO  // WR, Configuration register for hysteres for switching loading of battery on/off from PC.
  byte bConfAdditionalCurrentLimit;               // TODO  // WR, Configuration register for limit when additional current shall be added from battery.
  word wConfUsbHubVoltageShutdown;                // TODO  // WR, Configuration register for voltage when usb and hub shall be shut down. 
  
  word wConfVoltageLimitCurrentDrainFromUsb;      // TODO  // WR, Configuration register for voltage-limit for draining current from Usb.
  word wConfVoltageLimitUsbOperation;             // TODO  // WR, Configuration register for voltage-limit at usb-operation.
  
  word wConfVoltageLimitUsbStartup;               // TODO  // WR, Configuration register for voltage-limit at usb-startup.
  word wConfVoltageLimitVvRailStartup;            // TODO  // WR, Configuration register for voltage-limit at VV-rail startup.
  
  word wConfVoltageVvRailVideoStandby;            // TODO  // WR, Configuration register for video standby voltage at VV-rail.
  word wConfVoltageVvRailVideoShow;               // TODO  // WR, Configuration register for video show voltage at VV-rail.  
    
  word wConfCameraFirstLine;		         		      // WR, Configuration register for first usable line from camera.
  word wConfCameraUsableLines;        			      // WR, Configuration register for number of usable lines from camera.
    
  word wConfCameraFirstPixel;		      			      // WR, Configuration register for number of first usable pixel from camera.
  word wConfCameraUsablePixels;	      			      // WR, Configuration register for number of usable pixels from camera.
  
  word wConfCameraUsableRatio;        	    			// WR, Configuration register for camera usable ratio (width/hight).
  word wConfCameraInterface;	                    // OPTION		// WR, Configuration register for camera interface.
  
  word wConfCameraZoom; 	                        // OPTION		// WR, Configuration register for zoom.
  word wConfCameraShutterTimeNaturalColors;       // OPTION   // WR, Configuration register for shutter time in natural colors.
  
  byte bConfCameraBrightnessNaturalColors;        // OPTION      // WR, Configuration register for brightness in natural colors.
  byte bConfCameraBrightnessArtificialColors;     // OPTION      // WR, Configuration register for brightness in artificial colors.  
  byte bConfCameraIrisNaturalColors;              // OPTION      // WR, Configuration register for Iris in natural colors.
  byte bConfCameraIrisArtificialColors;           // OPTION      // WR, Configuration register for Iris in artificial colors.  
  
  sbyte sbConfCameraExposureCompensationNaturalColors; // OPTION // WR, Configuration register for exposure compensation with natural colors.
  sbyte sbConfCameraExposureCompensationArtificialColors; // OPTION // WR, Configuration register for exposure compensation with artificial colors.  
  byte bConfCameraBrightnessMaxNaturalColors;     // OPTION      // WR, Configuration register for max brightness in natural colors.
  byte bConfCameraBrightnessMaxArtificialColors;  // OPTION  // WR, Configuration register for max brightness in artificial colors.
  
  byte bConfCameraBrightnessMinNaturalColors;     // OPTION      // WR, Configuration register for min brightness in natural colors.
  byte bConfCameraBrightnessMinArtificialColors;  // OPTION     // WR, Configuration register for min brightness in artificial colors.
  byte bConfCameraGainPeakNaturalColors;          // OPTION      // WR, Configuration register for gain peak in natural colors.
  byte bConfCameraGainPeakArtificialColors;       // OPTION  // WR, Configuration register for gain peak in artificial colors.

  word wConfCameraShutterTimeArtificialColors;    // OPTION  // WR, Configuration register for shutter time in artificial colors.
  word confNotUsed;                                     // Padding
      
  // Size 12*4 = 48
  batteryConfigurationStruct confBattery[REG_FILE_BATTERY_CONFIGURATIONS_MAX];  // TODO // WR, Configuration registers for Battery. 

  // Size 48*8 = 384
  videoGenStruct confVideoGen[REG_FILE_VIDEO_PALETTS_MAX];  // TODO       // WR, Configurations for generated video-mode.

  // Size 12*8 = 96
  // confStructMonitor confMonitor[4];                 // WR, Configurations for monitor.
  
// Will be mapped as "byte strConfFactoryDefaultVersion[8]"   
  // dword dwReserved1;                           // Spare.
  // dword dwReserved2;                           // Spare.
  byte strConfFactoryDefaultVersion[8];               // Version tag of last factory-default configuration.


  dword dwConfProductId;                      // NEW.
  byte str16ConfLicenseKey1[16];                // NEW.
  // byte arr16ConfLicenseKey2[16];                // NEW.
  byte arr16ConfLicenseKey3[16];                // NEW.

  byte bGeneralProductConfigArea[16];          // ? 

  dword dwConfUpRightLimit;  						  // Register for camera PanTilt Up/Right Limits. NEW: LE-110310
  dword dwConfDnLeftLimit;							  // Register for camera PanTilt Dn/left Limits. NEW: LE-110310
  dword dwReserved3;                           // Spare.
} confStructFactory;

typedef struct StatusStructFactory
{
  byte strStatusSerialnumber[8];// OPTION     // RO, Status register product serial number.
} statusStructFactory;

typedef struct ConfStructUser
{
  word wConfBattery;                                  // TODO       // WR, Configuration register for battery.

  word wConfVideoPaletteSelection;                    // WR, Configuration register video-palettes for usb, tv and monitor-modes.
  
  // NEW, alternative default video-palettes.
  word wConfVideoAlt2PaletteSelection;                // WR, 5.12.1.4 Configuration register video-palettes for usb, tv and monitor-modes.
  word wConfVideoAlt3PaletteSelection;                // WR, 5.12.1.4 Configuration register video-palettes for usb, tv and monitor-modes.

  word wConfReferenceLineWidth;                       // WR, Configuration register for width of reference-lines.
  byte bConfPnHighSpeedDelay;                         // OPTION // WR, Configuration register for PN-delay to high-speed.
  byte bConfPnLowSpeed;								                // WR, Configuration register for PN low-speed.

  byte bConfPnHighSpeed;								              // OPTION // WR, Configuration register for PN high-speed.
  byte bConfReferenceLineLowSpeed;                    // WR, Configuration register for low-speed of reference-lines.
  word wConfCameraMemory;                             // OPTION       // WR, Configuration register for camera memory.  

  byte bConfReferenceLineHighSpeed;                   // WR, Configuration register for high-speed of reference-lines.
  byte bConfReferenceLineHighSpeedDelay;              // WR, Configuration register for reference-lines delay.
  byte bConfReferenceLineSwitchDelay;                 // WR, Configuration register for reference-lines switch delay.
  byte bConfMaxCurrentDrainFromUsb;                   // WR, Configuration register for max current drain from USB.

  colorConfiguration colorPalette[REG_FILE_COLOR_PALETTS_MAX];  // 32*16 = 512
  
  // TODO: REMOVE
  // byte bConfVideoMonitorPalette[REG_FILE_VIDEO_PALETTS_MAX];   // TODO  // WR, Configuration register for moitor palette for selected configuration.

// Will be mapped as "byte strConfUserDefaultVersion[8]"
  // dword dwReserved1;                           // Spare.
  // dword dwReserved2;                           // Spare.
  byte strConfUserDefaultVersion[8];               // Version tag of last user-default configuration.

  // NOTE: Will have Write access enabled, even if adapter not present or "write" enabled (unlocked) for reg-file.
  byte arr16ConfLicenseKey2[16];                 
  
  dword dwReserved1;  
  dword dwReserved2;  
  dword dwReserved3;                           // Spare.   
} confStructUser;


/*
typedef struct CameraMemoryStruct
{
  // statusStructCm statusCm;        
  confStructCm confCm;

} cameraMemoryStruct;
*/

// NEW:
typedef struct ConfigCameraMode
{
  word wConfCameraZoomMax;  	                        // WR, Configuration register for max zoom.
  word wConfCameraZoomMin;  	                        // WR, Configuration register for min zoom.

  word wConfCameraFocus;	                            // OPTION		// WR, Configuration register for focus.
  word wConfCameraFocusSpeed;	                        // OPTION		// WR, Configuration register for focus-speed.  

  word wConfCameraFocusMinRange;	                    // OPTION		// WR, Configuration register for min focus range.
  word wConfCameraFocusMaxRange;	                    // OPTION		// WR, Configuration register for max focus range.
  
  word wConfCameraZoomSpeed;	                        // OPTION		// WR, Configuration register for zoom-speed.
  word wConfCameraExposureNaturalColors;              // OPTION   // WR, Configuration register for exposure with natural colors.

  word wConfCameraExposureArtificialColors;           // OPTION   // WR, Configuration register for exposure with artificial colors.
  word wConfCameraWhiteBalance;                       // OPTION   // WR, Configuration register for white balance.
  
} configCameraMode;

typedef struct ConfigDecoderMode
{
  byte bAgcEnable;
  byte bSpare[3];
} configDecoderMode;

typedef struct ConfigMonitorMode
{
  byte bAutoPnEnable;
  byte bAutoPnMin;
  byte bAutoPnMax;
  byte bColorTempR;                                     // WR, Configuration register for color temp.

  byte bColorTempG;                                     // WR, Configuration register for color temp.
  byte bColorTempB;                                     // WR, Configuration register for color temp.
  word wGammaCorr1;                                     // WR, Configuration register for gamma correction. 

  word wGammaCorr2;                                     // WR, Configuration register for gamma correction.
  word wGammaCorr3;                                     // WR, Configuration register for gamma correction.

  word wGammaCorr4;                                     // WR, Configuration register for gamma correction.
  word wGammaCorr5;                                     // WR, Configuration register for gamma correction.
  
  
  byte bConfMonitorContrastDefaultNaturalColor;  // TODO  // WR, Configuration register for default contrast in natural colors.
  byte bConfMonitorContrastCoficientNaturalColor;// TODO  // WR, Configuration register for contrast coficient in natural colors.
  byte bConfMonitorBrightnessDefaultNaturalColor;  // TODO  // WR, Configuration register for default brightness in natural colors.
  byte bConfMonitorBrightnessCoficientNaturalColor;// TODO  // WR, Configuration register for brightness coficient in natural colors.

  byte bConfMonitorColorDefaultNaturalColor;   // TODO  // WR, Configuration register for default color in natural colors.  
  byte bConfMonitorColorCoficientNaturalColor; // TODO  // WR, Configuration register for color coficient in natural colors.
  byte bConfMonitorHue;                        // TODO  // WR, Configuration register for HUE.
  byte bConfMonitorContrastArtificalColor;     // TODO  // WR, Configuration register for contrast in artificial colors.      

  byte bConfMonitorBrightnessArtificalColor;   // TODO  // WR, Configuration register for brightness in artificial colors.
  byte bConfMonitorTopBlackLines;
  byte bConfMonitorBottomBlackLines;
  byte bSpare;

} configMonitorMode;

typedef struct CameraModeStruct
{
  configCameraMode confCamera;
  configDecoderMode confDecoder;
  configMonitorMode confMonitor;
} cameraModeStruct;

typedef struct UserDefinedStruct
{
  confStructUser conf;
  cameraModeStruct confUdCameraMode[3];           // References to camera, decoder and monitor stuff.
  
} userDefinedStruct;



typedef struct FactoryDefaultStruct
{
  statusStructFactory status;
  confStructFactory conf;
  userDefinedStruct user;
  
} factoryDefaultStruct;

// For PC-apps and CIF, use the following define:
// #define mytype static

// For 8051, use the define of your choice:
// #define mytype static      // Into data segment.
// #define mytype code        // Into code segment.
// #define mytype xdata       // Into xdata segment.
// #define mytype             // Leave it blank.
  
// OK, we are going live with this version...  
   mytype const unsigned char regFileVersion[] = {" D39419A"};
// mytype const unsigned char regFileVersion[] = {"D999905A"}; // Temp, used for software in development

typedef struct RegisterFile
{
  
  // Special purpose status register, ALWAYS located at adress 0.
  byte strStatusVersionRegisterFile[8];// TODO // RO, Status register for register file version.
  
  
  // Input registers, Write Only, write gated with source (PC/UsbDevice or IF (Interface card)).
  byte bInputUsbDevice;       		// TODO   // W-Device, Input register for Usb device controler.
  byte bInputPcApplication;   		// TODO   // W-PC, Input register for PC-application.
  byte bInputBatteryCapacity;      	// TODO   // W-IF, Input register for remaining battery capacity.
  byte bInputInterfaceCard;   		// NOT USED // W-IF, Input register for interface card.
  
  errorRegStruct dwInputErrorDeviceControler;// OPTION  // W-Device, Input register for Device Controler errors.
    
  // These two are NOT mapped to any status-register.
  word wInputPcUsedLines;                 	// W-PC, Input register for no of used lines of pc-application.
  word wInputPcUsedPixels;                	// W-PC, Input register for no of used pixels of pc-application.
  														
  byte strInputVersionPcApplication[8];   	// W-PC, Input register for PC-application program version.

  byte strInputVersionDeviceProgram[8];   	// W-Device, Input register for Device controler program in 8051-cpu.
  
  byte strInputVersionIfBom[8];           	// W-IF, Input register for Interface card Bom.
  
  byte strInputVersionIfProgram[8];       	// W-IF, Input register for Interface card program version.
  
  errorRegStruct dwInputErrorInterfaceCard; 	// OPTION // W-IF, Input register for Interface Card errors.

  byte bInputMaxCurrentDrainFromUsb;        	// W_PC, Input register for max current drain from USB.
  byte notUsed;                             	// Padding.
  word wInputBattery;                       	// W-IF, Input register for battery.

  dword dwInputUserPanelState;					//  LE: 110811	 TTS
  		//dword dwInputReserved1;                           // Spare replaced.
  dword dwInputCameraArea;							//  LE: 120625	 SPLIT
  		//dword dwInputReserved2;                           // Spare. replaced
  dword dwInputReserved3;                           // Spare.   
 
  word notUsed2;                          	// Padding. 
  byte inputRegEnd;                       	// Input reg delimiter.
  byte writeOnlyRegEnd;                   	// Marks end of WRITE-ONLY area.
  
  // Command registers, Read, Write with OR-mask (for triggbits).
  // NOTE: First adress shall be mapped to function regFileCmdStartAdress().
  byte bCmdCifState;                    // W-OR, Command reg for CIF-card.
  byte bCmdRegFile;           // TODO   // W-OR, Command reg for register file.
  byte bCmdUsbInterface;      // TODO   // W-OR, Command reg for USB-interface.
  byte bCmdVideoFrameRateLimit;         // W-OR, Command register for video framerate limits.
  
  word wCmdShownObjects;      // OPTION // W-OR, Command register for shown objects.
  word wCmdCameraFocus;             // OPTION // W-OR, Command register for Focus.
  
  word wCmdCameraZoom;                        // W-OR, Command register for Zoom.
  word wCmdCameraExposure; // OPTION       // W-RO, Command register for exposure.

  word wCmdCameraWhiteBalance;// OPTION    // W-OR, Command register for white balance.
  word wCmdCameraMemory;      // OPTION       // W-OR, Commandoregister for camera memory.
  
  word wCmdVideoGen;                      // W-OR, Command register for video generating.   
  word wCmdColorPal;					            // W-OR, Command register for color palette.
  
  word wCmdPnBrightness;			            // W-OR, Command register for pn/brightness. 
  word wCmdReferenceLines;       // OPTION     // W-OR, Command register for reference-lines.
  
  byte bCmdCameraMode;                      // NEW: Camera mode.

  //LM100120
  byte bCmdCameraUpdate;								// Second update register when config in realtime
  word wCmdCameraUpdate;								// NEW: Update register when config in realtime

  word wCmdCameraPan;									// Reg. för Pan- och Tilt-kommandon samt Pan-positioner NEW: LE-110310
  word wCmdCameraTilt;									// Reg. för Pan- och Tilt-kommandon samt Tilt-positioner NEW: LE-110310
  dword dwCmdReserved3;                         // Spare.   

  word wCmdVideoPaletteUsbSelection;  // OPTION  // W-OR, Command register for USB video palette.
  word cmdRegEnd;                             // Command reg delimiter.
  
  
  // Error registers, Read, Write with "data match" for clear.
  errorRegStruct dwErrorCifInternal;   // OPTION     // RO-W, Error reg for Cif internal errors.

  errorRegStruct dwErrorCifPower;      // OPTION     // RO-W, Error reg for Cif power.

  errorRegStruct dwErrorCifCommands;   // OPTION     // RO-W, Error reg for Cif commands.

  errorRegStruct dwErrorCifExternalCom;// OPTION     // RO-W, Error reg for Cif external communication.

  errorRegStruct dwErrorInterfaceCard; // OPTION     // RO-W, Error reg for Interface Card.

  errorRegStruct dwErrorDeviceControler;// OPTION     // RO-W, Error reg for device Controler.

  dword errorRegEnd;                         // Error reg delimiter.

  
  // Configuration registers, Read, Write is enabled by software (Like factory or customer configurations). 
  // confStructCm confCm;  // TODO: REMOVE

  confStructFactory confFd;                     // Factory default configurations.
 
  confStructUser confUd;                         // User default configurations.

  // NEW: Configuration for camera modes.
  cameraModeStruct confUdCameraMode[3];           // References to camera, decoder and monitor stuff.

  dword confRegEnd;                                     // Configuration reg delimiter.
  
  // Control registers, Read and Write.
  word wCntrlFocusPosition;   // OPTION     // WR, Control reg for focus position.
  word wCntrlZoomPosition;    // OPTION     // WR, Control reg for zoom position.

  // nya register för abulutvärdesstyrning av bildmode, PN-nivå samt referenslinje.. LM
  word wCntrlCurrentColorPal;                         // New and in spec.
  word wCntrlCurrentPnBrightness;                     // New and in spec.
  //dword dwCntrlReserved1;                           // Spare.
  word wCntrlReferenceLinesOrientation;               // New and in spec.
  sword swCntrlReferenceLine1Position;                // New and in spec.
  //dword dwCntrlReserved2;                           // Spare.

  byte bCntrlRegFile;         // TODO       // WR, Control reg for register file.

  byte swCntrlCameraPanTilt[2];						// Control for Pan/Tilt NEW: LE-111028
  //word swCntrlCameraPanTilt;					  	// Control for Pan/Tilt NEW: LE-110310 // Align error
  //byte bCntrlNotUsed[2];              			// Replaced
  byte cntrlRegEnd;                         		// Control reg delimiter.

  // Status registers, Read Only.
  byte bStatusCifPower;       // TODO       // RO, Status of CIF power-supply.
  byte bStatusCifState;       // TODO       // RO, Status of CIF for live-camera (external visibil)
  byte bStatusRegFile;        // TODO       // RO, Status for register file.
  byte bStatusUsbInterface;   // TODO       // RO, Status of USB-Interface.
    
  byte strStatusVersionInterfaceType[8];// TODO // RO, Status register for interface type.

  byte strStatusVersionCifBom[8];// TODO      // RO, Status register for CIF-Bom.

  byte strStatusVersionFpgaProgram[8];// TODO // RO, Status register for FPGA-program.

  byte strStatusVersionCifProgram[8];// TODO  // RO, Status register for CIF-program in ARM-cpu.

  byte strStatusVersionDeviceProgram[8];// TODO// RO, Staus register for Device controler program in 8051-cpu.

  byte strStatusVersionIfBom[8];// TODO       // RO, Status register for Interface card Bom.

  byte strStatusVersionIfProgram[8];// TODO   // RO, Status register for Interface card program version.

  byte strStatusVersionPcApplication[8];// TODO// RO, Status register for PC-application program version.

  word wStatusBattery;        // TODO         // RO, Status register for battery.
  word wStatusVvRailVoltage;  // TODO         // RO, Status register for "required" VV-rail voltage.

  word wStatusCameraMemory;     // OPTION     // RO, Status register for camera memory.    
  word wStatusErrorFlags;     // OPTION     // RO, Status register for error-flags.
  
  word wStatusVideoGen;                           // RO, 
  byte bStatusBatteryCapacity;      // TODO   // RO, Status register for remaining battery capacity.  
  byte bStatusVideoFrameRateLimit;         // RO, Status register for video framerate limits.
  
  word wStatusVideoSkippedFrames;           // RO, Status register for skipped video frames.
  word wStatusVideoPaletteSelection; // OPTION  // WR, Status register video-palettes for usb, tv and monitor-modes.
  
  statusStructFactory statusFd;           // Factory default status.
  
  statusStructCm statusCm;                  // Camera memory status registers.

  byte bStatusCameraMode;                 // NEW: Camera mode (read/write/default).
  byte bStatusInterfaceCard;              // RO, Status register for interface card.
  byte bStatusReserved1[2];
                             // Spare.
  dword dwStatusUserPanelState;				// LE 110831 TTS-reg
  		//dword dwStatusReserved2;                           // Spare. replaced
  dword dwStatusCameraArea;						// LE 120625 Cam-coordlnates
  		//dword dwStatusReserved3;                           // Spare. replaced

  byte bStatusUsbDevice;                    // RO, Status of USB-devicecontroler.
  byte bStatusPcApplication;  // TODO       // RO, Status register for PC-application.
  byte bStatusMaxCurrentDrainFromUsb;        // RO Status register for max current drain from USB.
  
  // Added here, since their size will break the regfile compatibality.  
  byte statusRegEnd;                         // Status reg delimiter.
  
} registerFile; 

#ifdef __cplusplus
} // namespace RegFileD39419A
#endif __cplusplus

#endif  // __REGFILEDEF_H__
