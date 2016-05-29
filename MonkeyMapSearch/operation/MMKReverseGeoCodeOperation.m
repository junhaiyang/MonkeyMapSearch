 

#import "MMKReverseGeoCodeOperation.h"


#ifdef __MAP_USE_AMAP_NOT_BMP__
@interface MMKReverseGeoCodeOperation()<AMapSearchDelegate>{
    
    AMapSearchAPI *search;
}

@end

#else
@interface MMKReverseGeoCodeOperation()<BMKGeoCodeSearchDelegate>{
    
    BMKGeoCodeSearch *search;
}

@end

#endif 

@implementation MMKReverseGeoCodeOperation

-(void)main{
    
#ifdef __MAP_USE_AMAP_NOT_BMP__
    
    
    search = [[AMapSearchAPI alloc]init];
    search.delegate = self;
    
    AMapReGeocodeSearchRequest *request =[[AMapReGeocodeSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    request.radius = 100;
    request.requireExtension = NO;
    
    [search AMapReGoecodeSearch:request];
    
    
#else
    
    search = [[BMKGeoCodeSearch alloc]init];
    search.delegate = self;
    BMKReverseGeoCodeOption *reverseGeoCodeOption =[[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = self.coordinate;
    if(![search reverseGeoCode:reverseGeoCodeOption]){
        NSLog(@"===============");
        [self cancel];
    }
    
#endif
     
}
-(void)timeoutMethod{
    search.delegate = nil;
    
    search = nil;
    [super timeoutMethod];
}


#ifdef __MAP_USE_AMAP_NOT_BMP__


- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    self.errorCode = (int)error.code;
    
    search.delegate = nil;
    
    search = nil;
    
    [self finishMethod];
}

/**
 *  逆地理编码查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapReGeocodeSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapReGeocodeSearchResponse 。
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    self.result =response;
    
    search.delegate = nil;
    
    search = nil;
    
    [self finishMethod];
    
}

#else

#pragma mark - BMKGeoCodeSearchDelegate
 
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    self.errorCode = error;
    
    
    if(error==BMK_SEARCH_NO_ERROR)
        self.result =result;
     
    search.delegate = nil;
    
    search = nil;
    
    [self finishMethod];
    
}
#endif
@end
