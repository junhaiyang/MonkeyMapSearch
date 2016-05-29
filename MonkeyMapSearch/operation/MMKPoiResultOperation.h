 

#import "MMKCustomLocationOperation.h"
#import "MMKLocationConfig.h"

@interface MMKPoiResultOperation : MMKCustomLocationOperation

@property (nonatomic,strong) __MMKSearchObject *searchOption;
@property (nonatomic,strong) __MMKPoiResult *poiResult;

@property(assign, nonatomic) __MMKSearchErrorCode errorCode;

@end

