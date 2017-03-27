//
//  CSBMKPointAnnotation.h
//  YLDGPS
//
//  Created by faith on 17/3/16.
//  Copyright © 2017年 YDK. All rights reserved.
//


#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文
@interface CSBMKPointAnnotation : BMKPointAnnotation
@property (nonatomic, strong) NSDictionary *annotationDic;
@end
