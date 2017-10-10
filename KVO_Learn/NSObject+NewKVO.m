//
//  NSObject+NewKVO.m
//  KVO_Learn
//
//  Created by ecaray_mac on 2017/9/19.
//  Copyright © 2017年 charles_wtx. All rights reserved.
//

#import "NSObject+NewKVO.h"
#import <objc/message.h>

@implementation NSObject (NewKVO)
NSString *const observerKey = @"observer";
SEL setterMethod = nil;
NSString *Key = @"";
-(void)addObserver:(NSObject *)observer forKey:(NSString *)key
{
    
    //分类中保存属性的方式,将监听者保存到当前属性中去
    objc_setAssociatedObject(self, (__bridge const void *)(observerKey), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    Key = key;
    //流程:
    //1:获取当前类
    //2:新建一个当前类的子类，并创建set方法
    //3:将当前对象指向新创建的子类
    
    NSString *superClassName = NSStringFromClass([self class]);
    
    const char *subClassName = [[NSString stringWithFormat:@"YICHE_%@",superClassName] UTF8String];
    
    /*新建一个子类:第一个参数为继承的父类，第二个参数为子类名,第三个参数为开辟的内存空间*/
    Class subClass = objc_allocateClassPair([self class], subClassName, 0);
    /*新建子类的注册*/
    objc_registerClassPair(subClass);
    
    /*新建setterKey方法,并把首字母转化为大写*/
    setterMethod = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [key capitalizedString]]);
    /*将setter方法添加到新建的子类中*/
    class_addMethod(subClass, setterMethod, (IMP)setKeyPath, "V@:@");

    //将对象的isa指针由父类指向新建的子类
    object_setClass(self, subClass);
    
}

void setKeyPath(id self, SEL _cmd, NSString *keyPath)
{
    
    id class = [self class];
    
    //在把isa指向父类
    object_setClass(self, class_getSuperclass(class));
    NSString * oldValue = [self valueForKey:Key];
    
    /*调用父类set方法
     此处报 Too many argument to function call, expected 0... 错误
     
     解决一:
        void* (*action)(id,SEL,NSString *) = (void* (*)(id,SEL,NSString *))objc_msgSend;
        action(self,sel,self.animationView);
     
     解决二:
        buildSetting -> Enable Strict Checking of objc_mesgSend Calls 设为NO
     */
    ((void (*) (id, SEL,id))objc_msgSend)(self, setterMethod,keyPath);
    
    //拿到当前的属性，observerKey的值
    id object = objc_getAssociatedObject(self, (__bridge const void *)(observerKey));
    
    ((void (*) (id, SEL,NSString *,NSString *,id))objc_msgSend)(object, @selector(observeNewValue:oldValue:ofObject:),keyPath,oldValue,self);
    
    //重新指向子类，继续监听
    object_setClass(self, class);
}

@end

