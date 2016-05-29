# MonkeyMapSearch

* 串行化地图API，插件由来是因为百度地图在定位完成前不能执行其它请求，索性就做了这个队列化处理

#####引用

	
    pod 'MonkeyMapConfig', '1.0.BMap'  #1.0.AMap：高德地图   1.0.BMap 百度地图
    pod 'MonkeyMapSearch', '~> 1.0'



#####使用说明

	#import "MonkeyMapSearch.h"
	
	
	//配置地图 apiKey
	[[MMKLocationLoader  shareInstance] configureMap:mapKey]
 	

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
 
	//周边详细信息检索(仅限百度地图)
	-(MMKCustomLocationOperation *)startLoadPoiDetailSearch:(BMKPoiDetailSearchOption *)poiSearch finishedBlock:(MMKLocationLoaderPoiDetailResultBlock)finishedBlock; 

	//取消掉所有正在执行的检索
	-(void)cancelAllLoad;