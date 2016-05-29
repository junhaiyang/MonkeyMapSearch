 

#import "MMKCustomLocationOperation.h"
#import "MMKLocationConfig.h"

@interface MMKGeoCodeOperation : MMKCustomLocationOperation


@property (nonatomic) CLLocationCoordinate2D coordinate;

@property(assign, nonatomic) __MMKSearchErrorCode errorCode;

@property (nonatomic,strong) NSString* address;

@end
