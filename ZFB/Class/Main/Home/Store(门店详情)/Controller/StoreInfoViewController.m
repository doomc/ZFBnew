//
//  StoreInfoViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "StoreInfoViewController.h"
#import "XHStarRateView.h"

@interface StoreInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *storeImage;
@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;
@property (weak, nonatomic) IBOutlet UILabel *lb_info;

@property (weak, nonatomic) IBOutlet UILabel *lb_collect;
@property (weak, nonatomic) IBOutlet UILabel *lb_sales;
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsNum;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIView *BgView;

@end

@implementation StoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"店铺信息";
    
    self.lb_info.text = _info;
    self.lb_sales.text = _salesNum;
    self.lb_collect.text = _collectNum;
    self.lb_goodsNum.text = _goodsNum;
    self.lb_storeName.text = _storeName;
    XHStarRateView * wdStarView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 120, 24) numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self WithtouchEnable:NO littleStar:@"0"];//da星星
    wdStarView.currentScore = _starNum;
 

    [self.starView addSubview:wdStarView];
    [self.storeImage sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil];

    self.BgView.clipsToBounds = YES;
    self.BgView.layer.cornerRadius = 6;

    self.storeImage.layer.masksToBounds = YES;
    self.storeImage.layer.cornerRadius = 6;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
