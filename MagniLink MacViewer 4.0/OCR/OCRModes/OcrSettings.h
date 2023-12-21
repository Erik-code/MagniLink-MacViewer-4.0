//
//  OocrSettings.h
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

#import <Foundation/Foundation.h>
#import <Nuance-OmniPage-CSDK/KernelAPI.h>

NS_ASSUME_NONNULL_BEGIN

@interface OcrSettings : NSObject
{
    NSArray* mLanguages;
    LANG_ENA* languages;
    bool singleColumn;
    bool columnSelect;
    bool mAppend;
    NSDictionary *fiDict;
    NSDictionary *noDict;
    NSMutableCharacterSet* charSet;
    HPAGE mPage;
}

-(void) setLanguages:(NSArray*)aLanguages;
-(NSMutableCharacterSet*) getCharSet;
-(void) setSingleColumn:(BOOL)value;
-(BOOL) getSingleColumn;
-(void) setColummSelector:(BOOL)value;
-(BOOL) getColummSelector;
-(void) setAppend:(BOOL)value;
-(NSArray*) getLanguages;
-(LANG_ENA*) getLanguageEnums;
-(NSDictionary*) getFiDict;
-(NSDictionary*) getNoDict;
-(HPAGE) getPage;
-(void) setPage:(HPAGE)page;
-(void) freePage;

@end



NS_ASSUME_NONNULL_END
