//
//  DetailFindGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  商品详情

#import "DetailFindGoodsViewController.h"
//cell
#import "ZFTitleAndChooseListCell.h"
#import "ZFbabyEvaluateCell.h"
#import "ZFLoctionNavCell.h"
#import "ZFLocationGoToStoreCell.h"
#import "ZFGoodsFooterView.h"
#import "DetailgoodsSelectCell.h"
#import "DetailWebViewCell.h"
#import "SectionCouponCell.h"

//controlller
#import "ZFEvaluateViewController.h"
#import "ZFSureOrderViewController.h"
#import "ZFShoppingCarViewController.h"//购物车
#import "ZFDetailsStoreViewController.h" //店铺


//model
#import "DetailGoodsModel.h"
#import "CouponModel.h"

//sku - view
#import "SukItemCollectionViewCell.h"
#import "SkuFooterReusableView.h"
#import "SkuHeaderReusableView.h"
//view
#import <WebKit/WebKit.h>
#import "TJMapNavigationService.h"
#import "CouponTableView.h"

@interface DetailFindGoodsViewController ()
<
    UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SkuFooterReusableViewDelegate,ZFGoodsFooterViewDelegate,CLLocationManagerDelegate,CouponTableViewDelegate
>
{
    NSString *latitudestr;//经度
    NSString *longitudestr;//纬度
    
    NSString * _goodsName;
    NSString * _storeName;
    NSString * _contactPhone;
    NSString * _juli;
    NSString * _address;
    NSString * _storeId;
    NSString * _inventory;
    NSString * _productSkuId;//传到购物车
    NSString * _coverImgUrl;
    NSString * _attachImgUrl;
    NSString * _inStock;
    NSString * _commentNum;
    NSInteger  _isCollect;
    NSInteger  _goodsSales;
    NSString * _htmlDivString;
    NSString * _netPurchasePrice;//购买价格
    NSString * _priceRange;//范围价格
    NSInteger _goodsCount;//添加的商品个数
    NSString *_goodsUnit;
    //UI控件
    UILabel * lb_Sku;//弹框上视图的选择的sku
    UILabel * lb_inShock ;//库存
    UILabel * lb_price;//价格
    UIImageView * goodsImgaeView ;//视窗视图
    UIButton  * collectButton ;//collectButton收藏按钮
    
    UIWebView * _webview;
    CGFloat _webViewHeight;
    
    //当前匹配的规格model
    SkuMatchModel *_currentSkuMatchModel;
    
}

@property (nonatomic,strong) UITableView       * list_tableView;
@property (nonatomic,strong) UIView            * headerView;
@property (nonatomic,strong) UIView            * popView;
@property (nonatomic,strong) UIView            * BgView;//背景view
@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;//轮播图
@property (nonatomic,strong) CouponTableView   * couponTableView;//优惠券列表
@property (nonatomic,strong) UIView            * couponBgView;//背景视图


//记录规格数组的模型
@property (nonatomic, strong) NSMutableArray<SkuValulist *> *skuValueListArray;
//第一次请求是否存在规格的数组
@property (nonatomic, strong) NSMutableArray *productSkuArray;
//记录选择的值
@property (nonatomic, strong) NSMutableArray *selectedSkuArray;

@property (nonatomic,strong) NSArray * relujsonValueArray ;//色值个数
@property (nonatomic,strong) NSArray            * imagesURLStrings;//轮播数组
@property (nonatomic,strong) UICollectionView   * SkuColletionView;

@property (nonatomic,strong) SkuFooterReusableView * skufooterView;
@property (nonatomic,strong) NSIndexPath           * indexPath;//记录选择的index
@property (nonatomic,strong) ZFGoodsFooterView     * tbFootView;
//map
@property (nonatomic,strong) CLLocationManager * locationManager;

//弹框地图指定到位置
@property (nonatomic ,strong) NSMutableArray * typeCellArr;
@property (nonatomic ,strong) NSMutableArray * skuMatch;//规格匹配数组
//没有规格的立即购买数据
@property (nonatomic ,strong) NSMutableArray    * noReluArray;

@property (nonatomic ,strong) DetailWebViewCell * webCell;
//优惠券列表
@property (nonatomic , strong) NSMutableArray * couponList;



@end

@implementation DetailFindGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _goodsCount = 1;//默认商品数量
    
    [self creatInterfaceDetailTableView];//初始化控件tableview
    [self settingHeaderViewAndFooterView];//初始化footerview
    [self getSkimFootprintsSavePostRequst];//获取到商品name后再加入足记
    [self goodsDetailListPostRequset];//详情网络请求

}

-(void)creatInterfaceDetailTableView
{
    self.title = @"商品详情";
    
    self.list_tableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-50) style:UITableViewStylePlain];
    self.list_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.list_tableView];
    
    self.list_tableView.delegate   = self;
    self.list_tableView.dataSource = self;
    
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFTitleAndChooseListCell" bundle:nil] forCellReuseIdentifier:@"ZFTitleAndChooseListCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFbabyEvaluateCell" bundle:nil]
              forCellReuseIdentifier:@"ZFbabyEvaluateCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFLoctionNavCell" bundle:nil]
              forCellReuseIdentifier:@"ZFLoctionNavCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFLocationGoToStoreCell" bundle:nil] forCellReuseIdentifier:@"ZFLocationGoToStoreCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"DetailgoodsSelectCell" bundle:nil]forCellReuseIdentifier:@"DetailgoodsSelectCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"DetailWebViewCell" bundle:nil]forCellReuseIdentifier:@"DetailWebViewCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"SectionCouponCell" bundle:nil]forCellReuseIdentifier:@"SectionCouponCell"];
    
    _webCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"DetailWebViewCell" ];
    
    
    
}

/**
 设置头尾 视图
 */
-(void)settingHeaderViewAndFooterView
{
    self.tbFootView          = [[ZFGoodsFooterView alloc]initWithFootViewFrame:CGRectMake(0, KScreenH - 50, KScreenW, 50)];
    self.tbFootView.delegate = self;
    [self.view addSubview:self.tbFootView];
    
    //收藏按钮
    collectButton  =[ UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(0, 0, 20, 20);
    [collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
    [collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(didclickLove:) forControlEvents:UIControlEventTouchUpInside];
    
    //自定义button必须执行
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}
#pragma mark - 轮播图
-(void)cycleScrollViewInit
{
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    _cycleScrollView                      = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, KScreenH/2.0) delegate:self placeholderImage:nil];
    _cycleScrollView.imageURLStringsGroup = _imagesURLStrings;
    _cycleScrollView.pageControlStyle     = SDCycleScrollViewPageContolStyleNone;
    _cycleScrollView.delegate             = self;
    _cycleScrollView.autoScroll           = NO;
    _cycleScrollView.infiniteLoop         = NO;
    _cycleScrollView.backgroundColor      = [UIColor whiteColor];
    _cycleScrollView.currentPageDotImage  = [UIImage imageNamed:@"dot_normal"];
    _cycleScrollView.pageDotImage         = [UIImage imageNamed:@"dot_selected"];
    _cycleScrollView.currentPageDotColor  = [UIColor whiteColor];// 自定义分页控件小圆标颜色
    self.list_tableView.tableHeaderView   = _cycleScrollView;//加载轮播
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
    
}

#pragma mark - 优惠券列表懒加载
-(CouponTableView *)couponTableView
{
    if (!_couponTableView ) {
        _couponTableView = [[CouponTableView alloc]initWithFrame:CGRectMake(0, 200, KScreenW, KScreenH - 200)style:UITableViewStylePlain];
        _couponTableView.popDelegate = self;
        _couponTableView.couponesList = self.couponList;
    }
    return _couponTableView;
}
//背景图
-(UIView *)couponBgView{
    if (!_couponBgView) {
        _couponBgView = [[UIView alloc]initWithFrame:self.view.bounds];
        _couponBgView.backgroundColor = RGBA(0, 0, 0,  0.2);
        [_couponBgView addSubview:self.couponTableView];
    }
    return _couponBgView;
}


#pragma mark - ZFGoodsFooterViewDelegate 底部的视图的dedegate
//客服
-(void)didClickContactRobotView
{
    NSLog(@"点击了客服");
}
#pragma mark - 店铺
-(void)didClickStoreiew
{
    NSLog(@"进入店铺");
    ZFDetailsStoreViewController * storeVC = [[ZFDetailsStoreViewController alloc]init];
    storeVC.storeId                     = _storeId;
    [self.navigationController pushViewController:storeVC animated:NO];
}
#pragma mark - 购物车
-(void)didClickShoppingCariew
{
    ZFShoppingCarViewController * shopVC = [[ZFShoppingCarViewController alloc]init];
    [self.navigationController pushViewController:shopVC animated:NO];
}
#pragma mark - 加入购物车- 不选择规格
//加入购物车
-(void)didClickAddShoppingCarView
{
    //没有规格 - 直接加入购物车
    if (self.productSkuArray.count > 0){
        
        [self popActionView];
        
    }else{
        
        [self addToshoppingCarPostproductId:_productSkuId];
        
    }
    
}
#pragma mark -  立即购买无规格
-(void)didClickBuyNowView
{
    if (self.productSkuArray.count > 0) {

        //先选规格  在传值
        [self popActionView];
        
    }else{
        //没有规格 - 直接传值
        if ([_inventory intValue] > 0) {
            
            ZFSureOrderViewController * vc =[[ZFSureOrderViewController alloc]init];
            vc.userGoodsInfoJSON = _noReluArray;//没有规格的数组
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"这个商品已经没有库存了！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:sure];
            [self presentViewController:alertVC animated:YES completion:nil];
            
        }
    }
}


#pragma mark -SecondAddShopCar 加入购物车选择规格
-(void)SecondAddShopCar:(UIButton *)button
{
    //如果规格全选了
    if ([self isSKuAllSelect]) {
        
        //添加有规格的数据进入购物车  传入有规格的json数据
        [self addToshoppingCarPostproductId:_productSkuId];
        
    }else{
        
        JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"请选择好规格再加入购物车" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:sure];
        [self presentViewController:alertVC animated:NO completion:nil];
    }
    
}
//立即购买 有规格的
-(void)SecondBuyNowAction:(UIButton *)button
{
    //如果规格全选了
    if ([self isSKuAllSelect]) {
        
        ZFSureOrderViewController * vc =[[ZFSureOrderViewController alloc]init];
        
        NSMutableArray * userGoodsInfoJSON  =[ NSMutableArray array];
        NSMutableArray * goodslistArray  =[ NSMutableArray array];
        NSMutableDictionary * storedic = [NSMutableDictionary dictionary];
        NSMutableDictionary * goodsdic = [NSMutableDictionary dictionary];
    
        [userGoodsInfoJSON removeAllObjects];
  
 
        [goodsdic setObject:self.selectedSkuArray forKey:@"goodsProp"];
        [goodsdic setObject:_coverImgUrl forKey:@"coverImgUrl"];
        [goodsdic setObject:_goodsName forKey:@"goodsName"];
        [goodsdic setObject:_goodsId forKey:@"goodsId"];
        [goodsdic setObject:_netPurchasePrice forKey:@"purchasePrice"];
        [goodsdic setObject:_productSkuId forKey:@"productId"];
        [goodsdic setObject:[NSString stringWithFormat:@"%ld",_goodsCount] forKey:@"goodsCount"];
        [goodsdic setValue:@"0" forKey:@"concessionalPrice"];//优惠价
        [goodsdic setObject:_storeId forKey:@"storeId"];
        [goodsdic setObject:_storeName forKey:@"storeName"];
        [goodsdic setValue:_goodsUnit forKey:@"goodsUnit"];
        [goodsdic setValue:_netPurchasePrice forKey:@"originalPrice"];
        [goodslistArray addObject:goodsdic];
        
        [storedic setObject:_storeId forKey:@"storeId"];
        [storedic setObject:_storeName forKey:@"storeName"];
        [storedic setObject:goodslistArray forKey:@"goodsList"];
        [userGoodsInfoJSON addObject:storedic];
       
        NSLog(@"商品详情有规格的数组 userGoodsInfoJSON === %@",userGoodsInfoJSON);
        vc.userGoodsInfoJSON = userGoodsInfoJSON ;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"请选择好规格再加入购物车" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:sure];
        [self presentViewController:alertVC animated:NO completion:nil];
    }
}

/**
 点爱心
 
 @param sender 收藏/取消收藏
 */
-(void )didclickLove:(UIButton *)sender
{
    sender.selected = !sender.selected;
    ///是否收藏	1.收藏 2.不是
    if (_isCollect == 1) {
        
        [self cancelCollectedPostRequest];//取消收藏
        
    }else{
        
        [self addCollectedPostRequest]; //添加收藏
        
    }
    
}
#pragma mark - DetailWebViewCellDelegate 获取webview高度
-(void)getHeightForWebView:(CGFloat)Height
{
    //    NSLog(@" 前台获取到的度 =======  %f",Height);
    _webViewHeight = Height;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.list_tableView reloadData];
    });
    
}

#pragma mark  -tableView  delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 68;
            break;
            
        case 1:
            
            if (self.productSkuArray != nil && ![self.productSkuArray isKindOfClass:[NSNull class]] && self.productSkuArray.count != 0){
                height = 41;
                
            }else{
                height = 0;
                
            }
            break;
            
        case 2:
            if (![self isEmptyArray:self.couponList]) {
                height = 44;
            }else{
                height = 0;
            }
            break;
            
        case 3:
            height = 44;
            break;
            
        case 4:
            height = 44;
            break;
            
        case 5:
            height = 54;
            break;
            
        case 6:
            
            height = 44;

            break;
        case 7:
            
            height = _webViewHeight;
            break;
        default:
            break;
    }
    return height;
}

#pragma mark  - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://商品名
        {
            
            ZFTitleAndChooseListCell  * listCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFTitleAndChooseListCell" forIndexPath:indexPath];
            listCell.selectionStyle              = UITableViewCellSelectionStyleNone;
            listCell.lb_title.text               = _goodsName;
            listCell.lb_price.text               = [NSString stringWithFormat:@"¥%@",_priceRange];
            listCell.lb_sales.text               = [NSString stringWithFormat:@"已售%ld件",_goodsSales];
            return listCell;
            
        }
            
            break;
            
        case 1://选项规格
        {
            DetailgoodsSelectCell  *  selectCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"DetailgoodsSelectCell" forIndexPath:indexPath];
            
            if (self.productSkuArray != nil && ![self.productSkuArray isKindOfClass:[NSNull class]] && self.productSkuArray.count != 0){
                
                selectCell.lb_selectSUK.text = [NSString stringWithFormat:@"请选择规格"];
                selectCell.selectionStyle    = UITableViewCellSelectionStyleNone;
                selectCell.hidden            = NO;
                
            }else{
                
                selectCell.hidden = YES;
            }
            return selectCell;
            
        }
            break;
        case 2://领取优惠券
        {
            SectionCouponCell * couponCell =  [self.list_tableView dequeueReusableCellWithIdentifier:@"SectionCouponCell" forIndexPath:indexPath];
            if (![self isEmptyArray:self.couponList]) {
                //关键字
                NSInteger count = self.couponList.count;
                couponCell.lb_title.text = [NSString stringWithFormat:@"您有 %ld 张可使用的的优惠券",count];
                couponCell.lb_title.keywords      = [NSString stringWithFormat:@"%ld",count];
                couponCell.lb_title.keywordsColor = HEXCOLOR(0xfe6d6a);
                couponCell.lb_title.keywordsFont  = [UIFont systemFontOfSize:18];
                ///必须设置计算宽高
                CGRect dealNumh              = [couponCell.lb_title getLableHeightWithMaxWidth:300];
                couponCell.lb_title.frame = CGRectMake(15, 10, dealNumh.size.width, dealNumh.size.height);
                
                return couponCell;

             }else{
                 couponCell.hidden = YES;
                 return couponCell;

             }
            
        }
            break;
            
        case 3://评论
        {
            ZFbabyEvaluateCell  *  babyCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFbabyEvaluateCell" forIndexPath:indexPath];
            babyCell.lb_commonCount.text    = [NSString stringWithFormat:@"(%@)",_commentNum];
            babyCell.selectionStyle         = UITableViewCellSelectionStyleNone;
            babyCell.lb_title.text          = @"宝贝评价";
            return babyCell;
        }
            break;
        case 4://定位
        {
            
            ZFLoctionNavCell  *  locaCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFLoctionNavCell" forIndexPath:indexPath];
            locaCell.selectionStyle       = UITableViewCellSelectionStyleNone;
            [locaCell.whereTogo addTarget:self action:@selector(whereTogoMap:) forControlEvents:UIControlEventTouchUpInside];
            [locaCell.contactPhone addTarget:self action:@selector(contactPhone:) forControlEvents:UIControlEventTouchUpInside];
            
            return locaCell;
            
        }
            break;
        case 5:
        {
            ZFLocationGoToStoreCell  *  goToStoreCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFLocationGoToStoreCell" forIndexPath:indexPath];
            goToStoreCell.selectionStyle              = UITableViewCellSelectionStyleNone;
            CGFloat juli                              = [_juli floatValue]*0.001;
            goToStoreCell.lb_address.text             = [NSString stringWithFormat:@"%@  %.2fkm",_address,juli];
            goToStoreCell.lb_storeName.text           = _storeName;
            
            return goToStoreCell;
            
        }
            break;
        case 6://宝贝详情
        {
            ZFbabyEvaluateCell  *  goodsDetailCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFbabyEvaluateCell" forIndexPath:indexPath];
            goodsDetailCell.selectionStyle         = UITableViewCellSelectionStyleNone;
            goodsDetailCell.lb_title.text          = @"宝贝详情";
            [goodsDetailCell.lb_commonCount removeFromSuperview];
            [goodsDetailCell.img_arrowRight removeFromSuperview];
            
            return goodsDetailCell;
            
        }
            break;
        case 7://web
        {

            return _webCell;
        }
            break;
        default:
            break;
    }
    
    
    return  _webCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld,row == %ld",indexPath.section ,indexPath.row);
    switch (indexPath.row) {
        case 0:
            break;
            
        case 1:
            if (self.productSkuArray.count > 0) {
               
                [self popActionView];
                
            }
            break;
        case 2://获取优惠券列表
        {
            if (![self isEmptyArray:self.couponList]) {
                
                [self.view addSubview:self.couponBgView];
                [self.list_tableView bringSubviewToFront:self.couponBgView];
            }

        }
            break;

        case 3:
            //评论列表
        {
            ZFEvaluateViewController * evc = [[ZFEvaluateViewController alloc]init];
            evc.goodsId                    = _goodsId;
            [self.navigationController pushViewController:evc animated:YES];
        }
            break;
            
        case 4:
            
            break;
            
        case 5:
            break;
            
        case 6:
            break;
            
        case 7:
            
            break;

    }
}



#pragma mark - SKUColleView - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.productSkuArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Productattribute * product = self.productSkuArray[section];
    return   product.valueList.count;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KScreenW/3-40, 30);
}
// 设置整个组的缩进量是多少
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//设置headview
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = @"header";
    }
    SkuHeaderReusableView* headerView = [self.SkuColletionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        Productattribute * product = self.productSkuArray[indexPath.section];
        headerView.lb_title.text   = product.name;
    }
    
    return headerView;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SukItemCollectionViewCell *cell = [self.SkuColletionView
                                       dequeueReusableCellWithReuseIdentifier:@"SukItemCollectionViewCellid" forIndexPath:indexPath];
    
    if (self.productSkuArray.count > 0) {
        
        Productattribute *product = self.productSkuArray[indexPath.section];
        Valuelist *value          = product.valueList[indexPath.item];
        cell.valueObj = value;
        
        return cell;
        
    }
    return  nil;
    
}

#pragma mark - 选择规格
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Productattribute *product = self.productSkuArray[indexPath.section];
    Valuelist *value          = product.valueList[indexPath.item];
    if (!(value.selectType == ValueSelectType_enable)) {
        if (value.selectType == ValueSelectType_normal) {
            for (Valuelist *valueItem in product.valueList) {
                if (value.valueId == valueItem.valueId) {
                    value.selectType = ValueSelectType_selected;
                }else {
                    valueItem.selectType = ValueSelectType_normal;
                }
            }
        }else {
            value.selectType = ValueSelectType_normal;
        }
    }
    if (!(value.selectType == ValueSelectType_enable)) {
        
        [self getSkuMatchParamts];
    }
}
#pragma mark - 规格问题
//获取要选择的规格
-(void)getSkuMatchParamts {
    
    NSMutableDictionary *skuMatchParamts = [NSMutableDictionary dictionary];
    NSMutableDictionary *skuMatchPrice   = [NSMutableDictionary dictionary];
    
    NSMutableArray *selectValueArray    = [NSMutableArray array];
    NSMutableArray *selectReluJsonArray = [NSMutableArray array];
    
    for (Productattribute *product in self.productSkuArray) {
        for (Valuelist *value in product.valueList) {
            if (value.selectType == ValueSelectType_selected) {
                
                //保存匹配规格的数据
                NSDictionary *selectValueDict = @{@"nameId": [NSString stringWithFormat:@"%ld", value.nameId], @"valueId": [NSString stringWithFormat:@"%ld", value.valueId]};
                [selectValueArray addObject:selectValueDict];

                //保存匹配价格的数据
                NSDictionary * priceDict = @{@"name":product.name,@"nameId": [NSString stringWithFormat:@"%ld", value.nameId], @"valueId": [NSString stringWithFormat:@"%ld", value.valueId],@"value":value.name};
                [selectReluJsonArray addObject:priceDict];
 
            }
        }
    }
    
    [skuMatchParamts setObject:_goodsId forKey:@"goodsId"];
    [skuMatchParamts setObject:selectValueArray forKey:@"attr"];
    
    [skuMatchPrice setObject:_goodsId forKey:@"goodsId"];
    [skuMatchPrice setObject:selectReluJsonArray forKey:@"reluJson"];
    self.selectedSkuArray = selectReluJsonArray;
    
    NSLog(@"selectReluJsonArray = %@",selectReluJsonArray);
    if (selectValueArray.count > 0) {
        //匹配规格
        [self skuMatchPostRequsetWithParam:skuMatchParamts];
        
        if ([self isSKuAllSelect]) {
            //匹配价格
            [self skuMatchPricePostRequsetParam:skuMatchPrice];
        }
        
    }else {
        
        [self.SkuColletionView reloadData];
    }
}
//取消上次规格
-(void)resetSkuMatch {
    
    for (Productattribute *product in self.productSkuArray) {
        for (Valuelist *value in product.valueList) {
            if (value.selectType == ValueSelectType_enable) {
                value.selectType = ValueSelectType_normal;
            }
        }
    }
}
//匹配规格
-(void)matchSku {
    for (Productattribute *product in self.productSkuArray) {
        for (Valuelist *value in product.valueList) {
            BOOL isEnable = YES;//用来标记不可选
            for (SkuValulist *skuValue in self.skuValueListArray) {
                if (skuValue.valueId == value.valueId) {  //找到当前规格
                    if (!(value.selectType == ValueSelectType_selected)) {  //如果当前选中就还是选中
                        value.selectType = ValueSelectType_normal;
                    }
                    isEnable = NO;//可选
                    break;
                }
            }
            if (isEnable) { //找到不可选
                value.selectType = ValueSelectType_enable;
            }
        }
    }
}
#pragma mark - 到这去 唤醒地图
-(void)whereTogoMap:(UIButton *)sender
{
    //当前位置导航到指定地
    CGFloat endLat       = 39.54;
    CGFloat endLot       = 116.23;
    NSString *endAddress = @"北京";
    
    CGFloat startLat = [BBUserDefault.latitude floatValue];
    CGFloat startLot = [BBUserDefault.longitude floatValue];
    
    TJMapNavigationService *mapNavigationService = [[TJMapNavigationService alloc] initWithStartLatitude:startLat startLongitude:startLot endLatitude:endLat endLongitude:endLot endAddress:endAddress locationType:LocationType_Mars];
    
    [mapNavigationService showAlert];
}

#pragma mark - 联系门店 唤醒地图
-(void)contactPhone:(UIButton *)sender
{
    JXTAlertController * alert = [JXTAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确认拨打号码:%@联系门店吗",_contactPhone]  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * sure =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIWebView *callWebView = [[UIWebView alloc] init];
        
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_contactPhone]];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebView];
        
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - deleteRemoveTheBackgroundView 删除操作
-(void)deleteRemoveTheBackgroundView:(UIButton *)sender
{
    NSLog(@"didClick");
    if (self.BgView != nil) {
        
        [self.BgView removeFromSuperview];
    }
}

#pragma mark  - 选择商品数量
-(void)addCount:(NSInteger)count
{
    NSLog(@"count ===== %ld",count);
    _goodsCount = count;
    
}

#pragma mark -  弹框选择规格 popActionView ----------
-(void)popActionView
{
    
    _BgView                 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    _BgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3f];
    [self.view addSubview:self.BgView];
    [self.list_tableView bringSubviewToFront:_BgView];
    
    self.popView                 = [[UIView alloc]init];
    self.popView.backgroundColor = [UIColor whiteColor];
    [_BgView addSubview:self.popView];
    
    //头视图
    UIView * headView           = [[UIView alloc]initWithFrame:CGRectMake(30, -10, 80, 80)];
    headView.backgroundColor    = [UIColor whiteColor];
    headView.clipsToBounds      = YES;
    headView.layer.cornerRadius = 2;
    [self.popView addSubview:headView];
    
    goodsImgaeView               = [[UIImageView alloc]init];
    goodsImgaeView.clipsToBounds = YES;
    [goodsImgaeView sd_setImageWithURL:[NSURL URLWithString:_headerImage] placeholderImage:[UIImage imageNamed:@""]];
    [headView addSubview:goodsImgaeView];
    
    
    lb_price           = [UILabel new];
    lb_price.text      = @"价格: ¥0.00";//[NSString stringWithFormat:@"¥%@",_netPurchasePrice]
    lb_price.textColor = HEXCOLOR(0xfe6d6a);
    lb_price.font      = [UIFont systemFontOfSize:14];
    [self.popView addSubview:lb_price];
    
    //库存
    lb_inShock           = [UILabel new];
    lb_inShock.text =@"库存:0";
    lb_inShock.textColor = HEXCOLOR(0xfe6d6a);
    lb_inShock.font      = [UIFont systemFontOfSize:12];
    [self.popView addSubview:lb_inShock];
    
    //lb_Sku规格
    lb_Sku           = [UILabel new];
    lb_Sku.text      = @"已选择:";
    lb_Sku.textColor = HEXCOLOR(0xfe6d6a);
    lb_Sku.font      = [UIFont systemFontOfSize:12];
    [self.popView addSubview:lb_Sku];
    
    UILabel * lb_line       = [UILabel new];
    lb_line.backgroundColor = HEXCOLOR(0xfe6d6a);
    [self.popView addSubview:lb_line];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //    layout.footerReferenceSize = CGSizeMake(KScreenW, 40);
    layout.headerReferenceSize          = CGSizeMake(KScreenW, 30);
    layout.scrollDirection              = UICollectionViewScrollDirectionVertical;
    
    
    self.SkuColletionView                 = [[UICollectionView alloc]initWithFrame:CGRectMake(30, 90, KScreenW - 60, 80) collectionViewLayout:layout];
    self.SkuColletionView.delegate        = self;
    self.SkuColletionView.dataSource      = self;
    self.SkuColletionView.backgroundColor = [UIColor whiteColor];
    [self.popView addSubview:self.SkuColletionView];
    
    //注册nib 和区头
    [self.SkuColletionView registerNib:[UINib nibWithNibName:@"SukItemCollectionViewCell" bundle:nil]
            forCellWithReuseIdentifier:@"SukItemCollectionViewCellid"];
    [self.SkuColletionView  registerClass:[SkuHeaderReusableView class]
               forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.SkuColletionView registerNib:[UINib nibWithNibName:@"SkuFooterReusableView" bundle:nil]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    self.skufooterView = [[NSBundle mainBundle]loadNibNamed:@"SkuFooterReusableView" owner:self options:nil].lastObject;
    
    //////////------高度 只能在代理走完了才可以获取到------////////
    CGFloat collectionViewHeight = self.SkuColletionView.collectionViewLayout.collectionViewContentSize.height ;
    self.SkuColletionView.frame  = CGRectMake(30, 90, KScreenW - 60, collectionViewHeight);
    
    self.skufooterView.countDelegate = self;
    [self.popView addSubview:self.skufooterView];
    
    //  删除
    UIButton * delete         = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.clipsToBounds      = YES;
    delete.layer.cornerRadius = 4;
    delete.titleLabel.font    = [UIFont systemFontOfSize:14];
    //    delete.backgroundColor    = HEXCOLOR(0xfe6d6a);
    [delete setImage:[UIImage imageNamed:@"delete_sku"] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteRemoveTheBackgroundView:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:delete];
    
    //加入购物车
    UIButton * addShopCar         = [UIButton buttonWithType:UIButtonTypeCustom];
    addShopCar.clipsToBounds      = YES;
    addShopCar.layer.cornerRadius = 4;
    addShopCar.titleLabel.font    = [UIFont systemFontOfSize:14];
    addShopCar.backgroundColor    = HEXCOLOR(0xfe6d6a);
    [addShopCar setTitle:@"加入购物车"forState:UIControlStateNormal];
    [addShopCar addTarget:self action:@selector(SecondAddShopCar:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:addShopCar];
    
    //立即抢购
    UIButton * buyNow         = [UIButton buttonWithType:UIButtonTypeCustom];
    buyNow.clipsToBounds      = YES;
    buyNow.layer.cornerRadius = 4;
    buyNow.titleLabel.font    = [UIFont systemFontOfSize:14];
    buyNow.backgroundColor    = HEXCOLOR(0xfe6d6a);
    [buyNow setTitle:@"立即抢购"forState:UIControlStateNormal];
    [buyNow addTarget: self action:@selector(SecondBuyNowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:buyNow];
    
    //添加约束
    [goodsImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    //colletionView
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.center.equalTo(self.BgView);
        make.bottom.equalTo(self.BgView).with.offset(0);
        make.left.equalTo(self.BgView).with.offset(0);
        make.right.equalTo(self.BgView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KScreenW, collectionViewHeight + 90 + 50 + 40 + 20));
        
    }];
    
    //价格
    [lb_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).with.offset(10);
        make.top.equalTo(self.popView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 15));
    }];
    //库存
    [lb_inShock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).with.offset(10);
        make.top.equalTo(lb_price.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 15));
        
    }];
    //规格尺寸
    [lb_Sku mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).with.offset(10);
        make.top.equalTo(lb_inShock.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(200, 15));
    }];
    
    //线
    [lb_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.popView).with.offset(0);
        make.top.equalTo(headView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(KScreenW, 0.5));
    }];
    
    //SkuColletionView
    [self.SkuColletionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.popView).with.insets(UIEdgeInsetsMake(90, 30, 100, 30));
    }];
    
    //footerView
    [self.skufooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SkuColletionView.mas_bottom).with.offset(10);
        make.left.equalTo(self.popView).with.offset(10);
        make.right.equalTo(self.popView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(KScreenW , 30));
    }];
    //删除按钮
    [delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.popView).with.offset(10);
        make.right.equalTo(self.popView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        
    }];
    //加入购物车按钮
    [addShopCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.skufooterView.mas_bottom).with.offset(10);
        make.left.equalTo(self.popView).with.offset(30);
        make.size.mas_equalTo(CGSizeMake((KScreenW - 120)/2, 40));
        
    }];
    //抢购按钮
    [buyNow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.skufooterView.mas_bottom).with.offset(10);
        make.right.equalTo(self.popView).with.offset(-30);
        make.size.mas_equalTo(CGSizeMake((KScreenW - 120)/2, 40));
        
    }];
    
    
}
#pragma mark - 判断是否收藏了
-(void)iscollect
{
    if (_isCollect == 1) {///是否收藏	1.收藏 2.不是
        
        [collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateNormal];
        
    }else
    {
        [collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
    }
}
#pragma mark - 判断规格是否全部选取
//判断规格是否全部选取
-(BOOL)isSKuAllSelect {
    
    NSInteger selectCount = 0;
    for (Productattribute *attribute in self.productSkuArray) {
        
        for (Valuelist *value in attribute.valueList) {
            
            if (value.selectType == ValueSelectType_selected) {
                selectCount++;
            }
        }
    }
    if (selectCount == self.productSkuArray.count) {
        return YES;
    }else {
        return NO;
    }
}


#pragma mark - < CouponTableViewDelegate > 领取优惠券代理
//关闭弹框
-(void)didClickCloseCouponView
{
    [self.couponBgView removeFromSuperview];
    [self.couponTableView  reloadData];
}
//领取优惠券接口
-(void)selectCouponWithIndex:(NSInteger)indexRow AndCouponId :(NSString *)couponId withResult:(NSString *)result{
    NSLog(@"  %ld ------ %@",indexRow,result);
    
    //领取优惠券  接口
    [self getCouponesPostRequst:couponId];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.couponBgView removeFromSuperview];
    
}

#pragma mark  - 商品详情 网络请求getGoodsDetailsInfo
-(void)goodsDetailListPostRequset{
    
    NSLog(@" 经度 %@ ----- 纬度 %@",latitudestr,longitudestr);
    NSDictionary * parma = @{
                             
                             @"latitude":BBUserDefault.latitude,
                             @"longitude":BBUserDefault.longitude,
                             @"goodsId":_goodsId,//商品id
                             @"userId":BBUserDefault.cmUserId,//商品id
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsDetailsInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.productSkuArray.count > 0) {
                
                [self.productSkuArray removeAllObjects];
            }
            if (self.noReluArray.count > 0) {
                
                [self.noReluArray removeAllObjects ];
            }
            
            DetailGoodsModel * goodsmodel = [DetailGoodsModel mj_objectWithKeyValues:response];
            //goods信息 ----goodsInfo
            _goodsName    = goodsmodel.data.goodsInfo.goodsName;//商品名
            _coverImgUrl  = goodsmodel.data.goodsInfo.coverImgUrl;//商品封面
            _attachImgUrl = goodsmodel.data.goodsInfo.attachImgUrl;//图片链接
            _goodsSales   = goodsmodel.data.goodsInfo.goodsSales;//已经销售
            _commentNum   = goodsmodel.data.goodsInfo.commentNum;//评论数
            _isCollect    = [goodsmodel.data.goodsInfo.isCollect integerValue];//是否收藏
            _storeId      = [NSString stringWithFormat:@"%ld",goodsmodel.data.goodsInfo.storeId];//店铺id
            _inventory    = goodsmodel.data.goodsInfo.inventory;//库存
            _productSkuId = goodsmodel.data.goodsInfo.productSkuId;//没有规格的用改字段，用来请求购物车列表
            
            //store信息 ----storeInfo
            _storeName    = goodsmodel.data.storeInfo.storeName;//店名
            _contactPhone = goodsmodel.data.storeInfo.contactPhone;//联系手机号
            _address      = goodsmodel.data.storeInfo.address;//门店地址
            _juli         = goodsmodel.data.storeInfo.storeDist;//门店距离
            
            //图片详情网址
            _htmlDivString = goodsmodel.data.goodsInfo.goodsDetail;//网址
            _priceRange  = goodsmodel.data.goodsInfo.priceRange;//范围价格
            
            //获取到H5的标签
            [self mas_MutableStringWithHTMLString:_htmlDivString];
            if (_isCollect == 1) {///是否收藏	1.收藏 2.不是
                
                [collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateNormal];
                
            }else
            {
                [collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
            }
            
            for (Productattribute * product in goodsmodel.data.productAttribute) {
                
                [self.productSkuArray addObject:product];
                
            }
            //当规格为空的时候才组装下列数据
            if (self.productSkuArray != nil && ![self.productSkuArray isKindOfClass:[NSNull class]] && self.productSkuArray.count != 0){
                
                _netPurchasePrice = goodsmodel.data.goodsInfo.netPurchasePrice;//价格
                
            }else{
                //没有规格的价格
                _netPurchasePrice = goodsmodel.data.goodsInfo.netPurchasePrice;//网店价格
                
                //---------------没有规格的数据------------------
                NSMutableArray * goodsListArray    = [NSMutableArray array];
                NSMutableDictionary * goodsListDic = [NSMutableDictionary dictionary];
                NSMutableDictionary * storeListDic = [NSMutableDictionary dictionary];
                
                [goodsListDic setValue:goodsmodel.data.storeInfo.storeName forKey:@"storeName"];
                [goodsListDic setValue:_netPurchasePrice forKey:@"originalPrice"];
                [goodsListDic setValue:@"0" forKey:@"concessionalPrice"];//优惠价
                [goodsListDic setValue:goodsmodel.data.goodsInfo.coverImgUrl forKey:@"coverImgUrl"];//图片地址
                [goodsListDic setValue:goodsmodel.data.goodsInfo.netPurchasePrice forKey:@"purchasePrice"];//网购价
                [goodsListDic setValue:_goodsId forKey:@"goodsId"];
                [goodsListDic setValue:_storeId forKey:@"storeId"];
                [goodsListDic setObject:@"[]" forKey:@"goodsProp"];
                [goodsListDic setValue:_productSkuId forKey:@"productId"];//无规格
                _goodsUnit = goodsmodel.data.goodsInfo.goodsUnit ;
                
                [goodsListDic setValue:_goodsUnit forKey:@"goodsUnit"];
                [goodsListDic setValue:goodsmodel.data.goodsInfo.goodsName forKey:@"goodsName"];
                [goodsListDic setValue:[NSString stringWithFormat:@"%ld",_goodsCount] forKey:@"goodsCount"];
                [goodsListArray addObject:goodsListDic];
                
                [storeListDic setValue:goodsListArray forKey:@"goodsList"];
                [storeListDic setValue:_storeName forKey:@"storeName"];
                [storeListDic setValue:_storeId forKey:@"storeId"];
                [self.noReluArray addObject:storeListDic];
                NSLog(@"noReluArray ==  %@",self.noReluArray);
                //---------------没有规格的数据------------------
                
            }
            
            _imagesURLStrings = [[NSArray alloc]init];
            _imagesURLStrings = [_attachImgUrl componentsSeparatedByString:@","];
            [self cycleScrollViewInit];

            [self getUserNotUseCouponListPostRequset];//获取优惠券

        }
        [SVProgressHUD dismiss];
        [self.list_tableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(void)mas_MutableStringWithHTMLString:(NSString *)HTMLString
{
    NSAttributedString * attrStr1 = [[NSAttributedString alloc] initWithData:[HTMLString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    
    [attrStr1 enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrStr1.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[NSTextAttachment class]]) {
            NSTextAttachment * attachment = value;
            CGFloat height = attachment.bounds.size.height;
            CGFloat width = attachment.bounds.size.width;
            
            CGFloat newheiht = height*(KScreenW-30)/width;
            
            attachment.bounds = CGRectMake(0, 0, KScreenW-30, newheiht);
        }
    }];
    
    _webCell.labelhtml.attributedText = attrStr1;
    CGFloat webheight ;
    webheight  =  [self calculateMeaasgeHeightWithText:attrStr1 andWidth:KScreenW - 30 andFont:[UIFont systemFontOfSize:16]];
    
    _webCell.labelhtml.frame = CGRectMake(15, 15, KScreenW - 30, webheight);
    _webCell.labelhtml.numberOfLines = 0;
    _webViewHeight = webheight;
    
}
- (CGFloat)calculateMeaasgeHeightWithText:(NSAttributedString *)string andWidth:(CGFloat)width andFont:(UIFont *)font {
    static UILabel *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//生成一个同于计算文本高度的label
        stringLabel = [[UILabel alloc] init];
        stringLabel.numberOfLines = 0;
    });
    stringLabel.font = font;
    stringLabel.attributedText = string;
    return [stringLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;

}


#pragma mark - 添加收藏 getKeepGoodInfo
-(void)addCollectedPostRequest
{
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"goodId":_goodsId,
                             @"goodName":_goodsName,//商品名
                             @"collectType":@"1",//1收藏商品 2收藏门店
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getKeepGoodInfo",zfb_baseUrl] params:parma success:^(id response) {
      
        _isCollect = 1;
        [self iscollect];
   
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
#pragma mark - 取消收藏 cancalGoodsCollect
-(void)cancelCollectedPostRequest
{
    NSDictionary * parma = @{
                             
                             @"goodId":_goodsId,
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"collectType" :@"1"    //collectType	string	收藏类型	1商品 2门店	否
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/cancalGoodsCollect",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            _isCollect = 0;
            [self iscollect];
        }
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 浏览足记 getSkimFootprintsSave
-(void)getSkimFootprintsSavePostRequst
{
    NSDictionary * parma = @{
                             
                             @"goodId":_goodsId,
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"goodName":_goodsName,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getSkimFootprintsSave",zfb_baseUrl] params:parma success:^(id response) {
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
    }];
    
}


#pragma mark - skuMatch 规格匹配 ////第1步
-(NSMutableArray<SkuValulist *> *)skuValueListArray {
    
    if (!_skuValueListArray) {
        _skuValueListArray = [NSMutableArray array];
    }
    return _skuValueListArray;
}

//匹配规格
-(void)skuMatchPostRequsetWithParam :(NSDictionary *) parma
{
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/skuMatch",zfb_baseUrl] params:parma success:^(id response) {
        _currentSkuMatchModel = [SkuMatchModel mj_objectWithKeyValues:response];
        
        //匹配前清空清空之前保存的
        [self.skuValueListArray removeAllObjects];
        for (Skumatch *skumatch in _currentSkuMatchModel.data.skuMatch) {
            for (SkuValulist *skuValue in skumatch.valuList) {
                
                [self.skuValueListArray addObject:skuValue];
            }
        }
        //先取消上次匹配
        [self resetSkuMatch];
        //再匹配规格
        [self matchSku];
        
        [self.SkuColletionView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        
    }];
    
}

#pragma mark - skuMatchPrice 规格匹配价格库存数量信息////第2步
-(void)skuMatchPricePostRequsetParam:(NSDictionary*)parma
{
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/skuMatchPrice",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            //更新价格和数据
            NSMutableArray * chooseArray = [NSMutableArray array];
            
            NSString * originalPriceStr = _netPurchasePrice = response[@"data"][@"originalPriceStr"];
            NSNumber * amount           = response[@"data"][@"amount"];
            NSArray * relujsonArr       = response[@"data"][@"reluJson"];
            
            for (NSDictionary * sukDic in relujsonArr) {
                
                NSString * value = [sukDic objectForKey:@"value"];
                [chooseArray addObject:value];
            }
            
            NSString * chooseString = [chooseArray componentsJoinedByString:@" "];
            
            if (originalPriceStr == nil || amount == nil ) {
                lb_price.text   = @"价格:";
                lb_inShock.text = @"库存:";
                
            }else{
                
                lb_Sku.text     = [NSString stringWithFormat:@"已选择:%@",chooseString];
                lb_price.text   = [NSString stringWithFormat:@"价格:¥%@",originalPriceStr];
                lb_inShock.text = [NSString stringWithFormat:@"库存:%@",amount];
            }
            _productSkuId = response[@"data"][@"productSkuId"];
            NSLog(@"_productSkuId ========选择后的=============%@",_productSkuId);
        }
        [self.SkuColletionView reloadData];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        
    }];
    
}
#pragma mark - 添加到购物车:ShoppCartJoin////第3步
-(void)addToshoppingCarPostproductId:(NSString *)productId
{
    
    NSString * count = [NSString stringWithFormat:@"%ld",_goodsCount];
    
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"storeId":_storeId,
                             @"storeName":_storeName,
                             @"goodsId":_goodsId,
                             @"goodsCount":count,//商品个数
                             @"productId":productId,//商品规格
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/ShoppCartJoin",zfb_baseUrl] params:parma success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
        if (self.BgView != nil) {
            
            [self.BgView removeFromSuperview];
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        
    }];
    
    
}
#pragma mark - 获取用户未使用优惠券列表   recomment/getUserNotUseCouponList
-(void)getUserNotUseCouponListPostRequset{
    NSDictionary * parma = @{
                             @"goodsAmount":_netPurchasePrice,//商品价格
                             @"goodsCount":[NSString stringWithFormat:@"%ld",_goodsCount],//数量
                             @"goodsId":_goodsId,
                             @"storeId":_storeId,
                             @"userId":BBUserDefault.cmUserId,
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":@"100",
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/getUserNotUseCouponList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
        
            if (self.couponList.count > 0) {
                [self.couponList removeAllObjects];
            }
            CouponModel * coupon = [CouponModel mj_objectWithKeyValues:response];
            for (Couponlist * list in coupon.couponList) {
                [self.couponList addObject:list];
            }
            [self.couponTableView reloadData];
        }
        [SVProgressHUD dismiss];
        [self.list_tableView reloadData];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
    }];
    
}
#pragma mark - 点击领取优惠券    recomment/receiveCoupon
-(void)getCouponesPostRequst:(NSString *)couponId
{
    NSDictionary * parma = @{
                             
                             @"couponId":couponId,
                             @"userId":BBUserDefault.cmUserId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/receiveCoupon"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            
            [self.view makeToast:@"领取优惠券成功" duration:2 position:@"center"];
            //领取成功后移除
            [self.couponBgView removeFromSuperview];
            [SVProgressHUD dismiss];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(NSMutableArray *)selectedSkuArray{
    if (!_selectedSkuArray) {
        _selectedSkuArray = [NSMutableArray array];
    }
    return _selectedSkuArray;
}

-(NSMutableArray *)typeCellArr
{
    if (!_typeCellArr) {
        _typeCellArr = [NSMutableArray array];
    }
    return _typeCellArr;
}

-(NSMutableArray *)productSkuArray
{
    if (!_productSkuArray) {
        _productSkuArray = [NSMutableArray array];
    }
    return _productSkuArray;
}
-(NSMutableArray *)skuMatch
{
    if (!_skuMatch) {
        _skuMatch = [NSMutableArray array];
        
    }
    return _skuMatch;
}
-(NSMutableArray *)noReluArray
{
    if (!_noReluArray) {
        _noReluArray = [NSMutableArray array];
    }
    return _noReluArray;
}

-(NSMutableArray *)couponList{
    if (!_couponList) {
        _couponList = [NSMutableArray array];
    }
    return _couponList;
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear  消失了 这个方法走了吗");
    [SVProgressHUD dismiss];
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
