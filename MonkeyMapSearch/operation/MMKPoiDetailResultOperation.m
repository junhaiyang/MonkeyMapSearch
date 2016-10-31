 

#import "MMKPoiDetailResultOperation.h"

#ifndef __MAP_USE_AMAP_NOT_BMP__
@interface MMKPoiDetailResultOperation()<BMKPoiSearchDelegate>{
    
  __block  BMKPoiSearch *_searcher;
}

@end

#endif

@implementation MMKPoiDetailResultOperation

#ifndef __MAP_USE_AMAP_NOT_BMP__

-(void)main{
    dispatch_mmk_main_sync_undeadlock_fun(^{
    
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    
    if(![_searcher poiDetailSearch: self.searchDetailOption]){
        [self finishMethod];
    }
    });
     
    
    
}
-(void)timeoutMethod{
    _searcher.delegate = nil;
    
    _searcher = nil;
    [super timeoutMethod];
}
#pragma mark - BMKPoiSearchDelegate

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)mypoiDetailResult errorCode:(BMKSearchErrorCode)error{
    self.errorCode = error;
    
    if(error==BMK_SEARCH_NO_ERROR)
        self.poiDetailResult =mypoiDetailResult;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

#endif
@end
