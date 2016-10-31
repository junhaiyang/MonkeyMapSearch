 

#import "MMKUserLocationOperation.h" 


    
#ifdef __MAP_USE_AMAP_NOT_BMP__
@interface MMKUserLocationOperation()<AMapLocationManagerDelegate>{
    
   __block AMapLocationManager *myLocService;
    
}

@end
#else
@interface MMKUserLocationOperation()<BMKLocationServiceDelegate>{
    
  __block  BMKLocationService *myLocService;
    
}
    
    @end
#endif

@implementation MMKUserLocationOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mycoordinate =kCLLocationCoordinate2DInvalid;
    }
    return self;
}

-(void)main{
    
    dispatch_mmk_main_sync_undeadlock_fun(^{
    
#ifdef __MAP_USE_AMAP_NOT_BMP__
    
    myLocService = [[AMapLocationManager alloc]init];
    myLocService.delegate = self; 
    [myLocService startUpdatingLocation];
    
#else
    
    myLocService = [[BMKLocationService alloc]init];
    myLocService.delegate = self;
    [myLocService startUserLocationService];
    
#endif
    });

}
-(void)timeoutMethod{
    [self stopLocation];
}
- (void)stopLocation{
#ifdef __MAP_USE_AMAP_NOT_BMP__
    
    [myLocService stopUpdatingLocation];
    
#else
    
    [myLocService stopUserLocationService];
    
#endif
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
    [self finishMethod];
}

#ifdef __MAP_USE_AMAP_NOT_BMP__


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
        self.mycoordinate = location.coordinate;
        [self stopLocation];
    }
}


#else
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    NSLog(@"纬度:%f",userLocation.location.coordinate.latitude);
    NSLog(@"经度:%f",userLocation.location.coordinate.longitude);
    
    if(CLLocationCoordinate2DIsValid(userLocation.location.coordinate)){
        self.mycoordinate = userLocation.location.coordinate;
        [self stopLocation];
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    self.myerror =error;
    [self stopLocation];
}

#endif


@end
