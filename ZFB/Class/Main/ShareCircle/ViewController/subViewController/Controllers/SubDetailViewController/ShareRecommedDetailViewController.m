//
//  ShareRecommedDetailViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShareRecommedDetailViewController.h"
//#import "DetailFindGoodsViewController.h"
#import "GoodsDeltailViewController.h"
@interface ShareRecommedDetailViewController ()<SDCycleScrollViewDelegate>
{
    NSArray * _adArray;
    NSString * _shareGoodsId;
    NSString * _isThumbsStatus;
}
@end

@implementation ShareRecommedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新品推荐详情";
    _adArray = [NSArray array];
    [self recommentDetailPostRequst];
    [self cycleViewInitWithimages:_adArray];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];

}
-(void)cycleViewInitWithimages:(NSArray *)images
{
    _sdCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 200/375.0 * KScreenW) delegate:self placeholderImage:[UIImage imageNamed:@"720x330"]];
    _sdCycleView.backgroundColor = [UIColor whiteColor];
    _sdCycleView.imageURLStringsGroup = images;
    _sdCycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    //自定义dot 大小和图案pageControlCurrentDot
    _sdCycleView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _sdCycleView.pageDotImage = [UIImage imageNamed:@"dot_selected"];
    _sdCycleView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.bannerView addSubview:_sdCycleView];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}
//查看购买
- (IBAction)didClickBuyNow:(id)sender {
    
    if ( [_shareGoodsId isEqualToString:@""] || _shareGoodsId == nil) {
        
    }else{
        GoodsDeltailViewController * detailVC = [GoodsDeltailViewController new];
        detailVC.goodsId = _shareGoodsId;
        detailVC.headerImage = [NSString stringWithFormat:@"%@",_adArray[0]];
        [self.navigationController pushViewController:detailVC animated:NO];
    }
}
//立即点赞
- (IBAction)didClickZan:(id)sender {
    
    if ([_isThumbsStatus isEqualToString: @"0"]) {
        if ([BBUserDefault.cmUserId isEqualToString:@""]||[BBUserDefault.cmUserId isEqualToString:@"0"] ||BBUserDefault.cmUserId ==nil) {
            [self isNotLoginWithTabbar:YES];

            
        }else{
            [self didclickZanPostRequsetAtthumsId:_recommentId];
        }
        
    }else{
        [self.view makeToast:@"您已经点过赞了" duration:2 position:@"center"];
    }
}


#pragma mark -  获取新品推荐详情信息 recomment/recommentDetailInfo
-(void)recommentDetailPostRequst
{
 
    
    NSString * userId =  [NSString stringWithFormat:@"%@",BBUserDefault.cmUserId];
    if ([userId isEqualToString:@""] || userId == nil) {
        userId = @"0";
    }
    NSDictionary * parma = @{
                             @"recommentId":_recommentId,
                             @"userId":userId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/recommentDetailInfo"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            _lb_titles.text = response[@"recommentInfo"][@"title"];
            _lb_content.text = response[@"recommentInfo"][@"describe"];
            
            //获取goodid
            _shareGoodsId = [NSString stringWithFormat:@"%@",response[@"recommentInfo"][@"goodsId"]];
            
            //点赞数量
            NSString * thumbs = [NSString stringWithFormat:@"%@",response[@"recommentInfo"][@"thumbs"]];
            _lb_zanNum.text = thumbs;
            
            //是否点赞
            _isThumbsStatus = [NSString stringWithFormat:@"%@",response[@"recommentInfo"][@"isThumbs"]];
            if ([_isThumbsStatus isEqualToString: @"0"]) {
                self.zan_imageView.image =[UIImage imageNamed:@"praise_off"];
            }else{
                self.zan_imageView.image =[UIImage imageNamed:@"praise_on"];
            }
            
            _recommentId = response[@"recommentInfo"][@"recommentId"];
            _adArray = response[@"recommentInfo"][@"goodsImgUrlList"];
            
            [self addRecommentBrowsePostRequst];
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


#pragma mark  - 点赞请求 newrecomment/toLike
-(void)didclickZanPostRequsetAtthumsId:(NSString *)thumsId
{
    NSString * userId =  [NSString stringWithFormat:@"%@",BBUserDefault.cmUserId];
    if ([userId isEqualToString:@""] || userId == nil) {
        userId = @"0";
    }
    NSDictionary * parma = @{
                             @"userId":userId,
                             @"thumsId":thumsId,//分享编号，新品推荐编号
                             @"type":@"0",//0 新品推荐 1 分享
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/newrecomment/toLike"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            self.zan_imageView.image =[UIImage imageNamed:@"praise_on"];
            _lb_zanNum.text = [NSString stringWithFormat:@"%ld", [_lb_zanNum.text integerValue] + 1];
            
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

#pragma mark - 添加浏览量 addRecommentBrowse
-(void)addRecommentBrowsePostRequst
{
    NSDictionary * parma = @{
                             
                             @"recommentId":_shareGoodsId,//新品推荐id或共享id
                             @"type":@"2",//1 是新品推荐  2共享
                             
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/recomment/addRecommentBrowse",zfb_baseUrl] params:parma success:^(id response) {
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
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
