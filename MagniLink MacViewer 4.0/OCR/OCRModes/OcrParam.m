////
////  OcrParam.m
////  MagniLink MacViewer 4.0
////
////  Created by Erik Sandstrom on 2023-10-30.
////
//
//#import "OcrParam.h"
//
//@implementation OcrCharData
//
//-(id) initWithCharacter:(unichar) character andRect:(NSRect)aRect
//{
//    self = [super init];
//    if(self){
//        [self setCharacter:character];
//        [self setRect:aRect];
//    }
//    return self;
//}
//
//@synthesize character;
//@synthesize rect;
//@synthesize blockNumber;
//@synthesize suspicious;
//
//@end
//
//@implementation OcrWordRect
//
//@synthesize rect;
//@synthesize range;
//
//@end
//
//@implementation OcrBlock
//
//@synthesize language;
//@synthesize rect;
//@synthesize ocrData;
//
//-(NSString*) getText
//{
//    NSMutableString *result = [[NSMutableString alloc] init];
//    
//    for(OcrCharData* data in ocrData)
//    {
//        unichar c = [data character];
//        NSString* ns = [[NSString alloc] initWithCharacters:&c length:1];
//        [result appendString:ns];
//    }
//    
//    return result;
//}
//
//@end
//
//@implementation OcrImage
//
//@synthesize image;
//@synthesize imagePointer;
//
//@end
//
//@implementation OcrPage
//
//@synthesize blocks;
//@synthesize image;
//
//-(id) init
//{
//    self = [super init];
//    if(self){
//        blocks = [[NSMutableArray alloc] init];
//    }
//    return self;
//}
//
//-(int) getLength
//{
//    int result = 0;
//    for (OcrBlock* block in blocks)
//    {
//        result += [[block ocrData] count];
//    }
//    return result;
//}
//
//-(void) addBlock:(OcrBlock*)block atPosition:(int)pos
//{
//    [blocks insertObject:block atIndex:pos];
//}
//
//-(int) handleSelection:(NSRect)rect
//{
//    int result = 0;
//    int count = 0;
//    NSMutableArray* remove = [[NSMutableArray alloc] init];
//    
//    for(OcrBlock * block in blocks)
//    {
//        if(NSIntersectsRect(rect, block.rect)){
//            [remove addObject:[NSNumber numberWithInt:count]];
//        }
//        count++;
//    }
//    
//    if([remove count] == 0){
//        result = (int)[blocks count];
//    }
//    else{
//        result = [[remove firstObject] intValue];
//    }
//    
//    for(int i = (int)[remove count] - 1 ; i >= 0 ; i--)
//    {
//        [blocks removeObjectAtIndex:[[remove objectAtIndex:i] intValue]];
//    }
//    
//    return result;
//}
//
//-(NSArray<OcrWordRect*>*) getWordRectangles
//{
//    NSMutableArray<OcrWordRect*>* rects = [[NSMutableArray alloc] init];
//    int count = 0;
//    for (OcrBlock* block in blocks)
//    {
//        NSArray<OcrWordRect*>* rects2 = [self getWordRectangles:block andCount: count];
//        [rects addObjectsFromArray:rects2];
//        count += [block.ocrData count];
//    }
//    return rects;
//}
//
//+(bool) isWhiteSpace:(unichar)ch
//{
//    if(ch == ' ' || ch == '\n' || ch == '\t')
//        return true;
//    return false;
//}
//
//-(NSArray<OcrWordRect*>*) getWordRectangles:(OcrBlock*) block andCount:(int) aCount
//{
//    NSMutableArray<OcrWordRect*>* rects = [[NSMutableArray alloc] init];
//    if ([[block ocrData] count] > 0)
//    {
//        bool startRect = false;
//        int start = 0;
//        int count = 0;
//        for (OcrCharData* data in [block ocrData])
//        {
//            bool whiteSpace = [OcrPage isWhiteSpace:data.character];
//            if (whiteSpace == false && startRect == false)
//            {
//                start = count;
//                startRect = true;
//            }
//            else if (whiteSpace && startRect)
//            {
//                NSArray<OcrWordRect*>* rect = [self getRectangles:block :start :count :aCount];
//                [rects addObjectsFromArray:rect];
//                startRect = false;
//            }
//            count++;
//        }
//    }
//    return rects;
//}
//
//-(NSArray<OcrWordRect*>*) getRectangles:(OcrBlock*) aBlock :(int) aStart :(int) aEnd :(int) aCount
//{
//    NSMutableArray<OcrWordRect*>* result = [[NSMutableArray alloc] init];
//    double maxX = 0;
//    double maxY = 0;
//    double minX = DBL_MAX;
//    double minY = DBL_MAX;
//
//    for (int i = aStart; i < aEnd; i++)
//    {
//        OcrCharData* d = [[aBlock ocrData] objectAtIndex:i];
//        if (d != nil)
//        {
//            NSRect r = [d rect];
//            
//            if (r.origin.x < minX)
//                minX = r.origin.x;
//            if (r.origin.x + r.size.width > maxX)
//                maxX = r.origin.x + r.size.width;
//
//            if (r.origin.y < minY)
//                minY = r.origin.y;
//            if (r.origin.y + r.size.height > maxY)
//                maxY = r.origin.y + r.size.height;
//
//            if ([[aBlock ocrData] count] > i + 1)
//            {
//                OcrCharData* d2 = [[aBlock ocrData] objectAtIndex:i + 1];
//                if (d2 != nil)
//                {
//                    if (d2.rect.origin.x < d.rect.origin.x)
//                    {
//                        OcrWordRect* mr = [[OcrWordRect alloc] init];
//                        mr.range = NSMakeRange(aCount + aStart, aEnd - aStart);
//                        mr.rect = NSMakeRect(minX, minY, maxX - minX, maxY - minY);
//                        [result addObject:mr];
//                        maxX = 0;
//                        maxY = 0;
//                        minX = DBL_MAX;
//                        minY = DBL_MAX;
//                    }
//                }
//            }
//        }
//    }
//    OcrWordRect* mr2 =  [[OcrWordRect alloc] init];
//    mr2.range = NSMakeRange(aCount + aStart, aEnd - aStart);
//    mr2.rect = NSMakeRect(minX, minY, maxX - minX, maxY - minY);
//    [result addObject:mr2];
//    return result;
//}
//
//-(OcrCharData*) getData:(int)pos
//{
//    if (pos >= [self getLength])
//        pos = [self getLength] - 1;
//    int total = 0;
//    
//    for (OcrBlock* block in blocks)
//    {
//        total += [[block ocrData] count];
//        if (pos < total)
//            return [[block ocrData] objectAtIndex:pos - (total - [[block ocrData] count]) ];
//    }
//    
//    return nil;
//}
//
//-(int) getBlockNumber:(int) pos
//{
//    int count = 0;
//    int blockNumber = 0;
//    for (OcrBlock* block in blocks)
//    {
//        count += [[block ocrData] count];
//        if (count > pos)
//        {
//            return blockNumber;
//        }
//        blockNumber++;
//    }
//    if (blockNumber == [blocks count])
//        return (int)[blocks count] - 1;
//    return blockNumber;
//}
//
//-(OcrBlock*) getBlock:(int) pos
//{
//    int nr = [self getBlockNumber:pos];
//    if (nr >= 0)
//        return [blocks objectAtIndex:nr];
//    return nil;
//}
//
//-(NSArray*) getSelectedRectangles:(NSRange) range
//{
//    int pos = (int)range.location;
//    int length = (int)range.length;
//    NSMutableArray* rects = [[NSMutableArray alloc] init];
//    
//    double maxX = 0;
//    double maxY = 0;
//    double minX = DBL_MAX;
//    double minY = DBL_MAX;
//    
//    for (int i = pos; i < pos + length; i++)
//    {
//        OcrCharData* d = [self getData:i];
//        if (d != nil)
//        {
//            NSRect r = [d rect];
//            if (r.origin.x < minX)
//                minX = r.origin.x;
//            if (r.origin.x + r.size.width > maxX)
//                maxX = r.origin.x + r.size.width;
//
//            if (r.origin.y < minY)
//                minY = r.origin.y;
//            if (r.origin.y + r.size.height > maxY)
//                maxY = r.origin.y + r.size.height;
//
//            OcrBlock* b = [self getBlock:i];
//            if (b == nil)
//            {
//                return rects;
//            }
//
//            OcrCharData* d2 = [self getData:i + 1];
//            if (d2 != nil)
//            {
//                if ([d2 rect].origin.x < [d rect].origin.x)
//                {
//                    NSRect newRect = NSMakeRect(minX, minY, maxX - minX, maxY - minY);
//                    [rects addObject:[NSValue valueWithRect:newRect]];
//                    maxX = 0;
//                    maxY = 0;
//                    minX = DBL_MAX;
//                    minY = DBL_MAX;
//                }
//            }
//        }
//    }
//    NSRect newRect = NSMakeRect(minX, minY, maxX - minX, maxY - minY);
//    [rects addObject:[NSValue valueWithRect:newRect]];
//    return rects;
//}
//
//@end
//
//@interface OcrPages()
//{
//    int currentPage;
//    bool actualPageFlag;
//    NSMutableArray<OcrPage*> * mPages;
//}
//@end
//
//@implementation OcrPages
//
//@synthesize delegate;
//@synthesize actualPageFlag;
//
//-(id)init
//{
//    self = [super init];
//    if(self){
//        currentPage = -1;
//        actualPageFlag = true;
//        mPages = [[NSMutableArray alloc] init];
//    }
//    return self;
//}
//
//-(NSArray*) getPages
//{
//    return mPages;
//}
//
//-(OcrPage*) getCurrentPage
//{
//    if(currentPage < 0)
//        return nil;
//    
//    return [mPages objectAtIndex:currentPage];
//}
//
//-(void) addPage:(OcrPage*)page
//{
//    [mPages addObject:page];
//    if(currentPage == -1){
//        currentPage++;
//        actualPageFlag = true;
//    }
//    else{
//        actualPageFlag = false;
//    }
//    [delegate pagesChanged];
//}
//
//-(void) clear
//{
//    for(OcrPage *page in mPages){
//        free(page.image.imagePointer);
//    }
//    
//    [mPages removeAllObjects];
//    currentPage = -1;
//    [delegate pagesChanged];
//}
//
//-(BOOL) isLastPage
//{
//    return [mPages count] - 1 == currentPage;
//}
//
//-(void) moveToLastPage
//{
//    currentPage = [mPages count] - 1;
//}
//
//-(BOOL) canMovePages:(int)pages
//{
//    if(currentPage < 0)
//        return false;
//    
//    int page = currentPage;
//    page += pages;
//    
//    if(page < 0){
//        page = 0;
//    }
//    if(page > [mPages count] - 1)
//    {
//        page = (int)[mPages count] - 1;
//    }
//    if(page != currentPage){
//        return true;
//    }
//    return false;
//}
//
//-(BOOL) movePages:(int)pages
//{
//    if(currentPage < 0)
//        return false;
//    
//    actualPageFlag = false;
//    int page = currentPage;
//    page += pages;
//    
//    if(page < 0){
//        page = 0;
//    }
//    if(page > [mPages count] - 1)
//    {
//        page = (int)[mPages count] - 1;
//    }
//    if(page != currentPage){
//        currentPage = page;
//        [delegate pagesChanged];
//        return true;
//    }
//    return false;
//}
//
//-(BOOL) deletePage
//{
//    if([mPages count] <= 1)
//        return false;
//    
//    [mPages removeObjectAtIndex:currentPage];
//    if(currentPage != 0){
//        currentPage--;
//    }
//    actualPageFlag = false;
//    [delegate pagesChanged];
//    return true;
//}
//
//-(int) getNumberOfPages
//{
//    return (int)[mPages count];
//}
//
//-(int) getCurrentPageNumber
//{
//    return currentPage;
//}
//
//@end
