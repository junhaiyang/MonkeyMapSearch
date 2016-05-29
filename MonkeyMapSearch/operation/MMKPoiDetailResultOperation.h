 

#import "MMKCustomLocationOperation.h"
#import "MMKLocationConfig.h"

@interface MMKPoiDetailResultOperation : MMKCustomLocationOperation

#ifndef __MAP_USE_AMAP_NOT_BMP__ 
@property (nonatomic,strong) BMKPoiDetailSearchOption *searchDetailOption;
@property (nonatomic,strong) BMKPoiDetailResult *poiDetailResult;

@property(assign, nonatomic) BMKSearchErrorCode errorCode;
#endif
@end
