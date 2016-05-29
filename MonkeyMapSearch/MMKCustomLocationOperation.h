 

#import <Foundation/Foundation.h>

extern NSString *const kMMKCustomLocationOperationDellocNotifacation;

@interface MMKCustomLocationOperation : NSOperation

@property (nonatomic,assign) NSTimeInterval timeout;


-(void)timeoutMethod;
-(void)finishMethod;

-(void)clearAll;

@end
