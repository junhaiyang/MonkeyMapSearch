 

#import "MMKCustomLocationOperation.h"
#import "MMKLocationConfig.h"

@interface MMKUserLocationOperation : MMKCustomLocationOperation


@property(assign, nonatomic) CLLocationCoordinate2D mycoordinate;
@property(strong, nonatomic) NSError *myerror;

@end
