//
//  OocrSettings.m
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

#import "OcrSettings.h"

@implementation OcrSettings

-(id) init
{
    self = [super init];
    if(self){
        languages = malloc(LANG_SIZE*sizeof(LANG_ENA));
        
        singleColumn = NO;
        columnSelect = NO;
        mPage = 0;
        
        NSError *err = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fi" ofType:@"dic"];
        NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
        
        NSArray* testArray = [contents componentsSeparatedByString:@"\n"];
        
        fiDict = [NSDictionary dictionaryWithObjects:testArray
                                             forKeys:testArray];
        
        path = [[NSBundle mainBundle] pathForResource:@"no" ofType:@"dic"];
        contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
        
        testArray = [contents componentsSeparatedByString:@"\n"];
        
        noDict = [NSDictionary dictionaryWithObjects:testArray
                                             forKeys:testArray];
        
        charSet = [[NSMutableCharacterSet alloc] init];
        
        [charSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
        
        [charSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    }
    return self;
}

-(HPAGE) getPage
{
    return mPage;
}

-(void) setPage:(HPAGE)page
{
    mPage = page;
}

-(void) freePage
{
    if(mPage != 0){
        kRecFreeImg(mPage);
        mPage = 0;
    }
}

-(NSDictionary*) getFiDict
{
    return fiDict;
}

-(NSDictionary*) getNoDict
{
    return noDict;
}

-(NSMutableCharacterSet*) getCharSet
{
    return charSet;
}

-(BOOL) getSingleColumn
{
    return singleColumn;
}

-(void)setLanguages:(NSArray*)aLanguages
{
    mLanguages = aLanguages;
    
    for(int i = 0 ; i < LANG_SIZE ; i++) languages[i] = LANG_DISABLED;
    
    for(NSString *str in aLanguages){
        if([str isEqualToString:@"sv"]){
            languages[LANG_SWE] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"en"]){
            languages[LANG_ENG] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"de"]){
            languages[LANG_GER] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"fr"]){
            languages[LANG_FRE] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"fi"]){
            languages[LANG_FIN] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"nl"]){
            languages[LANG_DUT] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"da"]){
            languages[LANG_DAN] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"nb"]){
            languages[LANG_NOR] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"es"]){
            languages[LANG_SPA] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"it"]){
            languages[LANG_ITA] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"pt"]){
            languages[LANG_POR] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"pl"]){
            languages[LANG_POL] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"cs"]){
            languages[LANG_CZH] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"sk"]){
            languages[LANG_SLK] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"hu"]){
            languages[LANG_HUN] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"ro"]){
            languages[LANG_ROM] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"ru"]){
            languages[LANG_RUS] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"tr"]){
            languages[LANG_TUR] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"id"]){
            languages[LANG_IND] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"el"]){
            languages[LANG_GRE] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"ar"]){
            languages[LANG_ARA] = LANG_ENABLED;
        }
        else if([str isEqualToString:@"he"]){
            languages[LANG_HEB] = LANG_ENABLED;
        }
    }
}

-(NSArray*) getLanguages
{
    return mLanguages;
}

-(LANG_ENA*) getLanguageEnums
{
    return languages;
}

-(void) setSingleColumn:(BOOL)value
{
    singleColumn = !value;
}

-(void) setColummSelector:(BOOL)value
{
    columnSelect = value;
}

-(BOOL) getColummSelector
{
    return columnSelect;
}

-(void) setAppend:(BOOL)app
{
    mAppend = app;
}

-(bool) append
{
    return mAppend;
}

@end
