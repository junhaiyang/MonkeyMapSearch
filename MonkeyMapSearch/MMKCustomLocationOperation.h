 

#import <Foundation/Foundation.h>


void dispatch_mmk_main_sync_undeadlock_fun(dispatch_block_t block);

extern NSString *const kMMKCustomLocationOperationDellocNotifacation;

@interface MMKCustomLocationOperation : NSOperation

@property (nonatomic,assign) NSTimeInterval timeout;


-(void)timeoutMethod;
-(void)finishMethod;

-(void)clearAll;

@end
