//
//  ShareRecommedDetailViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareRecommedDetailViewController : BaseViewController

@property (strong, nonatomic) SDCycleScrollView *sdCycleView;
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet UILabel *lb_titles;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet UIButton *btn_Zan;
@property (weak, nonatomic) IBOutlet UIButton *btn_buy;

@property (weak, nonatomic) IBOutlet UIImageView *zan_imageView;
@property (weak, nonatomic) IBOutlet UILabel *lb_zanNum;

@property (nonatomic , copy) NSString * recommentId;


@end
