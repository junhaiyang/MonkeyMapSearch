 

#import "MMKCustomLocationOperation.h"
#import "MMKLocationConfig.h"

@interface MMKReverseGeoCodeOperation : MMKCustomLocationOperation

@property(assign, nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) __MMKReverseGeoCodeResult *result;

@property(assign, nonatomic) __MMKSearchErrorCode errorCode;

@end
