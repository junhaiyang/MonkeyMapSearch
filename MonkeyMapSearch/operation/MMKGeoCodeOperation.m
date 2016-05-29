 

#import "MMKGeoCodeOperation.h"

#ifdef __MAP_USE_AMAP_NOT_BMP__
@interface MMKGeoCodeOperation()<AMapSearchDelegate>{
    
    AMapSearchAPI *search;
}

@end

#else
@interface MMKGeoCodeOperation()<BMKGeoCodeSearchDelegate>{
    
    BMKGeoCodeSearch *search;
}

@end

#endif


@implementation MMKGeoCodeOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.coordinate =kCLLocationCoordinate2DInvalid;
    }
    return self;
}

-(void)main{
    
    
    
    
#ifdef __MAP_USE_AMAP_NOT_BMP__
    
    
    search = [[AMapSearchAPI alloc]init];
    search.delegate = self;
    
    AMapGeocodeSearchRequest *request =[[AMapGeocodeSearchRequest alloc] init];
    
    
    request.address = self.address;
    request.city = self.address;
     
    
    [search AMapGeocodeSearch:request];
    
    
#else
    
    search = [[BMKGeoCodeSearch alloc]init];
    search.delegate = self;
    BMKGeoCodeSearchOption *reverseGeoCodeOption =[[BMKGeoCodeSearchOption alloc] init];
    reverseGeoCodeOption.address = self.address;
    if(![search geoCode:reverseGeoCodeOption]){
        NSLog(@"===============");
        [self finishMethod];
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
 *  地理编码查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapGeocodeSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapGeocodeSearchResponse 。
 */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    
    if(response.count>0){
        AMapGeocode *mapGeocode = [response.geocodes firstObject];
        self.coordinate = CLLocationCoordinate2DMake(mapGeocode.location.latitude, mapGeocode.location.longitude);
    }
    
    search.delegate = nil;
    
    search = nil;
    
    [self finishMethod];
    
}

#else
#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    self.errorCode = error;
    if(error==BMK_SEARCH_NO_ERROR)
        self.coordinate =result.location;
    
    search.delegate = nil;
    
    search = nil;
    
    [self finishMethod];
}
#endif
 
@end
