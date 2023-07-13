//
//  GStreamerBackend.m
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-07-13.
//

#import "GStreamerBackend.h"

#include <gst/gst.h>
#include <gst/app/gstappsink.h>
#include <gst/video/video.h>

GST_DEBUG_CATEGORY_STATIC (debug_category);
#define GST_CAT_DEFAULT debug_category

GstFlowReturn on_appsink_new_sample(GstElement* sink, GStreamerBackend* aBackend)
{
    GstSample* sample = gst_app_sink_pull_sample(GST_APP_SINK(sink));
    
    if (sample) {

        GstBuffer* buffer = gst_sample_get_buffer(sample);

        GstMapInfo map;
        gst_buffer_map(buffer, &map, GST_MAP_READ);

        GstCaps* caps = gst_sample_get_caps(sample);

        GstVideoInfo video_info;

        if (gst_video_info_from_caps(&video_info, caps))
        {
        }

        gst_buffer_unmap(buffer, &map);

        gst_sample_unref(sample);
        VideoStruct video;
        video.data = map.data;
        video.width = video_info.width;
        video.height = video_info.height;
        video.stride = video_info.stride[0];
        
        aBackend.backendCallback(video);
    }
    
    return GST_FLOW_OK;
}

@interface GStreamerBackend()
{
    GStreamerType mType;
}

-(void)setUIMessage:(gchar*) message;
-(void)app_function;
-(void)check_initialization_complete;
@end

@implementation GStreamerBackend
{
    id ui_delegate;        /* Class that we use to interact with the user interface */
    GstElement *pipeline;  /* The running pipeline */
    GMainContext *context; /* GLib context used to run the main loop */
    GMainLoop *main_loop;  /* GLib main loop */
    gboolean initialized;  /* To avoid informing the UI multiple times about the initialization */
    GstElement* source;
    GstElement* videosink;
}

/*
 * Interface methods
 */
static bool initialized = false;
+(void) init_gstreamer
{
    if(initialized == false){
        //gst_ios_init();
        gst_init(0, NULL);
        initialized = true;
    }
}

-(id) init:(id) uiDelegate andType:(GStreamerType)aType
{
    if (self = [super init])
    {
        mType = aType;
        
        //gst_ios_init();
        
        self->ui_delegate = uiDelegate;

        GST_DEBUG_CATEGORY_INIT (debug_category, "one", 0, "one");
        gst_debug_set_threshold_for_name("one", GST_LEVEL_DEBUG);

        /* Start the bus monitoring task */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self app_function];
        });
    }

    return self;
}

-(void) dealloc
{
    if (pipeline) {
        GST_DEBUG("Setting the pipeline to NULL");
        gst_element_set_state(pipeline, GST_STATE_NULL);
        gst_object_unref(pipeline);
        pipeline = NULL;
    }
}

-(void) play
{
    if(gst_element_set_state(pipeline, GST_STATE_PLAYING) == GST_STATE_CHANGE_FAILURE) {
        [self setUIMessage:"Failed to set pipeline to playing"];
    }
}

-(void) pause
{
    if(gst_element_set_state(pipeline, GST_STATE_PAUSED) == GST_STATE_CHANGE_FAILURE) {
        [self setUIMessage:"Failed to set pipeline to paused"];
    }
}

/*
 * Private methods
 */

/* Change the message on the UI through the UI delegate */
-(void)setUIMessage:(gchar*) message
{
    NSString *string = [NSString stringWithUTF8String:message];
    if(ui_delegate && [ui_delegate respondsToSelector:@selector(gstreamerSetUIMessage:)])
    {
        [ui_delegate gstreamerSetUIMessage:string];
    }
}

/* Retrieve errors from the bus and show them on the UI */
static void error_cb (GstBus *bus, GstMessage *msg, GStreamerBackend *self)
{
    GError *err;
    gchar *debug_info;
    gchar *message_string;

    gst_message_parse_error (msg, &err, &debug_info);
    message_string = g_strdup_printf ("Error received from element %s: %s", GST_OBJECT_NAME (msg->src), err->message);
    g_clear_error (&err);
    g_free (debug_info);
    [self setUIMessage:message_string];
    g_free (message_string);
    gst_element_set_state (self->pipeline, GST_STATE_NULL);
}

/* Notify UI about pipeline state changes */
static void state_changed_cb (GstBus *bus, GstMessage *msg, GStreamerBackend *self)
{
    GstState old_state, new_state, pending_state;
    gst_message_parse_state_changed (msg, &old_state, &new_state, &pending_state);
    /* Only pay attention to messages coming from the pipeline, not its children */
    if (GST_MESSAGE_SRC (msg) == GST_OBJECT (self->pipeline)) {
        gchar *message = g_strdup_printf("State changed to %s", gst_element_state_get_name(new_state));
        [self setUIMessage:message];
        g_free (message);
    }
}

/* Check if all conditions are met to report GStreamer as initialized.
 * These conditions will change depending on the application */
-(void) check_initialization_complete
{
    if (!initialized && main_loop) {
        GST_DEBUG ("Initialization complete, notifying application.");
        if (ui_delegate /*&& [ui_delegate respondsToSelector:@selector(gstreamerInitialized:GStreamerBackend:*)]*/)
        {
            [ui_delegate gstreamerInitialized:self];
        }
        initialized = TRUE;
    }
}

/* Main method for the bus monitoring code */
-(void) app_function
{
    GstBus *bus;
    GSource *bus_source;
    GError *error = NULL;

    GST_DEBUG ("Creating pipeline");

    /* Create our own GLib Main Context and make it the default one */
    context = g_main_context_new ();
    g_main_context_push_thread_default(context);

    /* Build pipeline */
    pipeline = gst_pipeline_new("test-pipeline");

 //   NSString *description = [NSString stringWithFormat:@"videotestsrc ! appsink caps=\"video/x-raw, format=(string)BGRA\" emit-signals=TRUE sync=FALSE name=appsink"];

    //    description = [NSString stringWithFormat:@"udpsrc port=5000 ! capsfilter caps=\"application/x-rtp, encoding-name=H264, payload=26\" ! rtph264depay ! avdec_h264 ! videoconvert ! appsink caps=\"video/x-raw, format=(string)BGRA\" emit-signals=TRUE sync=FALSE name=appsink"];

    //    description = [NSString stringWithFormat:@"rtspsrc location=rtsp://10.81.105.54:8554/test ! rtpjpegdepay ! decodebin ! queue ! videoconvert ! appsink caps=\"video/x-raw, format=(string)BGRA\" emit-signals=TRUE sync=FALSE name=appsink"];

    //    description = [NSString stringWithFormat:@"rtspsrc location=rtsp://10.81.105.54:8554/test ! rtph264depay ! decodebin ! queue ! videoconvert ! appsink caps=\"video/x-raw, format=(string)BGRA\" emit-signals=TRUE sync=FALSE name=appsink"];
    
    //    description = [NSString stringWithFormat:@"rtspsrc latency=0 location=rtsp://192.168.4.1:8554/test ! rtpjpegdepay ! decodebin ! queue ! videoconvert ! appsink caps=\"video/x-raw, format=(string)BGRA\" emit-signals=TRUE sync=FALSE name=appsink"];
    
    NSString *description = [NSString stringWithFormat:@"rtspsrc location=rtsp://api:cyz2sheipq0rLwR4@192.168.101.100/onvif-media/media.amp?profile=LVI_666666_1&sessiontimeout=60&streamtype=unicast ! queue ! rtph264depay ! h264parse ! queue ! avdec_h264 ! queue ! videoconvert ! appsink caps=\"video/x-raw, format=(string)BGRA\" emit-signals=TRUE sync=FALSE name=appsink"];
    
    if(mType == AirDistance){
        description = [NSString stringWithFormat:@"rtspsrc location=rtsp://api:cyz2sheipq0rLwR4@192.168.101.200:554/Streaming/Channels/101?transportmode=unicast&profile=LVI_666666_1 ! queue ! rtph264depay ! h264parse ! queue ! avdec_h264 ! queue ! videoconvert ! appsink caps=\"video/x-raw, format=(string)BGRA\" emit-signals=TRUE sync=FALSE name=appsink"];
    }
    if(mType == AirEthernet){
        description = [NSString stringWithFormat:@"rtspsrc location=rtsp://api:cyz2sheipq0rLwR4@192.168.100.100/onvif-media/media.amp ! queue ! rtph264depay ! h264parse ! queue ! avdec_h264 ! queue ! videoconvert ! appsink caps=\"video/x-raw, format=(string)BGRA\" emit-signals=TRUE sync=FALSE name=appsink"];
    }
    if(mType == AirGrabber){
        description = [NSString stringWithFormat:@"rtspsrc location=rtsp://192.168.101.150/live/0 ! queue ! rtph265depay ! h265parse ! queue ! avdec_h265 ! queue ! videoconvert ! appsink caps=\"video/x-raw, format=(string)BGRA\" emit-signals=TRUE sync=FALSE name=appsink"];
    }
    if(mType == AirGrabberEthernet){
        description = [NSString stringWithFormat:@"rtspsrc location=rtsp://192.168.101.149/live/0 ! queue ! rtph265depay ! h265parse ! queue ! avdec_h265 ! queue ! videoconvert ! appsink caps=\"video/x-raw, format=(string)BGRA\" emit-signals=TRUE sync=FALSE name=appsink"];
    }
    
    if ((pipeline = gst_parse_launch(description.UTF8String, &error)) == NULL)
    {
        NSLog(@"Unable to parse pipeline. Error: %s", error->message);

        g_error_free(error);
    }
    
    if ((videosink = gst_bin_get_by_name(GST_BIN(pipeline), "appsink")) == NULL)
    {
        NSLog(@"Unable to get glimagesink from pipeline");
    }
    
    //source = gst_element_factory_make("videotestsrc", "source");
    
    //videosink = gst_element_factory_make("appsink", "videosink");

    //gst_bin_add_many(GST_BIN(pipeline), source, videosink, NULL);

//    if (!gst_element_link_many(source, videosink, NULL)
//        )
//    {
//        g_printerr("Error linking fields ...1 \n");
//    }
    
    /* Set the pipeline to READY, so it can already accept a window handle */
    gst_element_set_state(pipeline, GST_STATE_READY);

    //g_object_set(videosink, "emit-signals", TRUE, NULL);
    
    g_signal_connect(videosink, "new-sample", G_CALLBACK(on_appsink_new_sample), (__bridge gpointer)(self));
    
//    gst_video_overlay_set_window_handle(GST_VIDEO_OVERLAY(videosink), (guintptr) (id) ui_video_view);

    /* Instruct the bus to emit signals for each received message, and connect to the interesting signals */
    bus = gst_element_get_bus (pipeline);
    bus_source = gst_bus_create_watch (bus);
    g_source_set_callback (bus_source, (GSourceFunc) gst_bus_async_signal_func, NULL, NULL);
    g_source_attach (bus_source, context);
    g_source_unref (bus_source);
    g_signal_connect (G_OBJECT (bus), "message::error", (GCallback)error_cb, (__bridge void *)self);
    g_signal_connect (G_OBJECT (bus), "message::state-changed", (GCallback)state_changed_cb, (__bridge void *)self);
    gst_object_unref (bus);

    /* Create a GLib Main Loop and set it to run */
    GST_DEBUG ("Entering main loop...");
    main_loop = g_main_loop_new (context, FALSE);
    [self check_initialization_complete];
    g_main_loop_run (main_loop);
    GST_DEBUG ("Exited main loop");
    [ui_delegate gstreamerExitedMainLoop:self];
    g_main_loop_unref (main_loop);
    main_loop = NULL;

    /* Free resources */
    g_main_context_pop_thread_default(context);
    g_main_context_unref (context);
    gst_element_set_state (pipeline, GST_STATE_NULL);
    gst_object_unref (pipeline);
    pipeline = NULL;

    return;
}

-(void)close
{
    g_main_loop_quit(main_loop);
}


@end
