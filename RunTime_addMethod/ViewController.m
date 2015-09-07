//
//  ViewController.m
//  RunTime_addMethod
//
//  Created by 孔凡伍 on 15/8/26.
//  Copyright (c) 2015年 kongfanwu. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "FWPerson.h"

@interface ViewController ()

@end

@implementation ViewController

id sayHello(id self, SEL _cmd)
{
    NSLog(@"hello");
    return @"kongfanwu";
}

- (void)viewDidLoad {
    [super viewDidLoad];


//    [ViewController classMethod];
    
    [self ecchangeMethod];
}

/**
 *  添加方法
 */
+ (void)classMethod
{
    //    class_addMethod([FWPerson class], @selector(sayHello2), (IMP)sayHello, "@@:");
    //
    //    FWPerson *person = [[FWPerson alloc] init];
    ////    [person sayHello2];
    //    NSLog(@"%@",[person performSelector:@selector(sayHello2)]);
    
    class_addMethod([FWPerson class], @selector(sayHello2), (IMP)sayHello, "@@:");
    FWPerson *person = [[FWPerson alloc] init];
    //    [person sayHello2];
    NSLog(@"%@",[person performSelector:@selector(sayHello2)]);
}

/**
 *  方法替换， 交换 (方法调剂)
 */
- (void)ecchangeMethod
{
    Class class = [self class];
    SEL originalSelector = @selector(setTextColor:);
    SEL swizzledSelector = @selector(hook_setTextColor:);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // 类添加 setTextColor方法，如果已经存在要添加的方法，添加失败
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    // 添加成功 替换setTextColor方法
    if (didAddMethod){
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    /* 方法替换
     * 调用setTextColor: 会调到hook_setTextColor:
     * 调用hook_setTextColor: 会调到setTextColor:
     */
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    [self hook_setTextColor:@"kongfanwu"];
}

- (void)setTextColor:(NSString *)click
{
    NSLog(@"setTextColor");
}

- (void)hook_setTextColor:(NSString *)click
{
    NSLog(@"hook_setTextColor");
    [self hook_setTextColor:click];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
