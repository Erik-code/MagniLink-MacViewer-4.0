//
//  GStreamerBackend.h
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-07-13.
//

#import <Foundation/Foundation.h>
#import "GStreamerBackendDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct
{
    int width;
    int height;
    int stride;
    uint8_t* data;
} VideoStruct;

typedef enum {
    AirDistance,
    AirReading,
    AirEthernet,
    AirGrabber,
    AirGrabberEthernet,
} GStreamerType;

@interface GStreamerBackend : NSObject

typedef void (^backendCallbackType)(VideoStruct frame);

@property backendCallbackType backendCallback;

+(void) init_gstreamer;

/* Initialization method. Pass the delegate that will take care of the UI.
 * This delegate must implement the GStreamerBackendDelegate protocol.
 * Pass also the UIView object that will hold the video window. */
-(id) init:(id) uiDelegate andType:(GStreamerType)aType;

-(void)close;

/* Set the pipeline to PLAYING */
-(void) play;

/* Set the pipeline to PAUSED */
-(void) pause;

@end

NS_ASSUME_NONNULL_END
