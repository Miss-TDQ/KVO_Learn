//
//  NSObject+NewKVO.h
//  KVO_Learn
//
//  Created by ecaray_mac on 2017/9/19.
//  Copyright © 2017年 charles_wtx. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自己实现KVO的object分类，runtime的灵活运用
 */
@interface NSObject (NewKVO)

/**
 监听的方法

 @param observer 观察者
 @param key 监听的属性
 */
-(void)addObserver:(NSObject *)observer forKey:(NSString *)key;

@end
