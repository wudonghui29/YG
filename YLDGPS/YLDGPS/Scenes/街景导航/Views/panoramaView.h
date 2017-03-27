//
//  panoramaView.h
//  YLDGPS
//
//  Created by user on 15/7/2.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YLDCommon.h"
#import <CoreLocation/CoreLocation.h>
@interface panoramaView : UIView 

- (void)setCoordinate:(CLLocationCoordinate2D)coor title:(NSString*)title;
@end
