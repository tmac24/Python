//
//  Thread.m
//  bbbbb
//
//  Created by cdql10103 on 2023/2/2.
//

#import "Thread.h"

@implementation Thread

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)test7 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"1");
    //    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        dispatch_async(queue, ^{
            sleep(1); //这里线程睡眠1秒钟，模拟异步请求
            NSLog(@"2");
            //            dispatch_group_leave(group);
        });
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"3");
    });
    //    dispatch_group_wait(group, DISPATCH_TIME_NOW);
    NSLog(@"4");
    dispatch_async(queue, ^{
        NSLog(@"5");
    });
    // 打印1,4,3,5,2(3,5顺序不定)。
    //dispatch_group_enter/leave: notify只负责group里面的任务执行完，如果group里面嵌套有异步任务，是不会管他就直接返回的。这时就需要enter/leave了，成对出现的，enter多了会阻塞，leave多了会崩溃。
    // dispatch_group_wait：阻塞group到某个时刻，然后释放继续执行下面的任务，参数DISPATCH_TIME_NOW表示不阻塞，相当于没有，参数DISPATCH_TIME_FOREVER表示永远阻塞，还可以自定义为3秒后的时刻，表示阻塞3秒，之后放开。打开wait并设置time为FOREVER后，打印为1,4,3,5,2，3在5前面
}


//复杂情况
- (void)test6 {
    dispatch_queue_t queue = dispatch_queue_create("thread", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"test1");
    });
    dispatch_async(queue, ^{
        NSLog(@"test2");
    });
    dispatch_async(queue, ^{
        NSLog(@"test3");
    });
    
    dispatch_barrier_sync(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"barrier");
    });
    NSLog(@"aaa");
    dispatch_async(queue, ^{
        NSLog(@"test4");
    });
    NSLog(@"bbb");
    dispatch_async(queue, ^{
        NSLog(@"test5");
    });
    dispatch_async(queue, ^{
        NSLog(@"test6");
    });
    //打印 test1，test3，test2，barrier，aaa，bbb，test4，test5，test6
    //异步 aaa，test1，bbb，test2，test3，barrier，test4，test5，test6
    // 执行的顺序，同一线程内同步有序，异步无序和执行任务效率有关。不同线程只和任务效率有关。
}

#pragma mark - //总结：串行+同步会死锁。并行+异步可开启新线程。

- (void)test5 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1-%@", [NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"2-%@", [NSThread currentThread]);
        });
        NSLog(@"3-%@", [NSThread currentThread]);
    });
    NSLog(@"4-%@", [NSThread currentThread]);
    // 打印1-num7，4-main，2-mian，3-num7。1/4顺序不定
}

- (void)test4 {
    //并行 异步
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2-1-%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2-2-%@",[NSThread currentThread]);
    });
    NSLog(@"3");
    // 打印1，3，2-1-num7，2-2-num4，开启了新线程
}

- (void)test3 {
    //并行 同步
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"1-%@", [NSThread currentThread]);
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"2-%@", [NSThread currentThread]);
    });
    NSLog(@"3");
    // 打印1，2-main，3
}

- (void)test2 {
    //串行 异步
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"1-%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        NSLog(@"2-1-%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2-2-%@", [NSThread currentThread]);
    });
    NSLog(@"3");
    // 打印1，3，2-1-main，2-2-main
}

- (void)test1 {
    //串行 同步
    NSLog(@"1");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
    // 打印1，崩溃在__DISPATCH_WAIT_FOR_QUEUE__，死锁
}


@end
