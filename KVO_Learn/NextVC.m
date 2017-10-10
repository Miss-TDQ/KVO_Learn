//
//  NextVC.m
//  KVO_Learn
//
//  Created by ecaray_mac on 2017/9/19.
//  Copyright © 2017年 charles_wtx. All rights reserved.
//

#import "NextVC.h"
#import "Flower.h"
#import "NSObject+NewKVO.h"
//#import "NSObject+CustomKVO.h"
@interface NextVC ()

@property(nonatomic,strong)Flower *flower;

@end

@implementation NextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.flower = [Flower new];
    self.flower.color  = @"红色";
    
    [self.flower addObserver:self forKey:@"color"];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _flower.color = @"黄色";
}

- (void)observeNewValue:(NSString *)newValue oldValue:(NSString *)oldValue ofObject:(id)object
{
    NSLog(@"old %@ ---new %@ ---class:%@",oldValue,newValue,object);
}
@end
