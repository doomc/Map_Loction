//
//  KKAnnotation.h
//  MapDemo
//
//  Created by 熊维东 on 16/5/31.
//  Copyright © 2016年 熊维东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface KKAnnotation : NSObject<MKAnnotation>
/**
 * 城市
 */
@property(nonatomic,copy)NSString * city;

/**
 *  标记名字
 */
@property(nonatomic,copy)NSString * title ;
/**
 * 子名字
 */
@property(nonatomic,copy)NSString * subtitle;

/**
 *  地点
 */
@property(nonatomic)CLLocationCoordinate2D coordinate;
/**
 *  自定义大头像
 
 */
@property (nonatomic,strong) UIImage *image;


@end
