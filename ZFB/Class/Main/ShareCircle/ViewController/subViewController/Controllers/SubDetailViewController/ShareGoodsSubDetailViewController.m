//
//  ShareGoodsSubDetailViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  好货共享详情

#import "ShareGoodsSubDetailViewController.h"
#import "DetailFindGoodsViewController.h"

@interface ShareGoodsSubDetailViewController ()<SDCycleScrollViewDelegate>
{
    NSString * _goodsId;
    NSArray * _adArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdCycleView;

@property (weak, nonatomic) IBOutlet UILabel *lb_titles;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_endTime;

@property (weak, nonatomic) IBOutlet UIButton *btn_Zan;
@property (weak, nonatomic) IBOutlet UIButton *btn_buy;

@end

@implementation ShareGoodsSubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"共享详情";
    
    [self recommentDetailPostRequst];
    
    [self cycleViewInitWithimages:_adArray];
}

-(void)cycleViewInitWithimages:(NSArray *)images
{
    _sdCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, KScreenW, 160) delegate:self placeholderImage:nil];
    _sdCycleView.backgroundColor = [UIColor whiteColor];
    _sdCycleView.imageURLStringsGroup = images;
    _sdCycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdCycleView.placeholderImage = [UIImage imageNamed:@"720x330"];
    
    //自定义dot 大小和图案pageControlCurrentDot
    _sdCycleView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _sdCycleView.pageDotImage = [UIImage imageNamed:@"dot_selected"];
    _sdCycleView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

/**
 点赞了
 */
- (IBAction)didClickZan:(id)sender {
    
    
}
/**
 点击购买 ---- 跳转到商品详情
 */
- (IBAction)didClickBuyNow:(id)sender {
    
    DetailFindGoodsViewController * detailVC = [DetailFindGoodsViewController new];
    detailVC.goodsId = _goodsId;//这个地方写死的
    [self.navigationController pushViewController:detailVC animated:NO ];
}

#pragma mark -  共享详情 toShareGoods/shareGoodsDetail
-(void)recommentDetailPostRequst
{
    NSDictionary * parma = @{
                             @"id":_shareId,
                             @"userId":BBUserDefault.cmUserId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/toShareGoods/shareGoodsDetail"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            _lb_titles.text = response[@"recommentInfo"][@"title"];
            _lb_content.text = response[@"recommentInfo"][@"describe"];
            [_btn_Zan setTitle:response[@"recommentInfo"][@"thumbs"] forState:UIControlStateNormal] ;
            _goodsId = response[@"recommentInfo"][@"goodsId"];
            _adArray = response[@"recommentInfo"][@"goodsImgUrlList"];
            [self cycleViewInitWithimages:_adArray];
            [SVProgressHUD dismiss];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
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
