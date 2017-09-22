//
//  ShareNewGoodsDetailViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  新品推荐详情

#import "ShareNewGoodsDetailViewController.h"
#import "DetailFindGoodsViewController.h"
@interface ShareNewGoodsDetailViewController ()<SDCycleScrollViewDelegate>
{
    NSString * _goodsId;
}
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView ;
@property (strong, nonatomic) NSMutableArray *adArray ;
@property (strong, nonatomic) UILabel * lb_titile;
@property (strong, nonatomic) UILabel * lb_conent;
@property (strong, nonatomic) UIView * footerView;
@property (strong, nonatomic) UIButton * zan_btn;//点赞
@property (strong, nonatomic) UIButton * checkBuy_btn;//查看购买





@end

@implementation ShareNewGoodsDetailViewController

-(NSMutableArray *)adArray
{
    if (!_adArray) {
        _adArray = [NSMutableArray array];
    }
    return _adArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新品推荐";
    self.view.backgroundColor = RGBA(244, 244, 244, 1);
    
    [self initWithInterFace];
    
    [self footViewInterface];
    
    [self.view addSubview:self.cycleScrollView];


}
/**初始化轮播 */
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, KScreenW, 160) delegate:self placeholderImage:nil];
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.imageURLStringsGroup = self.adArray;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"720x330"];
        _cycleScrollView.delegate = self;
        
        //自定义dot 大小和图案pageControlCurrentDot
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"dot_selected"];
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    }
    return _cycleScrollView;
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

-(void)initWithInterFace
{
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenH - 50, KScreenW, 50)];
    [self.view addSubview:_footerView];
    
    //点赞
    _zan_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zan_btn setImage:[UIImage imageNamed:@"sharezan_normal"] forState:UIControlStateNormal];
    [_zan_btn setImage:[UIImage imageNamed:@"sharezan_selected"] forState:UIControlStateSelected];
    [_zan_btn setTitle:@"255" forState:UIControlStateNormal];
    [_zan_btn setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
    _zan_btn.backgroundColor = [UIColor whiteColor];
    [_zan_btn addTarget:self action:@selector(didClickZan:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_zan_btn];
    
    [_zan_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footerView).with.offset(0);
        make.top.equalTo(_footerView).with.offset(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(140);
    }];
    
    
    //查看购买
    _checkBuy_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkBuy_btn setTitle:@"查看购买" forState:UIControlStateNormal];
    _checkBuy_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
    [_checkBuy_btn addTarget:self action:@selector(didClicklookDetail:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_checkBuy_btn];
    [_checkBuy_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_zan_btn.mas_right).with.offset(0);
        make.top.equalTo(_footerView).with.offset(0);
        make.right.equalTo(_footerView).with.offset(0);
        make.height.mas_equalTo(50);
        
    }];
    
    
    _lb_titile = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 + 160 +64, KScreenW - 30, 25)];
    _lb_titile.font = [UIFont systemFontOfSize:16];
    _lb_titile.textColor =  HEXCOLOR(0x363636);
    _lb_titile.text = @"标题";
    [self.view addSubview:_lb_titile];
    
    _lb_conent = [[UILabel alloc]init];
    _lb_conent.font = [UIFont systemFontOfSize:14];
    _lb_conent.numberOfLines = 0;
    
    _lb_conent.text = @" ";
    _lb_conent.textColor =  HEXCOLOR(0x363636);
    [self.view addSubview:_lb_conent];
    
    [_lb_conent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lb_titile.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.bottom.equalTo(_footerView.mas_top).with.offset(-20);
     }];
}

-(void)footViewInterface
{

}

#pragma mark -点赞数
-(void)didClickZan:(UIButton *)sender
{
    
}

#pragma mark - 查看详情
-(void)didClicklookDetail:(UIButton *)sender
{
    if (![_goodsId isEqualToString:@""] || _goodsId ==nil) {

        DetailFindGoodsViewController * detailVC = [DetailFindGoodsViewController new];
        detailVC.goodsId = _goodsId;
        [self.navigationController pushViewController:detailVC animated:NO];
    }

}



#pragma mark -  获取新品推荐详情信息 recomment/recommentDetailInfo
-(void)recommentDetailPostRequst
{
    NSDictionary * parma = @{
                             @"recommentId":_recommentId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/recommentDetailInfo"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            _lb_titile.text = response[@"recommentInfo"][@"title"];
            _lb_conent.text = response[@"recommentInfo"][@"describe"];
            [_zan_btn setTitle:response[@"recommentInfo"][@"thumbs"] forState:UIControlStateNormal] ;
            _goodsId = response[@"recommentInfo"][@"goodsId"];
            self.adArray = response[@"recommentInfo"][@"goodsImgUrlList"];
            
            [self.view addSubview:self.cycleScrollView];
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
