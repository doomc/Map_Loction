//
//  KKAnnotation.m
//  MapDemo
//
//  Created by 熊维东 on 16/5/31.
//  Copyright © 2016年 熊维东. All rights reserved.
//

#import "KKAnnotation.h"

@implementation KKAnnotation
#pragma mark 标点上的主标题
- (NSString *)title{
    return @"我所在的位置!";
}

#pragma  mark 标点上的副标题
- (NSString *)subtitle{
    NSMutableString *ret = [NSMutableString new];
    
    if (_city) {
        [ret appendString:_city];
    }
 
    return ret;
}
@end
