//
//  OcrBase.m
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

#import <Cocoa/Cocoa.h>
#import "OcrBase.h"
#import "OcrBitmap.h"
//#import "OcrImage.h"
//#import "SpeechBlock.h"
//#import "Statistics.h"
#import "OcrParam.h"
#import "OcrSettings.h"

@implementation OcrArgument

@synthesize image;
@synthesize filename;
@synthesize command;
@synthesize rectangle;
@synthesize number;
@synthesize recognize;

@end

@implementation OcrBase

- (id)initWithReceiver:(NSObject *)object
{
    self = [super init];
    if (self) {
        receiver = object;
        quit = false;
        
        //mSettings = [[OcrSettings alloc] init];
        
        //NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(ocrLoop) object:nil];
        //[thread start];
        
        //[self initializeOcr];
    }
    return self;
}

+ (void) initializeOcr
{
    RECERR      rc;
    NSBundle *application = [NSBundle bundleForClass:[self class]];
    NSString *licensePath = [application pathForResource:@ LICENSE_FILE ofType:nil];
    rc = kRecSetLicense([licensePath UTF8String], LICENSE_KEY);
    if (rc != REC_OK)
    {
        kRecQuit();
    }
    
    rc = kRecInit("LVI Low Vision International AB", "MagniLink");    // use your company and product name here
    if ((rc != REC_OK) && (rc != API_INIT_WARN))
    {
        kRecQuit();
    }
    
    LPKRECMODULEINFO info;
    unsigned long size;
    kRecGetModulesInfo(&info, &size);
    
    RECERR er = info[INFO_ASN].InitError;
    int v = info[INFO_ASN].Version;

    //ocrInitialized = YES;
}


-(BYTE*) OneBitToEightBit:(IMG_INFO*)info andData:(BYTE*)data
{
    BYTE*res = malloc(info->Size.cx * info->Size.cy * 8);
    
    for(int j = 0 ; j < info->Size.cy ; j++ )
    {
        for(int i = 0 ; i < info->Size.cx ; i++ )
        {
            int idx = i % 8;
            BYTE b = data[j*info->BytesPerLine + i / 8];
            
            res[j*info->Size.cx + i] = ((b & (0x80 >> idx)) != 0 ) ? 0 : 255;
        }
    }
    
    info->BitsPerPixel = 8;
    info->BytesPerLine = info->Size.cx;
    
    return res;
}

//-(OcrImage*) getImage
//{
//    RECERR  rc;
//    IMG_INFO info;
//    BYTE *data;
//    BYTE *imageData = NULL;
//    NSImage *image;
//    bool binary = false;
//    rc = kRecGetImgArea(SID, [mSettings getPage], II_CURRENT, NULL, NULL, &info, &data);
//    
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    if(info.BitsPerPixel == 24)
//    {
//        imageData = data;
//        colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    }
//    else if(info.BitsPerPixel == 8)
//    {
//        imageData = data;
//        colorSpaceRef = CGColorSpaceCreateDeviceGray();
//    }
//    else if(info.BitsPerPixel == 1)
//    {
//        binary = true;
//        colorSpaceRef = CGColorSpaceCreateDeviceGray();
//        imageData = [self OneBitToEightBit:&info andData:data];
//    }
//        
//    size_t bufferLength = info.BytesPerLine * info.Size.cy;
//    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imageData, bufferLength, NULL);
//
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault /*| kCGImageAlphaPremultipliedLast*/;
//    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//    
//    CGImageRef iref = CGImageCreate(info.Size.cx,
//                                    info.Size.cy,
//                                    8,
//                                    info.BitsPerPixel,
//                                    info.BytesPerLine,
//                                    colorSpaceRef,
//                                    bitmapInfo,
//                                    provider,   // data provider
//                                    NULL,       // decode
//                                    YES,        // should interpolate
//                                    renderingIntent);
//    
//    image = [[NSImage alloc] initWithCGImage:iref size:NSMakeSize(info.Size.cx, info.Size.cy)];
//
//    if(binary){
//        kRecFree(data);
//    }
//    
//    CGImageRelease(iref);
//    CGDataProviderRelease(provider);
//    CGColorSpaceRelease(colorSpaceRef);
//    
////    OcrImage* ocr_image = [[OcrImage alloc] init];
////    ocr_image.image = image;
////    ocr_image.imagePointer = imageData;
//    
//    return ocr_image;
//}

-(NSBitmapImageRep*)getImageRepFromImage:(NSImage *)image
{
    int width = [image size].width;
    int height = [image size].height;
    
    if(width < 1 || height < 1)
        return nil;
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes: NULL
                             pixelsWide: width
                             pixelsHigh: height
                             bitsPerSample: 8
                             samplesPerPixel: 4
                             hasAlpha: YES
                             isPlanar: NO
                             colorSpaceName: NSCalibratedRGBColorSpace
                             bytesPerRow: width * 4
                             bitsPerPixel: 32];
    
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: rep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext: ctx];
    
    [image drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositeCopy fraction: 1.0];
    
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    
    return rep;
}

-(RECERR) loadImage:(NSImage*)image andPage:(HPAGE*)hpage
{
    //[[image TIFFRepresentation] writeToFile:@"/Users/erik/Desktop/loadImage.tiff" atomically:YES];
    
    RECERR rc = REC_OK;
    IMG_INFO imgInfo;
    
    NSBitmapImageRep * bitmap = [self getImageRepFromImage:image];
    
    imgInfo.BitsPerPixel = 24;
    imgInfo.Size.cy = (int)[bitmap pixelsHigh];
    imgInfo.Size.cx = (int)[bitmap pixelsWide];
    imgInfo.BytesPerLine = (int)[bitmap pixelsWide] * imgInfo.BitsPerPixel / 8;
    imgInfo.DPI.cx = DEFAULT_DPI;
    imgInfo.DPI.cy = DEFAULT_DPI;
    imgInfo.IsPalette = false;
    
    unsigned char* bmpdata = [bitmap bitmapData];
    BYTE* data = malloc(imgInfo.Size.cx*imgInfo.Size.cy*(imgInfo.BitsPerPixel/8));
    
    for(int i = 0 ; i < imgInfo.Size.cx * imgInfo.Size.cy ; i++){
        data[3*i] = bmpdata[4*i+0];
        data[3*i+1] = bmpdata[4*i+1];
        data[3*i+2] = bmpdata[4*i+2];
    }
    
    NSLog(@"OCR:performOCR %dx%d", imgInfo.Size.cx,imgInfo.Size.cy);
    
    rc = kRecLoadImgM(SID, data, &imgInfo , hpage);

    free(data);
    
    return rc;
}

//-(OcrCharData*) dataFromLetter:(LETTER) aLetter
//{
//    OcrCharData *data = [[OcrCharData alloc] initWithCharacter:aLetter.code andRect:NSMakeRect(aLetter.left, aLetter.top, aLetter.width, aLetter.height)];
//    if ((aLetter.err & 0x7F) > LVI_SUSPECT_THR)
//    {
//        data.suspicious = true;
//    }
//    else
//    {
//        data.suspicious = false;
//    }
//    return data;
//}

-(bool) rejectLetter:(LETTER) aLetter
{
    if (aLetter.code == 0x25A0)
        return true;
    return false;
}

//-(void) calculateBlockRects:(NSMutableArray<OcrBlock*>*)blocks withHeight:(int)height
//{
//    for(OcrBlock* block in blocks)
//    {
//        double minX = DBL_MAX;
//        double minY = DBL_MAX;
//        double maxX = DBL_MIN;
//        double maxY = DBL_MIN;
//        
//        for(OcrCharData* data in [block ocrData])
//        {
//            NSRect r = [data rect];
//            
//            [data setRect:NSMakeRect(r.origin.x, height - (r.origin.y + r.size.height), r.size.width, r.size.height)];
//            
//            if(r.origin.x < minX)
//                minX = r.origin.x;
//            if(r.origin.y < minY)
//                minY = r.origin.y;
//            
//            if(r.origin.x + r.size.width > maxX)
//                maxX = r.origin.x + r.size.width;
//            if(r.origin.y + r.size.height > maxY)
//                maxY = r.origin.y + r.size.height;
//        }
//        
//        [block setRect:NSMakeRect(minX, height - maxY, maxX - minX, (maxY - minY))];
//    }
//}
//
//-(NSMutableArray<OcrBlock*>*) blocksFromLetter:(LETTER*)letters andLength:(LONG)length
//{
//    NSMutableArray<OcrBlock*>* result = [[NSMutableArray<OcrBlock*> alloc ] init];
//    NSMutableArray<OcrCharData*>* lineData = [[NSMutableArray<OcrCharData*> alloc ] init];
//    NSMutableArray<OcrCharData*>* strData = [[NSMutableArray<OcrCharData*> alloc ] init];
//    
//    double averageHeight = 0;
//    double averageTop = 0;
//    int confidenceOfLine = 0;
//    int averageCount = 0;
//    int first = 0;
//    
//    for(int i = 0 ; i < length ; i++)
//    {
//        if ([self rejectLetter:letters[i]])
//            continue;
//        
//        OcrCharData* ocd = [self dataFromLetter:letters[i]];
//        ocd.blockNumber = mBlockNumber;
//        
//        [lineData addObject:ocd];
//        averageHeight = (averageHeight * averageCount + letters[i].height) / (averageCount+1);
//        averageTop = (averageTop * averageCount + letters[i].top) / (averageCount+1);
//        averageCount++;
//        
//        if((letters[i].makeup & R_ENDOFLINE) != 0){
//            
//            //double avr = (double)confidenceOfLine / averageCount;
//            
//            [strData addObjectsFromArray:lineData];
//            OcrCharData* newline = [[OcrCharData alloc] initWithCharacter:'\n' andRect:NSMakeRect(letters[i].width + letters[i].left, averageTop, letters[i].width * 2, averageHeight)];
//            
//            newline.suspicious = false;
//            [strData addObject:newline];
//            [lineData removeAllObjects];
//            
//            bool cond0 = [strData count] > 0;
//            
//            bool condEOZ = (letters[i].makeup & R_ENDOFZONE) != 0;
//            
//            if (cond0 && condEOZ){
//                
//                OcrBlock* block = [[OcrBlock alloc] init];
//                
//                mBlockNumber++;
//                [block setOcrData:strData];
//                [block setLanguage:[self determineLanguage:[block getText] andLanguages:[mSettings getLanguages]]];
//                first = i;
//                
//                [result addObject:block];
//                
//                strData = [[NSMutableArray<OcrCharData*> alloc ] init];
//                
//            }
//            averageCount = 0;
//            confidenceOfLine = 0;
//            averageHeight = 0;
//            averageTop = 0;
//        }
//    }
//    
//    return result;
//}
//
//-(NSString*) determineLanguage:(NSString*)text andLanguages:(NSArray*)aLanguages
//{
//    long best = INT_MAX;
//    NSString* result = @"";
//    
//    for(NSString * str in aLanguages){
//        long res = INT_MAX;
//        if([self isLanguageAvailable:str]){
//            res = [self determineLanguageHelp:text andLanguage:str andCurrentBest:best];
//        }
//        else{
//            if([str isEqualToString:@"fi"]){
//                res = [self determineLanguageHelp2:text andLanguage:str andCurrentBest:best andDictionary:[mSettings getFiDict]];
//            }
//            else if([str isEqualToString:@"nb"]){
//                res = [self determineLanguageHelp2:text andLanguage:str andCurrentBest:best andDictionary:[mSettings getNoDict]];
//            }
//        }
//        
//        if(res < best){
//            best = res;
//            result = str;
//        }
//    }
//    
//    return result;
//}
//
//-(bool) isLanguageAvailable:(NSString*)language
//{
//    NSSpellChecker *spellChecker = [NSSpellChecker sharedSpellChecker];
//    
//    NSArray *available = [spellChecker userPreferredLanguages];
//    
//    for(NSString* lang in available)
//    {
//        //NSLog(@"OCR::isLanguageAvailable: %@\n",lang);
//        if([language isEqualToString:[lang substringToIndex:2]]){
//            return YES;
//        }
//    }
//    return NO;
//}
//
//-(NSInteger) determineLanguageHelp:(NSString*) text andLanguage:(NSString*)language andCurrentBest:(NSInteger)best
//{
//    NSSpellChecker *spellChecker = [NSSpellChecker sharedSpellChecker];
//    
//    NSInteger wordCount;
//    NSInteger location = 0;
//    NSInteger errors = -1;
//    while(location <= [text length])
//    {
//        NSRange range = [spellChecker checkSpellingOfString:text startingAt:location language:language wrap:NO inSpellDocumentWithTag:0 wordCount:&wordCount ];
//        
//        if(wordCount == -1){
//            return INT_MAX-1;
//        }
//        
//        errors++;
//        if(errors > best)
//            return errors;
//        location = range.location +  range.length;
//    }
//    return errors;
//}
//
//-(NSInteger) determineLanguageHelp2:(NSString*) text andLanguage:(NSString*)language andCurrentBest:(NSInteger)best andDictionary:(NSDictionary*)dict
//{
//    NSInteger errors = 0;
//    NSArray *comp = [text componentsSeparatedByCharactersInSet:[mSettings getCharSet]];
//    
//    for(NSString* str in comp){
//        NSString *str2 = [str lowercaseString];
//        if([str2 isEqualToString:@""] == NO){
//            if([dict objectForKey:str2] == nil){
//                errors++;
//            }
//        }
//    }
//    return errors;
//}
//
//-(NSArray*)stringsFromLetters:(LETTER*)letters andLength:(LONG)length
//{
//    NSMutableString *str = [[NSMutableString alloc] init];
//    NSMutableString *line = [[NSMutableString alloc] init];
//    NSMutableArray* strings = [[NSMutableArray alloc] init];
//    
//    double averageHeight = 0;
//    double averageTop = 0;
//    int averageCount = 0;
//    int confidenceOfLine = 0;
//    
//    for(int i = 0 ; i < length ; i++){
//        [line appendString:[NSString stringWithCharacters:&letters[i].code length:1]];
//        
//        bool conf = (letters[i].err & 0x7F) > RE_SUSPECT_THR;
//        if(conf)
//            confidenceOfLine++;
//        
//        averageHeight = (averageHeight * averageCount + letters[i].height) / (averageCount+1);
//        averageTop = (averageTop * averageCount + letters[i].top) / (averageCount+1);
//        averageCount++;
//        
//        if(letters[i].makeup & R_ENDOFLINE){
//            
//            double avr = (double)confidenceOfLine / averageCount;
//            if(avr < LINE_ACCEPTANCE){
//                [str appendString:line ];
//                [str appendString:@"\n"];
//            }
//            
//            if( [str length] > 0 && (letters[i].makeup & R_ENDOFZONE ||
//                                     (length > i+1 && (double)(letters[i+1].top - averageTop) > (double)(PARA_DIFF * averageHeight))
//                                     || i == length - 1)){
//                [str appendString:@"\n"];
//                [strings addObject:str];
//                str = [[NSMutableString alloc] init];
//            }
//            averageCount = 0;
//            confidenceOfLine = 0;
//            [line setString:@""];
//        }
//    }
//    
//    return strings;
//}

@end
