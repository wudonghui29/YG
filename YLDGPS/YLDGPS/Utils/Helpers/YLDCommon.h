//
//  YLDCommon.h
//  YLDGPS
//
//  Created by faith on 17/3/9.
//  Copyright © 2017年 YDK. All rights reserved.
//

#ifndef YLDCommon_h
#define YLDCommon_h



//Manager
#import "YLDAPIManager.h"
#import "YLDDataManager.h"
#import "Tools.h"
//Controller
#import "YLDBaseVC.h"
#import "YLDHomeVC.h"
#import "YLDLoginVC.h"
#import "YLDLocationVC.h"
#import "YLDTrackReplayVC.h"
#import "YLDFenceVC.h"
#import "YLDAlarmReminderVC.h"
#import "YLDOfflineMapVC.h"
#import "YLDStreeViewNavigationVC.h"
#import "YLDDeviceMangerVC.h"
#import "YLDSystemSettingVC.h"
#import "YLDPoverSaverVC.h"
#import "YLDChargeCardVC.h"
#import "YLDServiceCenterVC.h"
#import "YLDVDeviceDetailVC.h"
#import "YLDFenceEditVC.h"
#import "YLDRemindReceiveVC.h"
#import "YLDChangePasswordVC.h"
#import "YLDChangePasswordCell.h"
#import "YLDNumberBindingVC.h"
#import "remindRecevieViewController.h"
//View
#import "YLDGridView.h"
#import "YLDSwitchView.h"
#import "YLDPositionInforView.h"
#import "YLDScanButton.h"
#import "YLDSimulateView.h"
#import "YLDFenlistCell.h"
#import "YLDAlarmReminderCell.h"
#import "panoramaView.h"
#import "YLDNavigationView.h"
#import "ZWVerticalAlignLabel.h"
#import "YLDDeviceListCell.h"
#import "YLDSelectDeviceView.h"
#import "YLDDeviceGeneralInforCell.h"
#import "YLDFenceNameSelectView.h"
#import "YLDRemindView.h"
#import "YCXMenu.h"
//Catagory
#import "UIViewExt.h"
#import "MBProgressHUD+show.h"
#import "NSString+Size.h"

//Model
#import "deviceTrackViewModel.h"
#import "YCXMenuItem.h"
#import "YLDLoginViewModel.h"
#import "mainViewModel.h"
#import "ADInfo.h"
#import "deviceInfoViewModel.h"
#import "CSBMKPointAnnotation.h"
#import "ChangePasswordViewModel.h"
#import "deviceViewModel.h"
#import "NumbersBindingVIewModel.h"
#import "fenceViewModel.h"
#import "fenceEditViewModel.h"
#import "remindRecevieViewModel.h"
//Third
#import <SDWebImage/UIImageView+WebCache.h>
#import <GoogleMaps/GoogleMaps.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduPanoSDK/BaiduPanoramaView.h>
#import "JPUSHService.h"
#import <AFNetworking.h>
#import <ReactiveCocoa.h>
#import <FSCalendar.h>
#import <TSMessage.h>
#import "HourPickerView.h"
#import "SVProgressHUD.h"
#import <CoreLocation/CoreLocation.h>

#import "YLDShow.h"
#import "TimePickerView.h"
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

#define KMapHeight 140
#define kGirdWidth  [[UIScreen mainScreen] bounds].size.width/3
#define kGirdHeight (kScreenHeight - KMapHeight - 64)/4


//体验账号
#define kExperienceAccount @"test"
#define kExperiencePassword @"123456"

//
#define kSeverAddress @"http://app.gps112.net/ios"
#define kSeverVer @"s1"




#define kBaiduKey @"ry8KfAOh7ivVnFMjVkWKnbIj"
#define kJPushAppKey @"7bff0fee94f648c7d973ed5a"
//是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
//是否为iOS8及以上系统
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#endif /* YLDCommon_h */
//根据rgb值获取颜色
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]

#define HomeNavigationBar_COLOR  COLOR_WITH_HEX(0x3a9bf0)
#define NavigationBar_COLOR  COLOR_WITH_HEX(0xffffff)
#define SeparatorLine_COLOR  COLOR_WITH_HEX(0xe3e5e6)


