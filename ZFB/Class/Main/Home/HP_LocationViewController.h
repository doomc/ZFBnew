//
//  HP_LocationViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

typedef void(^SelectLocationSuccessBlock)(AMapPOI *poi);

@interface HP_LocationViewController : BaseViewController

@property (nonatomic,retain) MAUserLocation *currentLocation;//当前位置


@property (nonatomic,copy) SelectLocationSuccessBlock moveBlock;

@property (nonatomic,retain) NSString *searchStr;//搜索的内容

@property (nonatomic,retain) NSString *currentCity;//当前参数

@end
