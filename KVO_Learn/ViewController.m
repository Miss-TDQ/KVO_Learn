//
//  ViewController.m
//  KVO_Learn
//
//  Created by ecaray_mac on 2017/9/19.
//  Copyright © 2017年 charles_wtx. All rights reserved.
//

#import "ViewController.h"
#include <objc/runtime.h>
#import "Flower.h"
/**
 本demo为探究KVO模式，并模仿KVO编写
 */
@interface ViewController ()

@property (nonatomic,strong)Flower *flower;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.flower = [Flower new];
    self.flower.name = @"茉莉花";
   
    NSLog(@"监听前，flower的类型%s",object_getClassName(self.flower));
    
    //使用系统提供的KVO模式
    [self.flower addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    NSLog(@"监听后，flower的类型%s",object_getClassName(self.flower));
}

//监听KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"flower_name"])
    {
        NSLog(@"name:发生改变-旧:%@ 新:%@",change[@"new"],change[@"old"]);
    }
    NSLog(@"监听值改变之后，flower的类型%s",object_getClassName(self.flower));
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.flower.name = @"百合花";
}
@end
