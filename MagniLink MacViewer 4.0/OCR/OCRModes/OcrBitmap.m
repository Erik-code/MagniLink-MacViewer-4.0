//
//  OcrBitmap.m
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

#import <Cocoa/Cocoa.h>
#import "OcrBase.h"
#import "OcrBitmap.h"
#import "OcrParam.h"
#import "OcrSettings.h"
#import "MagniLink_MacViewer_4_0-Swift.h"

@implementation OcrBitmap

-(id) initWithSettings:(OcrSettings*)settings
{
    self = [super init];
    if(self){
        mSettings = settings;
    }
    return self;
}

-(BOOL) performOCRImage:(OcrArgument*)args
{
    RECERR rc;
    HPAGE hpage;
    
    [mSettings freePage];
    
    OCRPage *page2 = [[OCRPage alloc] init];
    //OCRPage* page2 = [[OCRPage alloc] init];
    //page2.image = args.image
    
    //OcrPage* page = [[OcrPage alloc] init];
    rc = [self loadImage:args.image andPage:&hpage];
    [mSettings setPage:hpage];
    
    if (rc != REC_OK)
    {
        NSLog(@"kRecLoadImgM Error: 0x%02x", rc);
        kRecQuit();
        return NO;
    }
    
    NSTimeInterval timeStamp1 = [[NSDate date] timeIntervalSince1970];
    rc = [self preProcess];
    if (rc != REC_OK)
    {
        NSLog(@"preProcess Error: 0x%02x", rc);
        kRecQuit();
        return NO;
    }
    NSTimeInterval timeStamp2 = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeDiff = timeStamp2 - timeStamp1;
    NSLog(@"Preprocess %lf", timeDiff);
    
    if(args.recognize)
    {
        rc = [self analyze];
        NSTimeInterval timeStamp3 = [[NSDate date] timeIntervalSince1970];
        timeDiff = timeStamp3 - timeStamp2;
        NSLog(@"Analyze %lf", timeDiff);

        if (rc != REC_OK)
        {
            NSLog(@"analyse Error: 0x%02x", rc);
            kRecQuit();
            return NO;
        }
        
        rc = [self recognize];
        NSTimeInterval timeStamp4 = [[NSDate date] timeIntervalSince1970];
        timeDiff = timeStamp4 - timeStamp3;
        NSLog(@"Recognize %lf", timeDiff);

        if (rc != REC_OK && rc != NO_TXT_WARN)
        {
            NSLog(@"recognize Error: 0x%02x", rc);
            kRecQuit();
            return NO;
        }
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^(void) {
//        [self.delegate handleOcrFinished:page andAppend:args.append];
//    });
    
    return YES;
}

-(RECERR) preProcess
{
    RECERR rc = S_OK;
    
    rc = kRecSetImgRotation(SID, ROT_AUTO);
    if (rc != REC_OK)
    {
        NSLog(@"kRecSetImgRotation Error: %d", rc);
        kRecQuit();
        return rc;
    }
    
    rc = kRecSetImgDeskew(SID, DSK_AUTO);
    if (rc != REC_OK)
    {
        NSLog(@"kRecSetImgDeskew Error: %d", rc);
        kRecQuit();
        return rc;
    }
    
    rc = kRecSetImgResolEnhancement(SID, RE_YES);
    if (rc != REC_OK)
    {
        NSLog(@"kRecSetImgResolEnhancement Error: %d", rc);
        kRecQuit();
        return rc;
    }
    
    kRecSetImgInvert(SID, INV_AUTO );
    if (rc != REC_OK)
    {
        NSLog(@"kRecSetImgInvert Error: %d", rc);
        kRecQuit();
        return rc;
    }
    
    rc = kRecSetImgDespeckleMode(SID, TRUE);
    if (rc != REC_OK)
    {
        NSLog(@"kRecSetImgDespeckleMode Error: %d", rc);
        kRecQuit();
        return rc;
    }
    
    rc = kRecPreprocessImg(SID, [mSettings getPage]);
    if (rc != REC_OK)
    {
        NSLog(@"kRecPreprocessImg Error: %d", rc);
        kRecQuit();
        return rc;
    }
    
    //OcrImage* image = [self getImage];
    //[page setImage:image];
    
    return rc;
}

-(RECERR) analyze
{
    RECERR      rc;
    
    rc = kRecSetForceSingleColumn(SID, [mSettings getSingleColumn]);
    if (rc != REC_OK)
    {
        NSLog(@"kRecSetForceSingleColumn Error: %d", rc);
        kRecQuit();
        return rc;
    }

    rc = kRecSetLanguages(SID, [mSettings getLanguageEnums]);
    if (rc != REC_OK)
    {
        NSLog(@"kRecSetLanguages Error: %d", rc);
        kRecQuit();
        return rc;
    }
    
    rc = kRecSetCodePage(SID, "Unicode");
    if (rc != REC_OK)
    {
        NSLog(@"kRecSetCodePage Error: %d", rc);
        kRecQuit();
        return rc;
    }
    
    rc = kRecLocateZones(SID, [mSettings getPage]);
    if (rc != REC_OK)
    {
        NSLog(@"kRecLocateZones Error: %d", rc);
        kRecFreeImg([mSettings getPage]);
        
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            [self.delegate handleNoText:nil];
//        });
        
        return rc;
    }
    
    return rc;
}

-(RECERR) recognize
{
    RECERR      rc;
    
    if([mSettings getColummSelector] == YES){
        int nrZones = 0;
        rc = kRecGetOCRZoneCount([mSettings getPage], &nrZones);
        if (rc != REC_OK)
        {
            NSLog(@"kRecGetOCRZoneCount Error: %d", rc);
            kRecQuit();
            return rc;
        }
        
        IMG_INFO info;
        rc = kRecGetImgInfo(SID, [mSettings getPage], II_CURRENT, &info);
        if (rc != REC_OK)
        {
            NSLog(@"kRecGetImgInfo Error: %d", rc);
            kRecQuit();
            return rc;
        }
        
        rc = kRecCopyOCRZones([mSettings getPage]);
        if (rc != REC_OK)
        {
            NSLog(@"kRecCopyOCRZones Error: %d", rc);
            kRecQuit();
            return rc;
        }
        
        int middle = info.Size.cx / 2;
        
        bool deleteArr[nrZones];
        for(int i = nrZones-1 ; i >= 0 ; i--){
            deleteArr[i] = NO;
        }
        
        for(int i = nrZones-1 ; i >= 0 ; i--){
            ZONE zone;
            
            rc = kRecGetOCRZoneInfo([mSettings getPage], II_CURRENT, &zone, i);
            
            if(zone.rectBBox.left > middle || middle > zone.rectBBox.right){
                deleteArr[i] = YES;
            }
        }
        for(int i = nrZones-1 ; i >= 0 ; i--){
            if(deleteArr[i] == YES){
                rc = kRecDeleteZone([mSettings getPage], i);
            }
        }
    }
    
    rc = kRecRecognize(SID, [mSettings getPage], NULL);
    if (rc != REC_OK && rc!= NO_TXT_WARN)
    {
        NSLog(@"kRecRecognize Error: %d", rc);
        kRecQuit();
        return rc;
    }
    
    LETTER *pLetter;
    LONG lettersLength = 0;
    rc = kRecGetLetters([mSettings getPage], IMGF_FIRSTPAGE, &pLetter, &lettersLength);

    NSLog(@"kRecGetLetters Error: %d", NO_TXT_WARN);

    if (rc != REC_OK && rc != NO_TXT_WARN)
    {
        NSLog(@"kRecGetLetters Error: %d", rc);
        kRecQuit();
        return rc;
    }
    
    if(lettersLength == 0){
//        dispatch_async(dispatch_get_main_queue(), ^(void) { ERIKMARK
//            [self.delegate handleNoText:self];
//        });
    }
    
//    NSMutableArray<OcrBlock*>* blocks = [self blocksFromLetter:pLetter andLength:lettersLength];
//    
//    [self calculateBlockRects:blocks withHeight:[[[aPage image] image] size].height ];
    
    //[aPage setBlocks:blocks];
    
    if(pLetter != NULL)
    {
        kRecFree(pLetter);
    }
    
    return rc;
}

@end
