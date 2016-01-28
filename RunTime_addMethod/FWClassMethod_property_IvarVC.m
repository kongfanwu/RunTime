//
//  FWClassMethod_property_IvarVC.m
//  RunTime_addMethod
//
//  Created by 孔凡伍 on 16/1/28.
//  Copyright © 2016年 kongfanwu. All rights reserved.
//

#import "FWClassMethod_property_IvarVC.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "FWPerson.h"
#import "FWTagModel.h"

@interface FWClassMethod_property_IvarVC ()

@property (strong, nonatomic) FWPerson *person;

@end

@implementation FWClassMethod_property_IvarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = FWPerson.new;

    
//    [self getMethod];
//    [self getProperty];
//    [self getIvar];
    
}

- (void)getMethod
{
    
    /*
     http://blog.csdn.net/dongdongdongjl/article/details/7793156
     Method
     一个方法 Method，其包含一个方法选标 SEL – 表示该方法的名称，一个types – 表示该方法参数的类型，一个 IMP  - 指向该方法的具体实现的函数指针。
     
     SEL 
     方法名字/签名
     
     IMP
     我们就很清楚地知道 IMP  的含义：IMP 是一个函数指针，这个被指向的函数包含一个接收消息的对象id(self  指针), 调用方法的选标 SEL (方法名)，以及不定个数的方法参数，并返回一个id。也就是说 IMP 是消息最终调用的执行代码，是方法真正的实现代码 。我们可以像在Ｃ语言里面一样使用这个函数指针。
     
     实战：
     // 定义IMP类型函数
     void (*setTagModelIMP)(id, SEL, id);
     // 获取_person对象setTagModel:方法 具体实现函数指针IMP
     setTagModelIMP = (void(*)(id, SEL, id))[_person methodForSelector:@selector(setTagModel:)];
     // 执行调用方法
     setTagModelIMP(_person, @selector(setTagModel:), @"kongfanwu");
     */

    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(_person.class, &methodCount);
    if (!methods) return;
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        // SEL 方法名字/签名
        SEL sel = method_getName(method);
        const char *selName = sel_getName(sel);
        if (selName) {
            NSLog(@"selNameStr:%@", [NSString stringWithUTF8String:selName]);
        }
        // IMP
        IMP imp = method_getImplementation(method);
        
        // type encoding v24@0:8@16
        const char *typeEncoding = method_getTypeEncoding(method);
        if (typeEncoding) {
            NSLog(@"typeEncodingStr:%@", [NSString stringWithUTF8String:typeEncoding]);
        }
        // returnType 返回类型
        char *returnType = method_copyReturnType(method);
        if (returnType) {
            NSLog(@"returnTypeStr:%@", [NSString stringWithUTF8String:returnType]);
        }
        
        // argumentCount 获得方法参数
        unsigned int argumentCount = method_getNumberOfArguments(method);
        if (argumentCount > 0) {
            NSMutableArray *argumentTypes = [NSMutableArray new];
            for (unsigned int i = 0; i < argumentCount; i++) {
                char *argumentType = method_copyArgumentType(method, i);
                NSString *type = argumentType ? [NSString stringWithUTF8String:argumentType] : nil;
                [argumentTypes addObject:type ? type : @""];
                if (argumentType) free(argumentType);
            }
            NSLog(@"argumentTypes:%@",argumentTypes);
        }
    }
    free(methods);
    
    printf("////////////////////////////////////\n");
}

- (void)getProperty
{
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(_person.class, &propertyCount);
    if (!properties) return;
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSLog(@"name:%@", [NSString stringWithUTF8String:name]);

        unsigned int attrCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int a = 0; a < attrCount; a++) {
            objc_property_attribute_t attr = attrs[i];
            NSLog(@"name:%@ value:%@", [NSString stringWithUTF8String:attr.name],
                  [NSString stringWithUTF8String:attr.value]);
        }
    }
    free(properties);
    printf("////////////////////////////////////\n");
}

- (void)getIvar
{
    unsigned int ivarCount = 0;
    Ivar *ivarInfos = class_copyIvarList(_person.class, &ivarCount);
    for (int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivarInfos[i];
        // 属性名 _tagModel
        const char *name = ivar_getName(ivar);
        NSLog(@"name:%@", [NSString stringWithUTF8String:name]);
        
        ptrdiff_t offset = ivar_getOffset(ivar);
        NSLog(@"offset:%td",offset);
        
        // 属性类名 FWTagModel
        const char *typeEncoding = ivar_getTypeEncoding(ivar);
        if (typeEncoding) {
            NSLog(@"typeEncoding:%@", [NSString stringWithUTF8String:typeEncoding]);
        }
    }
    free(ivarInfos);
    printf("////////////////////////////////////\n");
}

- (void)testSetterTime2
{
    // get
    id isStr = ((id (*)(id, SEL, id)) objc_msgSend)(_person, @selector(tagModel), nil);
    // set
    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)_person, @selector(setTagModel:), (id)@"kongfanwu");

//    NSDate *tmpStartData = [NSDate date];
//    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
//    NSLog(@">>>>>>>>>>testSetterTime2 time = %f", deltaTime);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
