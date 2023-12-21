//
//  OcrBase.h
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

#import <Foundation/Foundation.h>
#import "OcrSettings.h"
#import "OcrParam.h"

NS_ASSUME_NONNULL_BEGIN

#define SID 0
#define LINE_ACCEPTANCE 0.2
#define PARA_DIFF 3
#define DEFAULT_DPI 96

#define LVI_SUSPECT_THR 40

#define USE_OEM_LICENSE    1
#define LICENSE_FILE    "license.lcxz"
#define LICENSE_KEY   "4e69e7b0d74e"

@protocol OcrDelegate <NSObject>
//- (void) handleOcrQuit:(OCR*) sender;
//- (void) handleNoText:(OCR*)sender;
//- (void) handleBlock:(OcrBlock*)block withNumber:(int)number;
//- (void) handleOcrFinished:(OcrPage*)page andAppend:(bool)append;
- (void) handleOcrFinished:(LETTER*)letters andLengt:(int)length;
@end

typedef enum {
    Command_None,
    Command_Ocr,
    Command_Image,
    Command_File,
    Command_Mouse,
    Command_Quit
} OcrCommand;

@interface OcrArgument : NSObject

@property (strong , nonatomic) NSImage* image;
@property (strong , nonatomic) NSString* filename;
@property OcrCommand command;
@property NSRect rectangle;
@property int number;
@property bool append;
@property bool recognize;
@end

@interface OcrBase : NSObject
{
    int mBlockNumber;
    OcrSettings* mSettings;
    NSObject* receiver;
    bool quit;
    bool ocrInitialized;
}

@property (nonatomic, weak) id <OcrDelegate> delegate;

//-(NSMutableArray<OcrBlock*>*) blocksFromLetter:(LETTER*)letters andLength:(LONG)length;
//-(void) calculateBlockRects:(NSMutableArray<OcrBlock*>*)blocks withHeight:(int)height;
//-(OcrImage*) getImage;
-(RECERR) loadImage:(NSImage*)image andPage:(HPAGE*)hpage;

//-(OcrImage*) getImage;
+ (void) initializeOcr;
+ (id) initWithReceiver:(NSObject*)object;

@end



NS_ASSUME_NONNULL_END
