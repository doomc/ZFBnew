//
//  DetailStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.

//  门店详情

#import "DetailStoreViewController.h"
#import "SDCycleScrollView.h"
#import "ZFDetailStoreCell.h"
#import "ControlFactory.h"
#import "DetailShareViewController.h"

#import "ZFHeadViewCollectionReusableView.h"
#import "DetailStoreModel.h"
#import "DetailFindGoodsViewController.h"
@interface DetailStoreViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout >
{
    
    NSString * _storeName;
    NSString * _address;
    NSString * _stroreUrl;//轮播
    NSString * _contactPhone;
    NSString * _payType;//到店付 1.支持 0.不支持
    NSArray  * imgArray;
    
}
@property(nonatomic,strong) SDCycleScrollView * sd_HeadScrollView;
@property(nonatomic,strong) UICollectionView * main_ColletionView;
@property(nonatomic,strong) UIView * sectionView;
@property(nonatomic,strong) NSMutableArray * storeListArray;

@end

@implementation DetailStoreViewController
-(NSMutableArray *)storeListArray{
    if (!_storeListArray) {
        _storeListArray =[NSMutableArray array];
    }
    return _storeListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    
    [self CreatCollctionViewInterface];
    [self sd_HeadScrollViewInit];
    

}

/**
 分享
 
 @param sender 转发
 */
-(void)shareToFrinds:(UIButton * )sender
{
    DetailShareViewController * shareVC= [[ DetailShareViewController alloc]init];
    [self.navigationController pushViewController:shareVC animated:YES];
    NSLog(@"push share");
}
/**
 初始化轮播
 */
-(void)sd_HeadScrollViewInit
{
    _sd_HeadScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 310*0.5) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _sd_HeadScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sd_HeadScrollView.imageURLStringsGroup = imgArray;
    _sd_HeadScrollView.delegate = self;
    
    //自定义dot 大小和图案
    _sd_HeadScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _sd_HeadScrollView.pageDotImage = [UIImage imageNamed:@"dot_selected"];
    _sd_HeadScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _sd_HeadScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

-(void)CreatCollctionViewInterface
{
    self.title = @"门店详情";
    //自定义导航按钮
    UIButton  * right_btn  =[ UIButton buttonWithType:UIButtonTypeCustom];
    right_btn.frame = CGRectMake(0, 0, 30, 30);
    [right_btn setBackgroundImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [right_btn addTarget:self action:@selector(shareToFrinds:) forControlEvents:UIControlEventTouchUpInside];
    //自定义button必须执行
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UICollectionViewFlowLayout * layout  = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.main_ColletionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH -64) collectionViewLayout:layout];
    
    self.main_ColletionView.backgroundColor = [UIColor whiteColor];
    self.main_ColletionView.delegate =self;
    self.main_ColletionView.dataSource  = self;
    [self.view addSubview:self.main_ColletionView];
    
    
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_main_ColletionView registerNib:[UINib nibWithNibName:@"ZFDetailStoreCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZFDetailStoreCellid"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致
    [_main_ColletionView registerClass:[ZFHeadViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZFHeadViewCollectionReusableView"];
    
    
}
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
    }
    return self.storeListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZFDetailStoreCell  *cell = (ZFDetailStoreCell *)[_main_ColletionView dequeueReusableCellWithReuseIdentifier:@"ZFDetailStoreCellid" forIndexPath:indexPath];
    if (self.storeListArray.count >  0) {
     
        DetailCmgoodslist * detailGoodlist = self.storeListArray[indexPath.item];
        
        cell.detailGoodlist = detailGoodlist;
        
    }
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (KScreenW -30-20-20)*0.5 , 218);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(15,  20 , 10, 20);
    
}


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ZFHeadViewCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZFHeadViewCollectionReusableView" forIndexPath:indexPath];
        headerView.title_lb.text = _storeName;
        headerView.address_lb.text = _address;
        [headerView addSubview: self.sd_HeadScrollView];
        reusableview = headerView;
    }
    
    return reusableview;
    
}

//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(KScreenW , 155+120);
    }
    return CGSizeZero;
    
}
/**
 到店付
 
 @param sender 到店付
 */
-(void)didClickgotoStore_btn:(UIButton*)sender{
    
    NSLog(@"到店付");
    
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailFindGoodsViewController * detailGoodVC = [[DetailFindGoodsViewController alloc]init];
    
    if (self.storeListArray.count > 0) {

        DetailCmgoodslist * goodlist = self.storeListArray[indexPath.item];
        detailGoodVC.goodsId = [NSString  stringWithFormat:@"%ld",goodlist.goodsId] ;
        
        [self.navigationController pushViewController:detailGoodVC animated:NO];
        NSLog(@" item === %ld xxxxxxx goodsId = %ld",indexPath.item,goodlist.goodsId);

    }
    
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
            
            if (self.storeListArray.count > 0) {
                
                [self.storeListArray removeAllObjects];
                
            }
            
            DetailStoreModel * detailModel  = [DetailStoreModel  mj_objectWithKeyValues:response];

            for (DetailCmgoodslist * goodlist in detailModel.cmGoodsList) {
                
                [self.storeListArray addObject:goodlist];
            }
            NSLog(@"门店详情 =storeListArray = %@",  self.storeListArray);

            _storeName =  detailModel.cmStoreDetailsList.storeName;
            _address =  detailModel.cmStoreDetailsList.address;
            _contactPhone =  detailModel.cmStoreDetailsList.contactPhone;
            _payType = [NSString stringWithFormat:@"%ld", detailModel.cmStoreDetailsList.payType];
            
            _stroreUrl =  detailModel.cmStoreDetailsList.attachUrl;
            imgArray = [NSArray array];
            imgArray = [_stroreUrl componentsSeparatedByString:@","];
            NSLog(@"图片地址 = %@",imgArray);

            [SVProgressHUD dismiss];

        }
        [self sd_HeadScrollViewInit];

        [self.main_ColletionView reloadData];


    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
    [SVProgressHUD dismissWithDelay:1];

}


-(void)viewWillAppear:(BOOL)animated
{
    
    [self detailListStorePostRequst];
    
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
