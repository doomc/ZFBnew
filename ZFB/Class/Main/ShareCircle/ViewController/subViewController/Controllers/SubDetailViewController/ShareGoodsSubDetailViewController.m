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
    NSString * _isThumbsStatus;
    NSString * _shareId;
}
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (strong, nonatomic) SDCycleScrollView *sdCycleView;
@property (weak, nonatomic) IBOutlet UIView *bannerView;

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
    _adArray = [NSArray array];
    
    self.userHeadImg.clipsToBounds = YES;
    self.userHeadImg.layer.cornerRadius = 25;
    
    [self recommentDetailPostRequst];
    [self addRecommentBrowsePostRequst];
    
    [self cycleViewInitWithimages:_adArray];
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

/**
 点赞了
 */
- (IBAction)didClickZan:(id)sender {
    
    if ([_isThumbsStatus isEqualToString: @"1"]) {
      
        [self.view makeToast:@"您已经点过赞了" duration:2 position:@"center"];

    }else{
        
        [self didclickZanPostRequsetAtthumsId:_shareId];

    }
    
 
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
            
            _lb_titles.text = response[@"data"][@"title"];
            _lb_content.text = response[@"data"][@"describe"];
            _lb_endTime .text = response[@"data"][@"createTime"];
            _userNickName.text =response[@"data"][@"nickname"];
            _shareId = [NSString stringWithFormat:@"%@",response[@"data"][@"id"]];
         
            _goodsId = response[@"data"][@"goodsId"];
            _adArray = response[@"data"][@"imgUrls"];
            [_userHeadImg sd_setImageWithURL:[NSURL URLWithString:response[@"data"][@"userLogo"]] placeholderImage:[UIImage imageNamed:@"head"]];
            
            //点赞数量
            NSString * count  = [NSString stringWithFormat:@"%@",response[@"data"][@"thumbs"]];
            _zan_number.text = count;
            
            //是否点赞
            _isThumbsStatus = [NSString stringWithFormat:@"%@",response[@"data"][@"thumbsStatus"]];
            if ([_isThumbsStatus isEqualToString: @"1"]) {
                self.zan_imageView.image =[UIImage imageNamed:@"sharezan_selected"];
 
            }else{
            
                self.zan_imageView.image =[UIImage imageNamed:@"sharezan_normal"];

            }
            
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
    NSDictionary * parma = @{
                             @"userId":BBUserDefault.cmUserId,
                             @"thumsId":thumsId,
                             @"type":@"1",//0 新品推荐 1 分享
                             };
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/newrecomment/toLike"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
          
            self.zan_imageView.image =[UIImage imageNamed:@"sharezan_selected"];
            _zan_number.text = [NSString stringWithFormat:@"%ld", [_zan_number.text integerValue]+1];
            
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
                             
                             @"recommentId":_shareId,//1 是新品推荐  2共享
                             @"type":@"1",//1 是新品推荐  2共享
                             
                             
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
