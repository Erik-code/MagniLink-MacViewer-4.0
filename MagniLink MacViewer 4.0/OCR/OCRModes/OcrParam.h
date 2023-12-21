////
////  OcrParam.h
////  MagniLink MacViewer 4.0
////
////  Created by Erik Sandstrom on 2023-10-30.
////
//
//#import <Foundation/Foundation.h>
//#import <Nuance-OmniPage-CSDK/KernelAPI.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface OcrCharData : NSObject
//
//-(id) initWithCharacter:(unichar) character andRect:(NSRect)aRect;
//
//@property (atomic) unichar character;
//@property (atomic) NSRect rect;
//@property (atomic) int blockNumber;
//@property (atomic) bool suspicious;
//
//@end
//
//@interface OcrWordRect : NSObject
//
//@property (atomic) NSRect rect;
//@property (atomic) NSRange range;
//
//@end
//
//@interface OcrBlock : NSObject
//
//@property (nonatomic,strong) NSMutableArray<OcrCharData *> * ocrData;
//@property (nonatomic,strong) NSString* language;
//@property (atomic) NSRect rect;
//
//-(NSString*) getText;
//
//@end
//
//@interface OcrImage : NSObject
//
//@property (nonatomic,strong) NSImage *image;
//@property BYTE* imagePointer;
//
//@end
//
//@interface OcrPage : NSObject
//
//@property (nonatomic,strong) NSMutableArray<OcrBlock*> * blocks;
//@property (nonatomic,strong) OcrImage *image;
//
//-(NSArray<OcrWordRect*>*) getWordRectangles;
//-(NSArray*) getSelectedRectangles:(NSRange)range;
//-(OcrCharData*) getData:(int)pos;
//-(void) addBlock:(OcrBlock*)block atPosition:(int)pos;
//-(int) handleSelection:(NSRect)rect;
//+(bool) isWhiteSpace:(unichar)ch;
//
//@end
//
//@protocol OcrPagesDelegate <NSObject>
//
//-(void) pagesChanged;
//
//@end
//
//@interface OcrPages : NSObject
//
//@property (nonatomic, strong) id <OcrPagesDelegate> delegate;
//@property bool actualPageFlag;
//
//-(OcrPage*) getCurrentPage;
//-(NSArray*) getPages;
//-(void) addPage:(OcrPage*)page;
//-(BOOL) deletePage;
//-(void) clear;
//-(BOOL) isLastPage;
//-(BOOL) movePages:(int)pages;
//-(BOOL) canMovePages:(int)pages;
//-(void) moveToLastPage;
//-(int) getNumberOfPages;
//-(int) getCurrentPageNumber;
//
//@end
//
//NS_ASSUME_NONNULL_END
