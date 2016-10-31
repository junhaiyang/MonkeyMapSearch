

#import "MMKLocationLoader.h" 

#import "MMKUserLocationOperation.h"
#import "MMKReverseGeoCodeOperation.h"
#import "MMKGeoCodeOperation.h"
#import "MMKPoiDetailResultOperation.h"
#import "MMKPoiResultOperation.h"
#import "MMKUserLocationAddressOperation.h"


#ifdef __MAP_USE_AMAP_NOT_BMP__

@interface MMKLocationLoader(){
    
    NSOperationQueue *operationQueue;
    dispatch_queue_t operation_queue;
    NSObject *lock;
    
}

@end

#else

@interface MMKLocationLoader()<BMKGeneralDelegate>{
    
    NSOperationQueue *operationQueue;
    dispatch_queue_t operation_queue;
    NSObject *lock;
    BMKMapManager *_mapManager;
    
}

@end

#endif

@implementation MMKLocationLoader


+(MMKLocationLoader *)shareInstance{
    static MMKLocationLoader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MMKLocationLoader alloc] init];
    });
    
    return sharedInstance;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        operation_queue = dispatch_queue_create("MMKLocationLoader", DISPATCH_QUEUE_CONCURRENT );
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationFinished:) name:kMMKCustomLocationOperationDellocNotifacation object:nil];
        lock = [[NSObject alloc] init];
        
        operationQueue =[[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:1];
        
    }
    return self;
}

- (void)configureMap:(NSString *)mapKey{
    
#ifdef __MAP_USE_AMAP_NOT_BMP__
    
    [AMapLocationServices sharedServices].apiKey = mapKey;
    [AMapServices sharedServices].apiKey = mapKey;
    
    
#else
    
    // 要使用百度地图， 启动BMKMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:mapKey generalDelegate:self];
    if (ret) {
        NSLog(@"百度地图启动成功");
    }
    
#endif
    
    
}

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError{
    NSLog(@"onGetNetworkState：%d",iError);
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError{
    NSLog(@"onGetPermissionState：%d",iError);
}
-(void)processOperationQueue{
    @synchronized (lock) {
        
        int liveCount =0;
        
        for (NSOperation *operation in operationQueue.operations) {
            if(![operation isFinished]){
                liveCount++;
            }
        }
        
        if(liveCount==0){
            [self cancelAllLoad];
        }
        
        
    }
}
-(void)addOperationQueue:(NSOperation *)operation{
    @synchronized (lock) {
        [operationQueue addOperation:operation];
    }
}

-(void)operationFinished:(NSNotification *)noti{
    __weak typeof(MMKLocationLoader *) weakSelf = self;
    
    dispatch_async(operation_queue, ^{
        [weakSelf processOperationQueue];
    });
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+(void)checkAuthorization{
    
    if(![CLLocationManager locationServicesEnabled]){
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
#endif
    }
}
-(BOOL)isAuthorization{
    [MMKLocationLoader checkAuthorization];
    
//   return  [CLLocationManager locationServicesEnabled] ;
    
    //#if TARGET_IPHONE_SIMULATOR//模拟器
    //    return NO;
    //#elif TARGET_OS_IPHONE//真机
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        return  [CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways);
    }else{
        return  [CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways);
    }

//
//    // User has granted authorization to use their location at any time,
//    // including monitoring for regions, visits, or significant location changes.
//    kCLAuthorizationStatusAuthorizedAlways NS_ENUM_AVAILABLE(NA, 8_0),
//    
//    // User has granted authorization to use their location only when your app
//    // is visible to them (it will be made visible to them if you continue to
//    // receive location updates while in the background).  Authorization to use
//    // launch APIs has not been granted.
//    kCLAuthorizationStatusAuthorizedWhenInUse NS_ENUM_AVAILABLE(NA, 8_0),
//    
//    // This value is deprecated, but was equivalent to the new -Always value.
//    kCLAuthorizationStatusAuthorized NS_ENUM_DEPRECATED(10_6, NA, 2_0, 8_0, "Use kCLAuthorizationStatusAuthorizedAlways") __TVOS_PROHIBITED __WATCHOS_PROHIBITED = kCLAuthorizationStatusAuthorizedAlways
}

+(BOOL)CLLocationCoordinate2DIsValid:(CLLocationCoordinate2D)coordinate{
    if(CLLocationCoordinate2DIsValid(coordinate)){
        if(coordinate.longitude==0.0&&coordinate.longitude==0.0){
            return NO;
        }
        return YES;
    }

    return NO;
}

//获取经纬度
-(MMKCustomLocationOperation *)startLoadCoordinate:(MMKLocationLoaderCoordinateBlock)finishedBlock{
    if(self.isAuthorization){
        
        MMKUserLocationOperation *operation = [[MMKUserLocationOperation alloc] init];
        operation.timeout =10.0;
        
        __block MMKLocationLoaderCoordinateBlock blockFinishedBlock =finishedBlock;
        __weak MMKUserLocationOperation *blockOperation =operation;
        
        [operation  setCompletionBlock:^{
            dispatch_mmk_main_sync_undeadlock_fun(^{
                
                if(blockFinishedBlock){
                    if([MMKLocationLoader CLLocationCoordinate2DIsValid:blockOperation.mycoordinate] ){
                        blockFinishedBlock(true,blockOperation.mycoordinate,blockOperation.myerror);
                    }else{
                        blockFinishedBlock(false,kCLLocationCoordinate2DInvalid,nil);
                    }
                }
                [blockOperation clearAll];
            });
            
        }];
        
        [self addOperationQueue:operation];

        return operation;
    
    }else{
//#if TARGET_IPHONE_SIMULATOR//模拟器
//        if(finishedBlock){
//            finishedBlock(true,CLLocationCoordinate2DMake(116.403875, 39.915168),nil);
//        }
//#elif TARGET_OS_IPHONE//真机
        if(finishedBlock){
            finishedBlock(false,kCLLocationCoordinate2DInvalid,nil);
        }
//#endif
    }
    return nil;
}

//通过地址信息获取经纬度
-(MMKCustomLocationOperation *)startLoadCoordinateByAddress:(NSString *)address finishedBlock:(MMKLocationLoaderCoordinateByAddressBlock)finishedBlock{
    if(self.isAuthorization){
        
        
        MMKGeoCodeOperation *operation = [[MMKGeoCodeOperation alloc] init];
        operation.timeout =6.0;
        operation.address = address;
        
        __block MMKLocationLoaderCoordinateByAddressBlock blockFinishedBlock =finishedBlock;
        __weak MMKGeoCodeOperation *blockOperation =operation;
        
        [operation  setCompletionBlock:^{
            dispatch_mmk_main_sync_undeadlock_fun(^{
                
                if(blockFinishedBlock){
                    if([MMKLocationLoader CLLocationCoordinate2DIsValid:blockOperation.coordinate]){
                        blockFinishedBlock(true,blockOperation.coordinate,blockOperation.errorCode);
                    }else{
                        blockFinishedBlock(false,kCLLocationCoordinate2DInvalid,blockOperation.errorCode);
                    }
                }
                [blockOperation clearAll];
            });
            
        }];
        
        [self addOperationQueue:operation];
        
        return operation;
        
        
    }else{
        if(finishedBlock){
            finishedBlock(false,kCLLocationCoordinate2DInvalid,0);
        }
    }
    return nil;
}
-(MMKCustomLocationOperation *)startLoadCoordinateAndAddress:(MMKLocationLoaderCoordinateAddressBlock)finishedBlock{
    if(self.isAuthorization){
        
        MMKUserLocationAddressOperation *operation = [[MMKUserLocationAddressOperation alloc] init];
        operation.timeout =14.0;
        
        __block MMKLocationLoaderCoordinateAddressBlock blockFinishedBlock =finishedBlock;
        __weak MMKUserLocationAddressOperation *blockOperation =operation;
        
        [operation  setCompletionBlock:^{
            
            dispatch_mmk_main_sync_undeadlock_fun(^{
                
                if(blockFinishedBlock){
                    if([MMKLocationLoader CLLocationCoordinate2DIsValid:blockOperation.coordinate]&&blockOperation.result){
                        blockFinishedBlock(true,blockOperation.coordinate,blockOperation.result,blockOperation.errorCode,blockOperation.myerror);
                    }else{
                        blockFinishedBlock(false,kCLLocationCoordinate2DInvalid,nil,blockOperation.errorCode,blockOperation.myerror);
                    }
                }
                
                [blockOperation clearAll];
            });
             
            
        }];
        
        [self addOperationQueue:operation];
        
        return operation;
        
    }else{
        if(finishedBlock){
            finishedBlock(false,kCLLocationCoordinate2DInvalid,nil,0,nil);
        }
    }
    return nil;
}

//经纬度获取地址信息
-(MMKCustomLocationOperation *)startLoadReverseGeoCode:(CLLocationCoordinate2D)coordinate finishedBlock:(MMKLocationLoaderReverseGeoCodeBlock)finishedBlock{
    if(self.isAuthorization){
        
        
        MMKReverseGeoCodeOperation *operation = [[MMKReverseGeoCodeOperation alloc] init];
        operation.timeout =6.0;
        operation.coordinate = coordinate;
        
        __block MMKLocationLoaderReverseGeoCodeBlock blockFinishedBlock =finishedBlock;
        __weak MMKReverseGeoCodeOperation *blockOperation =operation;
        
        [operation  setCompletionBlock:^{
            
            dispatch_mmk_main_sync_undeadlock_fun(^{
                if(blockFinishedBlock){
                    if(blockOperation.result)
                        blockFinishedBlock(true,blockOperation.result,blockOperation.errorCode);
                    else
                        blockFinishedBlock(false,nil,blockOperation.errorCode);
                }
                [blockOperation clearAll];
            });
            
        }];
        
        [self addOperationQueue:operation];
        
        return operation;
        
        
    }else{
        if(finishedBlock){
            finishedBlock(false,nil,0);
        }
    }
    return nil;
}


//周边信息检索
-(MMKCustomLocationOperation *)startLoadPoiSearch:(__MMKSearchObject *)poiSearch finishedBlock:(MMKLocationLoaderPoiResultBlock)finishedBlock{
    if(self.isAuthorization){
        
        MMKPoiResultOperation *operation = [[MMKPoiResultOperation alloc] init];
        operation.timeout =6.0;
        operation.searchOption = poiSearch;
        
        __block MMKLocationLoaderPoiResultBlock blockFinishedBlock =finishedBlock;
        __weak MMKPoiResultOperation *blockOperation =operation;
        
        [operation  setCompletionBlock:^{
            
            dispatch_mmk_main_sync_undeadlock_fun(^{
                if(blockFinishedBlock){
                    if(blockOperation.poiResult)
                        blockFinishedBlock(true,blockOperation.poiResult,blockOperation.errorCode);
                    else
                        blockFinishedBlock(false,nil,blockOperation.errorCode);
                }
                [blockOperation clearAll];
            });
            
        }];
        
        [self addOperationQueue:operation];
        
        return operation;
        
        
    }else{
        if(finishedBlock){
            finishedBlock(false,nil,0);
        }
    }
    return nil;
}


#ifndef __MAP_USE_AMAP_NOT_BMP__
//周边详细信息检索
-(MMKCustomLocationOperation *)startLoadPoiDetailSearch:(BMKPoiDetailSearchOption *)poiSearch finishedBlock:(MMKLocationLoaderPoiDetailResultBlock)finishedBlock{
    if(self.isAuthorization){
        
        
        MMKPoiDetailResultOperation *operation = [[MMKPoiDetailResultOperation alloc] init];
        operation.timeout =6.0;
        operation.searchDetailOption =poiSearch;
        
        __block MMKLocationLoaderPoiDetailResultBlock blockFinishedBlock =finishedBlock;
        __weak MMKPoiDetailResultOperation *blockOperation =operation;
        
        [operation  setCompletionBlock:^{
            
            dispatch_mmk_main_sync_undeadlock_fun(^{
                if(blockFinishedBlock){
                    if(blockOperation.poiDetailResult)
                        blockFinishedBlock(true,blockOperation.poiDetailResult,blockOperation.errorCode);
                    else
                        blockFinishedBlock(false,nil,blockOperation.errorCode);
                }
                [blockOperation clearAll];
            });
            
        }];
        
        [self addOperationQueue:operation];
        
        return operation;
        
    }else{
        if(finishedBlock){
            finishedBlock(false,nil,0);
        }
    }
    return nil;
}
#endif

-(void)cancelAllLoad{
    [operationQueue cancelAllOperations];
    operationQueue = nil;
    
    operationQueue =[[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:1];
}

@end
