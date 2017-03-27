//
//  Tools.m
//  CWM Consultant
//
//  Created by user on 16/6/2015.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>


//
BOOL isLandScape(){
    return UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
}

BOOL isPad(){
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

//userdefault
void setUserDefault(id obj ,NSString *key){
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:obj forKey:key];
    [userDefaults synchronize];
}

id getUserDefault(NSString *key){
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

//notfication
void notficationPost(NSString* aName, id aObj){
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:aObj];
}

void notficationRegisterWithObj(id observer,SEL selector,NSString* name,id object){
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:selector
                                                 name:name
                                               object:object];
}

void notficationRegister(id observer,SEL selector,NSString* name){
    notficationRegisterWithObj(observer,selector,name,nil);
}

void notficationUnregisterWithObj(id observer,NSString* name,id object){
    [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                    name:name
                                                  object:object];
}

void noficationUnregister(id observer,NSString* name){
    notficationUnregisterWithObj(observer, name,nil);
}

//language
NSBundle *languageBundle(NSString* language){
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]];
}

BOOL isValidLanguage(NSString* language){
    return (languageBundle(language) != nil);
}

NSString* getAppLanguage(){
    NSString *applanguage = getUserDefault(@"appLanguage");
    if(applanguage.length <= 0){
        NSArray *languages = [NSLocale preferredLanguages];
        applanguage = languages.firstObject;
        if([applanguage hasPrefix:@"zh-Hans"]){
            applanguage = @"zh-Hans";
        }
        if(!isValidLanguage(applanguage)){
            applanguage = @"en";
        }
    }
    //applanguage = @"en";
    return applanguage;
}

NSString* localizedString(NSString* key){
    return [languageBundle(getAppLanguage()) localizedStringForKey:(key) value:@"" table:@"Localizable"];
}

//
void transformButton(UIButton *button){
    [UIView animateWithDuration:0.2
                     animations:^{
                         if(button.tag == 0){
                             button.transform = CGAffineTransformIdentity;
                         }else{
                             button.transform = CGAffineTransformRotate(button.transform, -M_PI_2);
                         }
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

UIImage* createImageWithColor(UIColor* color,CGRect rect){
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

UIImage* scaleImageToSize(UIImage *img, CGSize size){
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

NSString* md5(NSString *string){
    const char* str = [string UTF8String];
    NSInteger md5Bit = 32;
    unsigned char result[md5Bit];
    CC_LONG len = (CC_LONG)strlen(str);
    CC_MD5(str, len, result);
    NSMutableString *md5String = [NSMutableString stringWithCapacity:md5Bit];
    for(int i = 0; i < md5Bit; i++) {
        [md5String appendFormat:@"%02X",result[i]];
    }
    return md5String;
}

NSString* nilString2Empty(NSString* obj){
    if(obj != nil) return obj;
    return @"";
}


//
UIButton* paopaoViewWithTitle(NSString *title, NSString *subTitle, CGFloat width, CGFloat rightBtnWidth) {
    
    //泡泡图片底部箭头高度
    CGFloat paopaoBottomArrowHeight = 12;
    //泡泡图片左右空白
    CGFloat paopaoLeftAndRightEmptyGap = 4;
    //泡泡图片上下空白
    CGFloat paopaoTopAndBottomEmptyGap = 4;
    //lable左右空隙
    CGFloat labelLeftAndRightGap = 5;
    CGFloat paopaoViewWidth = width;
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    UIFont *subTitleFont = [UIFont systemFontOfSize:12];
    
    CGFloat titleHeight = [title boundingRectWithSize:CGSizeMake((paopaoViewWidth - paopaoLeftAndRightEmptyGap*2 - labelLeftAndRightGap*2), 100)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:titleFont}
                                              context:nil].size.height;
    
    CGFloat subtitleHeight = [subTitle boundingRectWithSize:CGSizeMake((paopaoViewWidth - paopaoLeftAndRightEmptyGap*2 - labelLeftAndRightGap*2), 500)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:subTitleFont}
                                              context:nil].size.height;
    
//    titleHeight = [title sizeWithFont:titleFont constrainedToSize:CGSizeMake((paopaoViewWidth - paopaoLeftAndRightEmptyGap*2 - labelLeftAndRightGap*2), 100) lineBreakMode:NSLineBreakByWordWrapping].height;
    
//    CGFloat subtitleHeight = [subTitle sizeWithFont:subTitleFont constrainedToSize:CGSizeMake((paopaoViewWidth - paopaoLeftAndRightEmptyGap*2 - labelLeftAndRightGap*2), 500) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    CGFloat paopaoViewHeight = paopaoTopAndBottomEmptyGap + titleHeight + subtitleHeight + paopaoBottomArrowHeight;
    
    UIButton *paopaoView = [UIButton buttonWithType:UIButtonTypeCustom];
    paopaoView.backgroundColor = [UIColor clearColor];
    paopaoView.frame = CGRectMake(0, 0, (paopaoViewWidth + rightBtnWidth), paopaoViewHeight);
    
    UIImage *paopaoLeftImage = [UIImage imageNamed:@"bubbleLeft"];
    paopaoLeftImage = [paopaoLeftImage stretchableImageWithLeftCapWidth:6 topCapHeight:6];
    UIImageView *paopaoLeftImageView = [[UIImageView alloc] initWithImage:paopaoLeftImage];
    paopaoLeftImageView.frame = CGRectMake(0, 0, paopaoView.frame.size.width/2, paopaoView.frame.size.height);
    [paopaoView addSubview:paopaoLeftImageView];
    
    UIImage *paopaoRightImage = [UIImage imageNamed:@"bubbleRight"];
    paopaoRightImage = [paopaoRightImage stretchableImageWithLeftCapWidth:8 topCapHeight:6];
    UIImageView *paopaoRightImageView = [[UIImageView alloc] initWithImage:paopaoRightImage];
    paopaoRightImageView.frame = CGRectMake(paopaoView.frame.size.width/2, 0, paopaoView.frame.size.width/2, paopaoView.frame.size.height);
    [paopaoView addSubview:paopaoRightImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = titleFont;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake((paopaoLeftAndRightEmptyGap + labelLeftAndRightGap), paopaoTopAndBottomEmptyGap, (paopaoViewWidth - paopaoLeftAndRightEmptyGap*2 - labelLeftAndRightGap*2), titleHeight);
    titleLabel.text = title;
    [paopaoView addSubview:titleLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.font = subTitleFont;
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subtitleLabel.textColor = [UIColor blackColor];
    subtitleLabel.frame = CGRectMake((paopaoLeftAndRightEmptyGap + labelLeftAndRightGap), CGRectGetMaxY(titleLabel.frame), (paopaoViewWidth - paopaoLeftAndRightEmptyGap*2 - labelLeftAndRightGap*2), subtitleHeight);
    subtitleLabel.text = subTitle;
    [paopaoView addSubview:subtitleLabel];
    
    return paopaoView;
}

//客户需求APP显示手机当前时区时间 服务器返回的数据中国时区
NSDate* convertSourceDateToDestDate(NSDate *sourceDate) {
    
    NSTimeZone *srcTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeZone *dstTimeZone = [NSTimeZone systemTimeZone];
    NSInteger srcGMTOffset = [srcTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger dstGMTOffset = [dstTimeZone secondsFromGMTForDate:sourceDate];
    
    NSTimeInterval interval = dstGMTOffset - srcGMTOffset;
    
    NSDate *dstDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return dstDate;
}

/**
 * gps纠偏算法，适用于google,高德体系的地图
 * @author Administrator
 */
const static double pi = 3.14159265358979324;
const static double a = 6378245.0;
const static double ee = 0.00669342162296594323;

///转换lat
double transformLat(double x, double y) {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

//转换lon
double transformLon(double x, double y) {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}

///经纬度纠偏
CLLocationCoordinate2D transform(double wgLat, double wgLon) {
    CLLocationCoordinate2D coor = {wgLat, wgLon};
    
    //国外不纠偏 直接返回
    BOOL ischina = [[ZCChinaLocation shared] isInsideChina:coor];
    if (!ischina) return coor;
    
    //国内纠偏
    double dLat = transformLat(wgLon - 105.0, wgLat - 35.0);
    double dLon = transformLon(wgLon - 105.0, wgLat - 35.0);
    double radLat = wgLat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    coor.latitude = wgLat + dLat;
    coor.longitude = wgLon + dLon;
    return coor;
} 

// 百度转Google
CLLocationCoordinate2D baidu2google(CLLocationCoordinate2D baiduCoor){
    CLLocationCoordinate2D googleCoor = {0};
    double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    double x = baiduCoor.longitude - 0.0065, y = baiduCoor.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    googleCoor.longitude = z * cos(theta);
    googleCoor.latitude = z * sin(theta);
    return googleCoor;
}
