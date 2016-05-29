 

#import "MMKUserLocationAddressOperation.h"


#ifdef __MAP_USE_AMAP_NOT_BMP__
@interface MMKUserLocationAddressOperation()<AMapLocationManagerDelegate,AMapSearchDelegate>{
    
    AMapLocationManager *myLocService;
    AMapSearchAPI *search;
}

@end
    
#else
@interface MMKUserLocationAddressOperation()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
        
        BMKLocationService *myLocService;
        BMKGeoCodeSearch *search;
}
    
@end
        
#endif

@implementation MMKUserLocationAddressOperation
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
    
    myLocService = [[AMapLocationManager alloc]init];
    myLocService.delegate = self;
    [myLocService startUpdatingLocation];
    
#else
    
    myLocService = [[BMKLocationService alloc]init];
    myLocService.delegate = self;
    [myLocService startUserLocationService];
    
#endif
    
    
}
-(void)timeoutMethod{
    
    if(CLLocationCoordinate2DIsValid(self.coordinate)){
        
        search.delegate = nil;
        
        search = nil;
        [super timeoutMethod];
    }else{
        [self stopLocation];
    }
    
}
- (void)stopLocation{
#ifdef __MAP_USE_AMAP_NOT_BMP__
    
    
    [myLocService stopUpdatingLocation];
    
#else
    
    [myLocService stopUserLocationService];
    
#endif
}

-(void)searchAddress:(dispatch_time_t)time{
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        if(!self.isCancelled){
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
    });
}
-(void)clearAll{
    [super clearAll];
    self.result = nil;
    search.delegate = nil;
    search = nil;
    myLocService = nil;
    self.coordinate = kCLLocationCoordinate2DInvalid; 
}
#pragma mark - BMKLocationServiceDelegate

/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    myLocService.delegate = nil;
    myLocService = nil;
    
    if(!CLLocationCoordinate2DIsValid(self.coordinate)){
        [self finishMethod];
    }else{
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
        [self searchAddress:time];
    
    }
}
#ifdef __MAP_USE_AMAP_NOT_BMP__
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    self.myerror =error; 
    
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

/**
 *  当定位发生错误时，会调用代理的此方法。
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    self.myerror =error;
    [self stopLocation];
}

/**
 *  连续定位回调函数
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
    NSLog(@"纬度:%f",location.coordinate.latitude);
    NSLog(@"经度:%f",location.coordinate.longitude);
    
    if(CLLocationCoordinate2DIsValid(location.coordinate)){
        self.coordinate = location.coordinate;
        [self stopLocation];
    }
}

#else

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    NSLog(@"纬度:%f",userLocation.location.coordinate.latitude);
    NSLog(@"经度:%f",userLocation.location.coordinate.longitude);
    
    if(CLLocationCoordinate2DIsValid(userLocation.location.coordinate)){
        self.coordinate = userLocation.location.coordinate;
        [self stopLocation];
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    self.myerror = error;
    [self stopLocation];
}
#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    self.errorCode =error;
    
    if(error==BMK_SEARCH_NO_ERROR)
        self.result =result;
    
    search.delegate = nil;
    
    search = nil;
    
    [self finishMethod];
    
}
#endif
@end
