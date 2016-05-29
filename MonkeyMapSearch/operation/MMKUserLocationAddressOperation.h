 

#import "MMKCustomLocationOperation.h"
#import "MMKLocationConfig.h"

@interface MMKUserLocationAddressOperation : MMKCustomLocationOperation

@property(assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) __MMKReverseGeoCodeResult* result;


@property(strong, nonatomic) NSError *myerror;
@property(assign, nonatomic) __MMKSearchErrorCode errorCode;

@end
