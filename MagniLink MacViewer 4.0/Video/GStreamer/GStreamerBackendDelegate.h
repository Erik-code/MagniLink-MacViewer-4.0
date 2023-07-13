//
//  GStreamerBackendDelegate.h
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-07-13.
//

#ifndef GStreamerBackendDelegate_h
#define GStreamerBackendDelegate_h

#import <Foundation/Foundation.h>
@class GStreamerBackend;

@protocol GStreamerBackendDelegate <NSObject>

@optional
/* Called when the GStreamer backend has finished initializing
 * and is ready to accept orders. */
-(void) gstreamerInitialized:(GStreamerBackend*)aBackend;

/* Called when the GStreamer backend wants to output some message
 * to the screen. */
-(void) gstreamerSetUIMessage:(NSString *)message;

/* Called when the media size is first discovered or it changes */
-(void) mediaSizeChanged:(NSInteger)width height:(NSInteger)height;

/* Called when the media position changes. Times in milliseconds */
-(void) setCurrentPosition:(NSInteger)position duration:(NSInteger)duration;

-(void) gstreamerExitedMainLoop:(GStreamerBackend*)aBackend;

@end

#endif /* GStreamerBackendDelegate_h */
