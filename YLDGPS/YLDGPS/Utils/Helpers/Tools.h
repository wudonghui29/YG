//
//  ABTools.h
//  CWM Consultant
//
//  Created by user on 16/6/2015.
//  Copyright (c) 2015年 user. All rights reserved.
//

#ifndef YLDGPS_ABTools_h
#define YLDGPS_ABTools_h

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>
#import "ZCChinaLocation.h"
//

//
#define systemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define screenSize [UIScreen mainScreen].bounds.size

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

//
BOOL isLandScape();
BOOL isPad();

//userdefault
void setUserDefault(id obj ,NSString *key);
id getUserDefault(NSString *key);

//notfication
void notficationPost(NSString* aName, id aObj);
void notficationRegisterWithObj(id observer,SEL selector,NSString* name,id object);
void notficationRegister(id observer,SEL selector,NSString* name);
void notficationUnregisterWithObj(id observer,NSString* name,id object);
void noficationUnregister(id observer,NSString* name);

//language
BOOL isValidLanguage(NSString* language);
NSString* getAppLanguage();
NSString* localizedString(NSString* key);

//
void transformButton(UIButton *button);
UIImage* createImageWithColor(UIColor* color,CGRect rect);
UIImage* scaleImageToSize(UIImage *img, CGSize size);
NSString* md5(NSString *string);
///如果是nil返回@"" 否者返回obj
NSString* nilString2Empty(NSString* obj);

//
UIButton* paopaoViewWithTitle(NSString *title, NSString *subTitle, CGFloat width, CGFloat rightBtnWidth);

//
NSDate* convertSourceDateToDestDate(NSDate *sourceDate);

///gps纠偏算法，适用于google,高德体系的地图
CLLocationCoordinate2D transform(double wgLat, double wgLon);
/// 百度转Google
CLLocationCoordinate2D baidu2google(CLLocationCoordinate2D baiduCoor);

#endif
