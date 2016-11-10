 

#import <Foundation/Foundation.h>
#import "MMKLocationConfig.h"
#import "MMKCustomLocationOperation.h"
 


// 获取定位经纬度  或者 通过地址信息获取经纬度
typedef void(^MMKLocationLoaderCoordinateBlock)(BOOL successful, CLLocationCoordinate2D coordinate,NSError *error);  //获取经纬度

typedef void(^MMKLocationLoaderCoordinateByAddressBlock)(BOOL successful, CLLocationCoordinate2D coordinate,__MMKSearchErrorCode errorCode);  //获取经纬度

typedef void(^MMKLocationLoaderReverseGeoCodeBlock)(BOOL successful, __MMKReverseGeoCodeResult *result,__MMKSearchErrorCode errorCode); //通过经纬度获取地址信息

typedef void(^MMKLocationLoaderCoordinateAddressBlock)(BOOL successful, CLLocationCoordinate2D coordinate, __MMKReverseGeoCodeResult *result,__MMKSearchErrorCode errorCode,NSError *error);  //获取经纬度
//前面三个是最常用的API
typedef void(^MMKLocationLoaderPoiResultBlock)(BOOL successful, __MMKPoiResult *poiResult,__MMKSearchErrorCode errorCode);           //周边信息检索

#ifndef __MAP_USE_AMAP_NOT_BMP__
typedef void(^MMKLocationLoaderPoiDetailResultBlock)(BOOL successful, BMKPoiDetailResult *poiDetailResult,BMKSearchErrorCode errorCode);           //周边详细信息检索

#endif
 

@interface MMKLocationLoader : NSObject


+(MMKLocationLoader *)shareInstance;

+(void)requestWhenInUseAuthorization;

+(void)requestAlwaysAuthorization;

+(void)checkAuthorization;


- (void)configureMap:(NSString *)mapKey;

//获取经纬度
-(MMKCustomLocationOperation *)startLoadCoordinate:(MMKLocationLoaderCoordinateBlock)finishedBlock;

//通过地址信息获取经纬度
-(MMKCustomLocationOperation *)startLoadCoordinateByAddress:(NSString *)address finishedBlock:(MMKLocationLoaderCoordinateByAddressBlock)finishedBlock;

//获取经纬度和地址信息
-(MMKCustomLocationOperation *)startLoadCoordinateAndAddress:(MMKLocationLoaderCoordinateAddressBlock)finishedBlock;

//经纬度获取地址信息
-(MMKCustomLocationOperation *)startLoadReverseGeoCode:(CLLocationCoordinate2D)coordinate finishedBlock:(MMKLocationLoaderReverseGeoCodeBlock)finishedBlock;

//周边信息检索
-(MMKCustomLocationOperation *)startLoadPoiSearch:(__MMKSearchObject *)poiSearch finishedBlock:(MMKLocationLoaderPoiResultBlock)finishedBlock;

#ifndef __MAP_USE_AMAP_NOT_BMP__ 
//周边详细信息检索
-(MMKCustomLocationOperation *)startLoadPoiDetailSearch:(BMKPoiDetailSearchOption *)poiSearch finishedBlock:(MMKLocationLoaderPoiDetailResultBlock)finishedBlock;
#endif

-(void)cancelAllLoad;


@end
