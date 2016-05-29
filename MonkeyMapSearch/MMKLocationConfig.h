

#import <Foundation/Foundation.h>


#define __MAP_USE_AMAP_NOT_BMP__      #开启即切换到高德地图API模式


#ifdef __MAP_USE_AMAP_NOT_BMP__
//使用高德地图检索
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define __MMKReverseGeoCodeResult       AMapReGeocodeSearchResponse
#define __MMKSearchErrorCode            int

#define __MMKPoiResult                  AMapSearchObject

#define __MMKSearchObject               AMapSearchObject

#else
//使用百度地图检索
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


#define __MMKReverseGeoCodeResult       BMKReverseGeoCodeResult
#define __MMKSearchErrorCode            BMKSearchErrorCode

#define __MMKPoiResult                  BMKPoiResult
#define __MMKSearchObject               BMKBasePoiSearchOption

 

#endif
 
