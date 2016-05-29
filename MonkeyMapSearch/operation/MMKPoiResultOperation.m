 

#import "MMKPoiResultOperation.h"

#ifdef __MAP_USE_AMAP_NOT_BMP__
@interface MMKPoiResultOperation()<AMapSearchDelegate>{
    
    AMapSearchAPI *_searcher;
}

@end

#else
@interface MMKPoiResultOperation()<BMKPoiSearchDelegate>{
    
    BMKPoiSearch *_searcher;
}

@end

#endif 

@implementation MMKPoiResultOperation

-(void)main{
    
    
#ifdef __MAP_USE_AMAP_NOT_BMP__
    
    
    
#pragma mark - AMapPOISearchBaseRequest
    
    
    _searcher =[[AMapSearchAPI alloc]init];
    _searcher.delegate = self;
    
    if([self.searchOption isKindOfClass:[AMapPOIIDSearchRequest class]]){
        [_searcher AMapPOIIDSearch:(AMapPOIIDSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapPOIKeywordsSearchRequest class]]){
          [_searcher AMapPOIKeywordsSearch:(AMapPOIKeywordsSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapPOIAroundSearchRequest class]]){
        [_searcher AMapPOIAroundSearch:(AMapPOIAroundSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapPOIPolygonSearchRequest class]]){
         [_searcher AMapPOIPolygonSearch:(AMapPOIPolygonSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapInputTipsSearchRequest class]]){
        [_searcher AMapInputTipsSearch:(AMapInputTipsSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapGeocodeSearchRequest class]]){
        [_searcher AMapGeocodeSearch:(AMapGeocodeSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapReGeocodeSearchRequest class]]){
        [_searcher AMapReGoecodeSearch:(AMapReGeocodeSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapBusStopSearchRequest class]]){
        [_searcher AMapBusStopSearch:(AMapBusStopSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapBusLineNameSearchRequest class]]){
        [_searcher AMapBusLineNameSearch:(AMapBusLineNameSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapBusLineIDSearchRequest class]]){
        [_searcher AMapBusLineIDSearch:(AMapBusLineIDSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapDistrictSearchRequest class]]){
        [_searcher AMapDistrictSearch:(AMapDistrictSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapDrivingRouteSearchRequest class]]){
        [_searcher AMapDrivingRouteSearch:(AMapDrivingRouteSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapWalkingRouteSearchRequest class]]){
        [_searcher AMapWalkingRouteSearch:(AMapWalkingRouteSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapTransitRouteSearchRequest class]]){
        [_searcher AMapTransitRouteSearch:(AMapTransitRouteSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapWeatherSearchRequest class]]){
        [_searcher AMapWeatherSearch:(AMapWeatherSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapNearbySearchRequest class]]){
        [_searcher AMapNearbySearch:(AMapNearbySearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapCloudPOIAroundSearchRequest class]]){
        [_searcher AMapCloudPOIAroundSearch:(AMapCloudPOIAroundSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapCloudPOIPolygonSearchRequest class]]){
        [_searcher AMapCloudPOIPolygonSearch:(AMapCloudPOIPolygonSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapCloudPOIIDSearchRequest class]]){
        [_searcher AMapCloudPOIIDSearch:(AMapCloudPOIIDSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapLocationShareSearchRequest class]]){
        [_searcher AMapLocationShareSearch:(AMapLocationShareSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapPOIShareSearchRequest class]]){
        [_searcher AMapPOIShareSearch:(AMapPOIShareSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapRouteShareSearchRequest class]]){
        [_searcher AMapRouteShareSearch:(AMapRouteShareSearchRequest *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[AMapNavigationShareSearchRequest class]]){
        [_searcher AMapNavigationShareSearch:(AMapNavigationShareSearchRequest *)self.searchOption];
    }
     
#else
    
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    
    BOOL result = NO;
    if([self.searchOption isKindOfClass:[BMKCitySearchOption class]]){
        result =[_searcher poiSearchInCity:(BMKCitySearchOption *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[BMKBoundSearchOption class]]){
        result = [_searcher poiSearchInbounds:(BMKBoundSearchOption *)self.searchOption];
    }else if([self.searchOption isKindOfClass:[BMKNearbySearchOption class]]){
        result = [_searcher poiSearchNearBy:(BMKNearbySearchOption *)self.searchOption];
    }
     if(!result)
        [self finishMethod];
#endif
    
}
-(void)timeoutMethod{
    _searcher.delegate = nil;
    
    _searcher = nil;
    [super timeoutMethod];
}


#ifdef __MAP_USE_AMAP_NOT_BMP__

#pragma mark - AMapSearchDelegate

/**
 *  当请求发生错误时，会调用代理的此方法.
 *
 *  @param request 发生错误的请求.
 *  @param error   返回的错误.
 */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    self.errorCode = (int)error.code;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

/**
 *  POI查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapPOISearchBaseRequest 及其子类。
 *  @param response 响应结果，具体字段参考 AMapPOISearchResponse 。
 */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

/**
 *  地理编码查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapGeocodeSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapGeocodeSearchResponse 。
 */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

/**
 *  逆地理编码查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapReGeocodeSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapReGeocodeSearchResponse 。
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

/**
 *  输入提示查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapInputTipsSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapInputTipsSearchResponse 。
 */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

/**
 *  公交站查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapBusStopSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapBusStopSearchResponse 。
 */
- (void)onBusStopSearchDone:(AMapBusStopSearchRequest *)request response:(AMapBusStopSearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

/**
 *  公交线路关键字查询回调
 *
 *  @param request  发起的请求，具体字段参考 AMapBusLineSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapBusLineSearchResponse 。
 */
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

/**
 *  行政区域查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapDistrictSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapDistrictSearchResponse 。
 */
- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

/**
 *  路径规划查询回调
 *
 *  @param request  发起的请求，具体字段参考 AMapRouteSearchBaseRequest 及其子类。
 *  @param response 响应结果，具体字段参考 AMapRouteSearchResponse 。
 */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

/**
 *  天气查询回调
 *
 *  @param request  发起的请求，具体字段参考 AMapWeatherSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapWeatherSearchResponse 。
 */
- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

#pragma mark - 附近搜索回调

/**
 *  附近搜索回调
 *
 *  @param request  发起的请求，具体字段参考 AMapNearbySearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapNearbySearchResponse 。
 */
- (void)onNearbySearchDone:(AMapNearbySearchRequest *)request response:(AMapNearbySearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

#pragma mark - 云图搜索回调

/**
 *   云图查询回调函数
 *
 *   @param request 发起的请求，具体字段参考AMapCloudSearchBaseRequest 。
 *   @param response 响应结果，具体字段参考 AMapCloudPOISearchResponse 。
 */
- (void)onCloudSearchDone:(AMapCloudSearchBaseRequest *)request response:(AMapCloudPOISearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

#pragma mark - 短串分享搜索回调

/**
 *  短串分享搜索回调
 *
 *  @param request  发起的请求
 *  @param response 相应结果，具体字段参考 AMapShareSearchResponse。
 */
- (void)onShareSearchDone:(AMapShareSearchBaseRequest *)request response:(AMapShareSearchResponse *)response{
    
    self.poiResult =response;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}


#else
#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)mypoiResult errorCode:(BMKSearchErrorCode)error{
    
    self.errorCode = error;
    
    if(error==BMK_SEARCH_NO_ERROR)
        self.poiResult =mypoiResult;
    
    _searcher.delegate = nil;
    
    _searcher = nil;
    
    [self finishMethod];
}

#endif

@end
