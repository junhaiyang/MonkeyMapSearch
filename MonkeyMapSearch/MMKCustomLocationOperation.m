 

#import "MMKCustomLocationOperation.h"

NSString *const kMMKCustomLocationOperationDellocNotifacation = @"kMMKCustomLocationOperationDellocNotifacation";

@interface MMKCustomLocationOperation(){
    BOOL executing;
    BOOL finished;
    
    CFRunLoopTimerRef timerRef;
    CFRunLoopRef runLoop;
    
    NSRunLoop *currentRunLoop;
    
}
@property (nonatomic) NSTimer * timer;;
@end

@implementation MMKCustomLocationOperation

- (void) start {
    
    if ([self isCancelled]){
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    } else {
        
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeout
                                                 target:self
                                               selector:@selector(innerTimeoutMethod)
                                               userInfo:nil
                                                repeats:NO];
        
        [self didChangeValueForKey:@"isExecuting"];
        
        [self main];
        
        if(![self isFinished]){
//            
//            currentRunLoop =[NSRunLoop currentRunLoop];
//            [currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
//            [currentRunLoop run];
            
            [self createAndScheduleTimerToRunLoopUsingCFRunLoopTimerRef];
            
            if(![self isFinished]){
                [self finishMethod];
            }
        }
        
        
    }
    
    
}
static void myCFTimerCallBack(CFRunLoopTimerRef timer __unused, void *info)

{ 
    
//    CustomLocationOperation *operation = (__bridge CustomLocationOperation *)(info);
//    
//    NSLog(@"====");
    
}
- (void)createAndScheduleTimerToRunLoopUsingCFRunLoopTimerRef
{
    runLoop = CFRunLoopGetCurrent();
    
    CFRunLoopTimerContext timer_context;
    
    bzero(&timer_context, sizeof(timer_context));
    
    timer_context.info = (__bridge void *)(self);
    
    //暂时还有BUG
    timerRef = CFRunLoopTimerCreate(NULL, CFAbsoluteTimeGetCurrent(), 10, 0, 0, myCFTimerCallBack, &timer_context);
    
    // add the CFRunLoopTimerRef to run loop kCFRunLoopCommonModes mode
    CFRunLoopAddTimer(runLoop, timerRef, kCFRunLoopDefaultMode);
    
    CFRunLoopRun();
}
-(void)dealloc{
    [self stopTimerToRunLoopUsingCFRunLoopTimerRef];
    NSLog(@"=======dealloc=====");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMMKCustomLocationOperationDellocNotifacation object:nil];

}
- (void)stopTimerToRunLoopUsingCFRunLoopTimerRef{
//    CFRunLoopRemoveTimer(runLoop,timerRef,kCFRunLoopCommonModes);
    if(runLoop!=NULL){
        CFRunLoopStop(runLoop);
        runLoop = NULL;
        timerRef = NULL;
    }
    
//    CFRunLoopStop( [currentRunLoop getCFRunLoop]);
}
-(void)innerTimeoutMethod{
    NSLog(@"--timeoutMethod--");
    [self cancel];

}
-(void)finishMethod{
    if(self.isCancelled)
        NSLog(@"--cancelMethod--");
    else
        NSLog(@"--finishMethod--");
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    finished = YES;
    executing = NO;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
    if(runLoop!=NULL&&CFRunLoopIsWaiting(runLoop)){
        [self stopTimerToRunLoopUsingCFRunLoopTimerRef];
    }
}

-(void)clearAll{
    if(runLoop!=NULL){
        CFRunLoopStop(runLoop);
        runLoop = NULL;
        timerRef = NULL;
    }
}
- (BOOL) isFinished{
    
    return finished;
}

- (BOOL) isExecuting{
    
    return executing;
}

-(void)timeoutMethod{
    NSLog(@"--timeoutMethod--");
    
}
-(void)cancel{
    [self timeoutMethod];
    [self willChangeValueForKey:@"isCancelled"];
    [super cancel];
    
//    runLoop = (__bridge CFRunLoopRef)currentRunLoop;
    
//    if(CFRunLoopIsWaiting([currentRunLoop getCFRunLoop])){
//        NSLog(@"--cancelrunLoop--");
//    }
    [self stopTimerToRunLoopUsingCFRunLoopTimerRef];
    self.timer = nil;
//    CFRunLoopRemoveTimer ( CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode );
    [self didChangeValueForKey:@"isCancelled"];
}

- (void) main {
   
}


@end
