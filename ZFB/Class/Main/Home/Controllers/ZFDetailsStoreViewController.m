//
//  ZFDetailsStoreViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFDetailsStoreViewController.h"
#import "DetailStoreModel.h"
#import "DetailFindGoodsViewController.h"

//cell
#import "DetailStoreTitleCell.h"//头
#import "SectionCouponCell.h"//优惠券
#import "StoreListTableViewCell.h"
//view
#import "CouponTableView.h"


//计算cell高度
#define   itemHeight ((KScreenW -30-20 )*0.5 - 10 ) * 140/121 +36+20+15

@interface ZFDetailsStoreViewController ()<UITableViewDelegate,UITableViewDataSource,CouponTableViewDelegate,SDCycleScrollViewDelegate,StoreListTableViewCellDelegate,DetailStoreTitleCellDelegate>
{
    NSString * _storeName;
    NSString * _address;
    NSString * _contactPhone;
    NSString * _payType;//到店付 1.支持 0.不支持
    NSArray  * _imgArray;
    BOOL _isCalling;
    CGFloat   _itemHeight;

}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * storeList;
@property (nonatomic , strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic , strong) CouponTableView *  couponTableView;
@property (nonatomic , strong) UIView          *  couponBackgroundView;


@end

@implementation ZFDetailsStoreViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"门店详情";
    [self.view addSubview:self.tableView];

    [self creatUI];
    
    [self detailListStorePostRequst];

    [self cycleScrollViewWithImgArr:_imgArray];

    _isCalling = NO;//默认没打电话
    
    
}

#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64 ) style:UITableViewStylePlain
                      ];
        _tableView.delegate       = self;
        _tableView.dataSource     = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)storeList
{
    if (!_storeList) {
        _storeList = [NSMutableArray array];
    }
    return _storeList;
}
-(CouponTableView *)couponTableView
{
    if (!_couponTableView) {
        _couponTableView = [[CouponTableView alloc]initWithFrame:CGRectMake(0, 200, KScreenW, KScreenH -200) style:UITableViewStylePlain];
        _couponTableView.popDelegate = self;
    }
    return _couponTableView;
}

-(UIView *)couponBackgroundView
{
    if (!_couponBackgroundView) {
        _couponBackgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
        _couponBackgroundView.backgroundColor = RGBA(0, 0, 0, 0.2);
        [_couponBackgroundView addSubview:self.couponTableView];
    }
    return _couponBackgroundView;
}

//创建UI
-(void)creatUI{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailStoreTitleCell" bundle:nil] forCellReuseIdentifier:@"DetailStoreTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionCouponCell" bundle:nil] forCellReuseIdentifier:@"SectionCouponCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreListTableViewCell" bundle:nil] forCellReuseIdentifier:@"StoreListTableViewCell"];
    
}
/**
 初始化轮播
 */
-(void)cycleScrollViewWithImgArr:(NSArray*)imgArr;
{
    _cycleScrollView                      = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 310*0.5) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.pageControlAliment   = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.imageURLStringsGroup = imgArr;
    
    //自定义dot 大小和图案
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _cycleScrollView.pageDotImage        = [UIImage imageNamed:@"dot_selected"];
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor];// 自定义分页控件小圆标颜色
    _cycleScrollView.placeholderImage    = [UIImage imageNamed:@"placeholder"];
    self.tableView.tableHeaderView = _cycleScrollView;
}

#pragma mark - SDCycleScrollViewDelegate 轮播图代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numSection = 1;
 
    return numSection ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        
        return 80;

    }
    else if (indexPath.section == 1)
    {
        return 44;
    }
    else{
        
        NSInteger cout =  self.storeList.count;
        if (cout % 2 == 0 ) {
            
            return (itemHeight +10) * cout/2  ;
        }else{
            
            return (itemHeight +10) * (cout/2 +1);
        }
     }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 44;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = nil;
    if (headerView == nil) {
        if (section == 2) {
            //全部商品section
            headerView =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 44)];
            headerView.backgroundColor = HEXCOLOR(0xffcccc);
            
            UIImageView * section_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
            section_icon.image =[ UIImage imageNamed:@"more_icon"];
            [headerView addSubview:section_icon];
            
            UILabel * sectionTitle= [[ UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 44)];
            sectionTitle.text =@"全部商品";
            sectionTitle.font =[UIFont systemFontOfSize:14];
            sectionTitle.textAlignment = NSTextAlignmentLeft;
            sectionTitle.textColor = HEXCOLOR(0x363636);
            [headerView addSubview:sectionTitle];
        }
    }
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        
        DetailStoreTitleCell * titleCell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailStoreTitleCell" forIndexPath:indexPath];
        titleCell.lb_storeName.text = _storeName;
        titleCell.lb_address.text = _address;
        titleCell.delegate = self;
        return titleCell;
        
    }else if (indexPath.section == 1)
    {
        SectionCouponCell * couponCell = [self.tableView dequeueReusableCellWithIdentifier:@"SectionCouponCell" forIndexPath:indexPath];
        return couponCell;
    }
    else{
        StoreListTableViewCell * listCell = [self.tableView dequeueReusableCellWithIdentifier:@"StoreListTableViewCell" forIndexPath:indexPath];
        listCell.storeListArray = self.storeList;
        listCell.collectionDelegate = self;
        [listCell reloadCollectionView];

        return listCell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        
    }
    else if (indexPath.section == 1){
 
    }
    else{
 
    }
}

#pragma mark - <DetailStoreTitleCellDelegate> 拨打电话代理
//拨打电话
-(void)callingBack
{
    if (_isCalling == YES) {
        
        return;
        }
    _isCalling = YES;
    NSMutableString * str= [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_contactPhone];
    NSDictionary * dic = @{@"":@""} ;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:dic completionHandler:^(BOOL success) {
        _isCalling = NO;
    }];

}
#pragma mark - <CouponTableViewDelegate> 优惠券代理
/**
 *  关闭弹框
 */
-(void)didClickCloseCouponView
{
    [self.couponBackgroundView removeFromSuperview];
}

-(void)selectCouponWithIndex:(NSInteger)indexRow withResult:(NSString *)result
{
    [self.couponBackgroundView removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.couponBackgroundView removeFromSuperview];
    
}


#pragma mark - StoreListTableViewCellDelegate 集合视图的代理
-(void)didClickCollectionCellGoodId:(NSString *)goodId withIndexItem:(NSInteger )indexItem
{
    DetailCmgoodslist * goodlist = self.storeList[indexItem];
    
    DetailFindGoodsViewController * goodVC = [DetailFindGoodsViewController new];
    goodVC.goodsId = [NSString stringWithFormat:@"%ld",goodlist.goodsId];
    [self.navigationController pushViewController:goodVC animated:NO];
}

#pragma mark - 门店详情网络商品列表 getGoodsDetailsInfo用于门店详情的接口
-(void)detailListStorePostRequst
{
    if (BBUserDefault.cmUserId == nil || BBUserDefault.cmUserId == NULL ||[BBUserDefault.cmUserId  isKindOfClass:[NSNull class]]) {
        BBUserDefault.cmUserId = @"";
    }
    NSDictionary * parma = @{
                             
                             @"storeId":_storeId,//门店id
                             @"userId":BBUserDefault.cmUserId,//门店id
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreDetailsInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        if ( [response[@"resultCode"] intValue] == 0) {
            
            if (self.storeList.count > 0) {
                
                [self.storeList removeAllObjects];
                
            }
            DetailStoreModel * detailModel = [DetailStoreModel  mj_objectWithKeyValues:response];
            
            for (DetailCmgoodslist * goodlist in detailModel.cmGoodsList) {
                
                [self.storeList addObject:goodlist];
            }
            NSLog(@"门店详情         = storeListArray = %@",  self.storeList);
            
            _storeName    = detailModel.cmStoreDetailsList.storeName;
            _address      = detailModel.cmStoreDetailsList.address;
            _contactPhone = detailModel.cmStoreDetailsList.contactPhone;
            _payType      = [NSString stringWithFormat:@"%ld", detailModel.cmStoreDetailsList.payType];
            
            _imgArray             = [detailModel.cmStoreDetailsList.attachUrl componentsSeparatedByString:@","];
            _imgArray             = [NSArray array];
            NSLog(@"图片地址         = %@",_imgArray);
            [SVProgressHUD dismiss];
            
        }
        [self cycleScrollViewWithImgArr:_imgArray];
        [self.tableView reloadData];
        
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        [SVProgressHUD dismiss];
        
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
