//
//  GoodsDeltailViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//
#define kheadViewHeight  210
#define kcellHeight  50

#import "GoodsDeltailViewController.h"
#import "ZFSureOrderViewController.h"
#import "ZFEvaluateViewController.h"
#import "ZFShoppingCarViewController.h"//购物车
#import "MainStoreViewController.h" //店铺

//网易云信
#import "NTESSessionViewController.h"

//cell
#import "BuyCountCell.h"//购买数量
#import "DetailWebViewCell.h"//webView cell 商品详情
#import "SectionCouponCell.h"//优惠券列表
#import "DetailgoodsSelectCell.h"//选择规格
#import "ZFTitleAndChooseListCell.h"//商品描述和价格
#import "ZFbabyEvaluateCell.h"//商品评论和详情
#import "GoodsDetailEvaCell.h"//评论1
#import "GoodsEvaluateCell.h"//评论2
#import "GoodsParamCell.h"//商品详情

//view
#import "SkuFooterReusableView.h"
#import "SkuHeaderReusableView.h"
#import "SukItemCollectionViewCell.h"//规格cell
#import "CouponTableView.h"
#import "ZFGoodsFooterView.h"//底部

//model
#import "DetailGoodsModel.h"
#import "CouponModel.h"
#import "AppraiseModel.h"

//vender
#import "YJSegmentedControl.h"
#import "WMDragView.h"
#import <WebKit/WebKit.h>

@interface GoodsDeltailViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    YJSegmentedControlDelegate,
    SDCycleScrollViewDelegate,
    BuyCountCellDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    SkuFooterReusableViewDelegate,
    ZFGoodsFooterViewDelegate,
    CouponTableViewDelegate,
    NIMSystemNotificationManagerDelegate,
    NIMUserManagerDelegate,
    GoodsParamCellDelegate
>
{
    SkuMatchModel *_currentSkuMatchModel;  //当前匹配的规格model
    CGFloat  _webViewHeight;//详情的高度
    CGFloat  _skuParamHeight;//规格参数高度
    CGFloat  _bussninessPromissHeight;//商家承诺
    NSString * _commentNum;//评价数
    NSString * _goodsName;
    NSString * _storeName;
    NSInteger  _goodsSales;//销售量
    NSString * _priceRange;//范围价格
    NSString * _inventory;//无规格库存
    NSString * _skuAmount;//有规格的库存
    NSString * _productSkuId;//规格id传到购物车
    NSString * _storeId;
    NSString * _coverImgUrl;
    NSString * _attachImgUrl;
    NSString * _netPurchasePrice;//购买价格
    NSString * _goodsUnit;//单位
    NSString * _contactPhone;// 联系号码
    NSString * _juli;
    NSString * _htmlDivString;//商品详情
    NSString * _htmlSkuParam;//规格参数
    NSString * _htmlPromiss;//商家承诺
    NSString * _store_latitude;
    NSString * _store_longitude;
    NSString * _isReturned;//是否支持退货1支持 2x
    
    NSInteger  _goodsCount;//商品数量
    NSInteger  _isCollect;
    NSString * _accId;//云信id
    NSInteger   _selectSegmentTag;//选择类型
}

//商品参数规格
@property (nonatomic , assign) GoodsParamType goodParamType;
//外层UI
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIButton  * collectButton ;//collectButton收藏按钮
@property (nonatomic , strong) DetailWebViewCell * webCell;
@property (nonatomic , strong) GoodsParamCell  *  paramCell;
@property (nonatomic , strong) YJSegmentedControl *segmentController;
@property (nonatomic , strong) ZFGoodsFooterView * tbFootView;//底部
//sku UI控件
@property (nonatomic , strong) UIView * skuBgView;//规格背景view
@property (nonatomic , strong) UIView * popView;
@property (nonatomic , strong) UICollectionView   * SkuColletionView;
@property (nonatomic , strong) UILabel * lb_Sku;//弹框上视图的选择的sku
@property (nonatomic , strong) UILabel * lb_inShock ;//库存
@property (nonatomic , strong) UILabel * lb_price;//价格
@property (nonatomic , strong) SkuFooterReusableView * skufooterView;
@property (nonatomic , strong) CouponTableView * couponTableView;//优惠券View
@property (nonatomic , strong) UIView * couponBgView;

//数据源
@property (nonatomic , strong) NSMutableArray * couponList;//优惠券数组
@property (nonatomic , strong) NSMutableArray * productSkuArray;//第一次请求是否存在规格的数组
@property (nonatomic , strong) NSMutableArray * selectedSkuArray;//记录选择的值
@property (nonatomic , strong) NSMutableArray <SkuValulist *> *skuValueListArray;//记录规格数组的模型
@property (nonatomic , strong) NSMutableArray * skuMatch;//规格匹配数组
@property (nonatomic , strong) NSMutableArray * noReluArray;//没有规格的立即购买数据
@property (nonatomic , strong) NSMutableArray * appraiseListArray;//评论的数据

@end

@implementation GoodsDeltailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray * titles = @[@"商品",@"详情",@"评价"];
    _goodsCount = 1;//默认商品数量
    _selectSegmentTag = 0;
    _goodParamType = GoodsParamTypeDetailContent;
    
    [self goodsDetailListPostRequset];//详情网络请求
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];

    //导航切换
    self.segmentController =  [YJSegmentedControl segmentedControlFrame:CGRectMake(0, 0, KScreenW/2, 40) titleDataSource:titles backgroundColor:[UIColor clearColor] titleColor:HEXCOLOR(0x333333) titleFont:SYSTEMFONT(14) selectColor:HEXCOLOR(0xf95a70) buttonDownColor:HEXCOLOR(0xf95a70) Delegate:self];
    self.navigationItem.titleView = self.segmentController;
    

    [self initTableview];
    //悬浮按钮
    [self flyButtonView];
    //轮播
    [self cycleScrollViewInitImges:@[]];
    [self settingHeaderViewAndFooterView];//初始化footerview
}


- (void)dealloc
{
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

-(void)initTableview
{
    _tableView      = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -64 - 50) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.delegate   = self;
    _tableView.dataSource = self;
    //nib
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFTitleAndChooseListCell" bundle:nil]
         forCellReuseIdentifier:@"ZFTitleAndChooseListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BuyCountCell" bundle:nil]
         forCellReuseIdentifier:@"BuyCountCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionCouponCell" bundle:nil]
         forCellReuseIdentifier:@"SectionCouponCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailgoodsSelectCell" bundle:nil]
         forCellReuseIdentifier:@"DetailgoodsSelectCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFbabyEvaluateCell" bundle:nil]
         forCellReuseIdentifier:@"ZFbabyEvaluateCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsDetailEvaCell" bundle:nil]
         forCellReuseIdentifier:@"GoodsDetailEvaCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsEvaluateCell" bundle:nil]
         forCellReuseIdentifier:@"GoodsEvaluateCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailWebViewCell" bundle:nil]
         forCellReuseIdentifier:@"DetailWebViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsParamCell" bundle:nil]
         forCellReuseIdentifier:@"GoodsParamCell"];
    
    _webCell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailWebViewCell" ];
    
    [self.view addSubview:self.tableView];
}

-(NSMutableArray *)couponList{
    if (!_couponList) {
        _couponList = [NSMutableArray array];
    }
    return _couponList;
}

-(NSMutableArray *)productSkuArray
{
    if (!_productSkuArray) {
        _productSkuArray = [NSMutableArray array];
    }
    return _productSkuArray;
}
-(NSMutableArray *)selectedSkuArray{
    if (!_selectedSkuArray) {
        _selectedSkuArray = [NSMutableArray array];
    }
    return _selectedSkuArray;
}
#pragma mark - skuMatch 规格匹配
-(NSMutableArray<SkuValulist *> *)skuValueListArray {
    
    if (!_skuValueListArray) {
        _skuValueListArray = [NSMutableArray array];
    }
    return _skuValueListArray;
}
-(NSMutableArray *)noReluArray
{
    if (!_noReluArray) {
        _noReluArray = [NSMutableArray array];
    }
    return _noReluArray;
}
-(NSMutableArray *)appraiseListArray{
    if (!_appraiseListArray) {
        _appraiseListArray = [NSMutableArray array];
    }
    return _appraiseListArray;
}
#pragma mark - 优惠券列表懒加载
-(CouponTableView *)couponTableView
{
    if (!_couponTableView ) {
        _couponTableView = [[CouponTableView alloc]initWithFrame:CGRectMake(0, 200, KScreenW, KScreenH - 200-64)style:UITableViewStylePlain];
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
//添加悬浮按钮
-(void)flyButtonView
{
    WMDragView * flyView = [[WMDragView alloc] initWithFrame:CGRectMake(KScreenW - 50 -15 , self.tableView.height - 40 -64, 40, 40)];
    flyView.layer.cornerRadius = 20;
    flyView.backgroundColor = [UIColor whiteColor];
    [flyView.button setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    flyView.isKeepBounds = YES;
    flyView.dragEnable = NO;
    flyView.clickDragViewBlock = ^(WMDragView *dragView){
        
        NSLog(@"点击了 悬浮");
        [self backTopScrollerView];
    };
    [self.view addSubview:flyView];
    [flyView bringSubviewToFront:self.tableView];
    
}
//回到顶部
-(void)backTopScrollerView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.contentOffset =  CGPointMake(0, 0);
    }];
}
/**
 设置头尾 视图
 */
-(void)settingHeaderViewAndFooterView
{
    if (kDevice_Is_iPhoneX) {
        _tbFootView = [[ZFGoodsFooterView alloc]initWithFootViewFrame:CGRectMake(0, KScreenH - 50 -64 -40, KScreenW, 50)];
        
     }else{
         _tbFootView = [[ZFGoodsFooterView alloc]initWithFootViewFrame:CGRectMake(0, KScreenH - 50 - 64, KScreenW, 50)];
     }

    _tbFootView.delegate = self;
    [self.view addSubview:_tbFootView];
    
    //收藏按钮
    _collectButton  =[ UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake(0, 0, 20, 20);
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateSelected];
    [_collectButton addTarget:self action:@selector(didclickLove:) forControlEvents:UIControlEventTouchUpInside];
    
    //自定义button必须执行
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc] initWithCustomView:_collectButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
#pragma mark - 轮播图
-(void)cycleScrollViewInitImges:(NSArray *)imges
{
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
   SDCycleScrollView * _cycleScrollView   = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, kheadViewHeight) delegate:self placeholderImage:nil];
    _cycleScrollView.imageURLStringsGroup = imges;
    _cycleScrollView.pageControlStyle     = SDCycleScrollViewPageContolStyleNone;
    _cycleScrollView.autoScroll           = NO;
    _cycleScrollView.infiniteLoop         = NO;
    _cycleScrollView.backgroundColor      = [UIColor whiteColor];
    _cycleScrollView.currentPageDotImage  = [UIImage imageNamed:@"dot_normal"];
    _cycleScrollView.pageDotImage         = [UIImage imageNamed:@"dot_selected"];
    _cycleScrollView.currentPageDotColor  = [UIColor whiteColor];// 自定义分页控件小圆标颜色
    self.tableView.tableHeaderView   = _cycleScrollView;//加载轮播
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0://描述
                height = 92;
                break;
            case 1://购买数量
                height = kcellHeight;
                break;
            case 2://优惠券
                if (![self isEmptyArray:self.couponList]) {
                    height = kcellHeight;
                }else{
                    height = 0;
                }
                break;
            case 3://规格
                if (self.productSkuArray != nil && ![self.productSkuArray isKindOfClass:[NSNull class]] && self.productSkuArray.count != 0){
                    height = kcellHeight;
                    
                }else{
                    height = 0;
                    
                }
                break;
            case 4://宝贝评价
                height = 44;
                break;
            case 5://评价1
                height = kcellHeight;
                
                break;
            case 6://评价2
                if (self.appraiseListArray.count >0) {
                    height = 125;
                }else{
                    height = 0;
                }
                break;
        }
    }else{
        switch (_goodParamType) {
            case GoodsParamTypeDetailContent:
                //商品详情
                height = _webViewHeight;
                
                break;
            case GoodsParamTypeSkuParam:
                height = _skuParamHeight;

                break;
            case GoodsParamTypePromiss:
                height = _bussninessPromissHeight;
                break;
        }
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 45;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerview = nil;
    if (section == 0) {
        return headerview;
    }else{
        if (!headerview) {
            headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 45)];
            _paramCell = [self.tableView dequeueReusableCellWithIdentifier:@"GoodsParamCell"];
            _paramCell.frame =  headerview.frame;
            _paramCell.delegate = self;
            [headerview addSubview: _paramCell];
        }
    }
    return headerview;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( indexPath.section == 0) {
        switch (indexPath.row) {
            case 0://描述
            {
                ZFTitleAndChooseListCell  * listCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFTitleAndChooseListCell" forIndexPath:indexPath];
                listCell.lb_title.text               = _goodsName;
                listCell.lb_price.text               = [NSString stringWithFormat:@"¥%@",_priceRange];
                listCell.lb_sales.text               = [NSString stringWithFormat:@"已售%ld件",_goodsSales];
                return listCell;
                
            }
                break;
            case 1://购买数量
            {
                BuyCountCell  * countCell = [self.tableView dequeueReusableCellWithIdentifier:@"BuyCountCell" forIndexPath:indexPath];
                countCell.delegate = self;
                return countCell;
            }
                break;
            case 2://优惠券
            {
                SectionCouponCell * couponCell =  [self.tableView dequeueReusableCellWithIdentifier:@"SectionCouponCell" forIndexPath:indexPath];
                if (![self isEmptyArray:self.couponList]) {
                    couponCell.hidden = NO;

                }else{
                    couponCell.hidden = YES;
                }
                return couponCell;
                
            }
                break;
            case 3://规格
            {
                DetailgoodsSelectCell  *  selectCell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailgoodsSelectCell" forIndexPath:indexPath];
                if (![self isEmptyArray:self.productSkuArray]){
                    
                    selectCell.lb_selectSUK.text = [NSString stringWithFormat:@"选择颜色,尺寸"];
                    selectCell.hidden            = NO;
                }else{
                    selectCell.hidden = YES;
                }
                return selectCell;
            }
                
                break;
            case 4://宝贝评价
            {
                ZFbabyEvaluateCell  *  babyCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFbabyEvaluateCell" forIndexPath:indexPath];
                babyCell.lb_title.text          = @"宝贝评价";
                return babyCell;
            }
                break;
            case 5://评价1
            {
                
                GoodsDetailEvaCell  *  evacell = [self.tableView dequeueReusableCellWithIdentifier:@"GoodsDetailEvaCell" forIndexPath:indexPath];
                evacell.lb_eva.text    = [NSString stringWithFormat:@"评价(%@)",_commentNum];
                return evacell;
            }
                
                break;
                
            case 6://评价2
            {
                GoodsEvaluateCell  *  evacell = [self.tableView dequeueReusableCellWithIdentifier:@"GoodsEvaluateCell" forIndexPath:indexPath];
                if (self.appraiseListArray.count > 0) {
                    Findlistreviews * infoList  = self.appraiseListArray[0];
                    evacell.infoList = infoList;
                }else{
                    [evacell setHidden:YES];
                }
                return evacell;
            }
                break;

        }
    }else{
        //web
        return _webCell;
        
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0://描述
                
                break;
            case 1://购买数量
                
                break;
            case 2://优惠券
                if (![self isEmptyArray:self.couponList]) {
                    
                    [self.view addSubview:self.couponBgView];
                    [self.tableView bringSubviewToFront:self.couponBgView];
                }
                
                break;
            case 3://规格
                if (self.productSkuArray.count > 0) {
                    [self popActionView];
                    
                }
                break;
            case 4://宝贝评价
                break;
            case 5://评价1
            {
                ZFEvaluateViewController * evc = [[ZFEvaluateViewController alloc]init];
                evc.goodsId                    = _goodsId;
                [self.navigationController pushViewController:evc animated:YES];
            }
                break;
            case 6://评价2
            {
                ZFEvaluateViewController * evc = [[ZFEvaluateViewController alloc]init];
                evc.goodsId                    = _goodsId;
                [self.navigationController pushViewController:evc animated:YES];
            }
                break;

                
        }
    } 
   
}
#pragma mark - 商品详情的参数规格
-(void)didClickGoodsType:(GoodsParamType)type
{
    NSLog(@"type === %ld",type);
    _goodParamType = type;

    switch (_goodParamType) {
        case GoodsParamTypeDetailContent:
        {
            //获取到H5的标签
            _webCell.labelhtml.hidden = NO;
            _webCell.htmlImg.hidden = YES;
            [self mas_MutableStringWithHTMLString:_htmlDivString];

        }
            break;
        case GoodsParamTypeSkuParam:
            //规格详情
        {
            _webCell.htmlImg.hidden = NO;
            _webCell.labelhtml.hidden = YES;
//            [_webCell.htmlImg sd_setImageWithURL:[NSURL URLWithString:_htmlSkuParam] placeholderImage:nil];
            [_webCell.htmlImg sd_setImageWithURL:[NSURL URLWithString:_htmlSkuParam] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                CGSize size = image.size;
                CGFloat w = size.width;
                CGFloat H = size.height;
                _skuParamHeight = H;
                NSLog(@"w = %f, h =%f",w,H);
            }];
        }
            break;
        case GoodsParamTypePromiss:
            //商家承诺
        {
            _webCell.htmlImg.hidden = NO;
            _webCell.labelhtml.hidden = YES;
            _webCell.htmlImg.image = [UIImage imageNamed:@"商品承诺750"];
            CGSize size = [UIImage imageNamed:@"商品承诺750"].size;
            _bussninessPromissHeight = size.height/2;

        }
            break;
 
    }
    NSIndexPath *indexPath= [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
 
}

#pragma mark -  弹框选择规格 popActionView ----------
-(void)popActionView
{
    _skuBgView                 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-64)];
    _skuBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3f];
    [self.view addSubview:_skuBgView];
    [self.tableView bringSubviewToFront:_skuBgView];
    
    self.popView                 = [[UIView alloc]init];
    self.popView.backgroundColor = [UIColor whiteColor];
    [_skuBgView addSubview:self.popView];
    
    //头视图
    UIView * headView           = [[UIView alloc]initWithFrame:CGRectMake(20, -20, 110, 110)];
    headView.backgroundColor    = [UIColor whiteColor];
    headView.clipsToBounds      = YES;
    headView.layer.cornerRadius = 2;
    [self.popView addSubview:headView];
    
    //视窗视图
    UIImageView *goodsImgaeView               = [[UIImageView alloc]init];
    goodsImgaeView.clipsToBounds = YES;
    [goodsImgaeView sd_setImageWithURL:[NSURL URLWithString:_headerImage] placeholderImage:[UIImage imageNamed:@"150x140"]];
    [headView addSubview:goodsImgaeView];
    
    
    _lb_price           = [UILabel new];
    _lb_price.text      =  [NSString stringWithFormat:@"¥%@",_priceRange];
    _lb_price.textColor = HEXCOLOR(0xb80c2f);
    _lb_price.font      = [UIFont systemFontOfSize:16];
    [self.popView addSubview:_lb_price];
    
    //库存
    _lb_inShock           = [UILabel new];
    _lb_inShock.text =[NSString stringWithFormat:@"库存%@件",_inventory];
    _lb_inShock.textColor = HEXCOLOR(0x8d8d8d);
    _lb_inShock.font      = [UIFont systemFontOfSize:12];
    [self.popView addSubview:_lb_inShock];
    
    //lb_Sku规格
    _lb_Sku           = [UILabel new];
    _lb_Sku.text      = @"选择规格";
    _lb_Sku.textColor = HEXCOLOR(0x8d8d8d);
    _lb_Sku.font      = [UIFont systemFontOfSize:12];
    [self.popView addSubview:_lb_Sku];
    
    UILabel * lb_line       = [UILabel new];
    lb_line.backgroundColor = HEXCOLOR(0xf95a70);
    [self.popView addSubview:lb_line];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //    layout.footerReferenceSize = CGSizeMake(KScreenW, 1);
    layout.headerReferenceSize          = CGSizeMake(KScreenW, 30);
    layout.scrollDirection              = UICollectionViewScrollDirectionVertical;
    
    
    self.SkuColletionView                 = [[UICollectionView alloc]initWithFrame:CGRectMake(30, 110, KScreenW-60 , 80) collectionViewLayout:layout];
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
    CGFloat collectionViewHeight =  200 ;//self.SkuColletionView.collectionViewLayout.collectionViewContentSize.height ;
    self.SkuColletionView.frame  = CGRectMake(30, 110, KScreenW-60 , collectionViewHeight);//这里的高度要改成固定  以前的高度：collectionViewHeight
    self.SkuColletionView.showsVerticalScrollIndicator =NO;
    self.SkuColletionView.showsHorizontalScrollIndicator =NO;


    self.skufooterView.countDelegate = self;
    self.skufooterView.lb_count.text = [NSString stringWithFormat:@"%ld",_goodsCount];
    [self.popView addSubview:self.skufooterView];
    
    //  删除
    UIButton * delete         = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.clipsToBounds      = YES;
    [delete setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteRemoveTheBackgroundView:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:delete];
    
    //加入购物车
    UIButton * addShopCar         = [UIButton buttonWithType:UIButtonTypeCustom];
    addShopCar.titleLabel.font    = [UIFont systemFontOfSize:15];
    addShopCar.backgroundColor    = HEXCOLOR(0xf8af00);
    [addShopCar setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [addShopCar setTitle:@"加入购物车"forState:UIControlStateNormal];
    [addShopCar addTarget:self action:@selector(SecondAddShopCar:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:addShopCar];
    
    //立即抢购
    UIButton * buyNow         = [UIButton buttonWithType:UIButtonTypeCustom];
    buyNow.titleLabel.font    = [UIFont systemFontOfSize:15];
    buyNow.backgroundColor    = HEXCOLOR(0xf95a70);
    [buyNow setTitle:@"立即抢购"forState:UIControlStateNormal];
    [buyNow setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [buyNow addTarget: self action:@selector(SecondBuyNowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:buyNow];
    
    //添加约束
    [goodsImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    //colletionView
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_skuBgView).with.offset(0);
        make.left.equalTo(_skuBgView).with.offset(0);
        make.right.equalTo(_skuBgView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KScreenW, collectionViewHeight + 120 + 50 + 50 + 20  ));
    }];
    
    //价格
    [_lb_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).with.offset(10);
        make.top.equalTo(self.popView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(170, 15));
    }];
    //库存
    [_lb_inShock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).with.offset(10);
        make.top.equalTo(_lb_price.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 15));
        
    }];
    //规格尺寸
    [_lb_Sku mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).with.offset(10);
        make.top.equalTo(_lb_inShock.mas_bottom).with.offset(10);
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
        make.edges.equalTo(self.popView).with.insets(UIEdgeInsetsMake(120, 30, 100, 30));
    }];
    
    //footerView
    [self.skufooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SkuColletionView.mas_bottom).with.offset(0);
        make.left.equalTo(self.popView).with.offset(10);
        make.right.equalTo(self.popView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(KScreenW , 50));
    }];
    //删除按钮
    [delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.popView).with.offset(10);
        make.right.equalTo(self.popView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        
    }];
    //加入购物车按钮
    [addShopCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.popView).with.offset(0);
        make.bottom.equalTo(self.popView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KScreenW/2.0, 50));
        
    }];
    //抢购按钮
    [buyNow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.popView).with.offset(0);
        make.right.equalTo(self.popView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KScreenW/2.0, 50));
    }];
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

#pragma mark - deleteRemoveTheBackgroundView 删除操作
-(void)deleteRemoveTheBackgroundView:(UIButton *)sender
{
    NSLog(@"关闭弹框");
    if (self.skuBgView != nil) {
        [self.skuBgView removeFromSuperview];
    }
}
#pragma mark -SecondAddShopCar 有规格的 加入购物车
-(void)SecondAddShopCar:(UIButton *)button
{
    if (_shareId.length > 0) {
        JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"共享商品不能加入购物车" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:sure];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        //没有规格商品的库存
        if ([self isSKuAllSelect]) {
            //判断库存
            if ([_skuAmount intValue] > 0) {
                //添加有规格的数据进入购物车  传入有规格的json数据
                [self addToshoppingCarPostproductId:_productSkuId];
                
            }else{
                JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"这个商品已经没有库存了！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertVC addAction:sure];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }else{
            JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"请选择好规格再加入购物车" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:sure];
            [self presentViewController:alertVC animated:NO completion:nil];
        }
    }
}
//立即购买 有规格的
-(void)SecondBuyNowAction:(UIButton *)button
{
    //如果规格全选了
    if ([self isSKuAllSelect]) {
        
        if ([_skuAmount intValue ] > 0) {
            ZFSureOrderViewController * sureVC =[[ZFSureOrderViewController alloc]init];
            
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
            [goodsdic setObject:_isReturned forKey:@"isReturned"];

            [goodslistArray addObject:goodsdic];
            
            [storedic setObject:_storeId forKey:@"storeId"];
            [storedic setObject:_storeName forKey:@"storeName"];
            [storedic setObject:goodslistArray forKey:@"goodsList"];
            [userGoodsInfoJSON addObject:storedic];
            
            NSLog(@"商品详情有规格的数组 userGoodsInfoJSON === %@",userGoodsInfoJSON);
            sureVC.userGoodsInfoJSON = userGoodsInfoJSON ;
            [self.navigationController pushViewController:sureVC animated:YES];
            
        }else{
            JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"这个商品已经没有库存了！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertVC addAction:sure];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }else{
        
        JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"请选择好规格" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:sure];
        [self presentViewController:alertVC animated:NO completion:nil];
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

#pragma mark - 判断是否收藏了
-(void)iscollect
{
    if (_isCollect == 1) {///是否收藏    1.收藏 2.不是
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateNormal];
    }else
    {
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
    }
}

#pragma mark -BuyCountCellDelegate
-(void)addCount:(NSInteger)count
{
    NSLog(@"count ===== %ld",count);
    _goodsCount = count;
}

#pragma mark - ZFGoodsFooterViewDelegate 底部的视图的dedegate
#pragma mark - 跳转到IM聊天
//客服
-(void)didClickContactRobotView
{
    NSLog(@"点击了客服");
    if (BBUserDefault.isLogin == 1) {
        NIMSession *session = [NIMSession session:_accId type:NIMSessionTypeP2P];
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        vc.isVipStore = YES;
        vc.storeId = _storeId;
        vc.storeName = _storeName;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [self isNotLoginWithTabbar:YES];
    }
}
#pragma mark - 店铺
-(void)didClickStoreiew
{
    NSLog(@"进入店铺");
    MainStoreViewController * storeVC = [[MainStoreViewController alloc]init];
    storeVC.storeId                     = _storeId;
    [self.navigationController pushViewController:storeVC animated:NO];
}
#pragma mark - 购物车
-(void)didClickShoppingCariew
{
    ZFShoppingCarViewController * shopVC = [[ZFShoppingCarViewController alloc]init];
    shopVC.shardId = _shareId;
    shopVC.shareNum = _shareNum;
    [self.navigationController pushViewController:shopVC animated:NO];
}
#pragma mark - 加入购物车外部的- 不选择规格
//加入购物车
-(void)didClickAddShoppingCarView
{
    if (BBUserDefault.isLogin == 1) {
        if (_shareId.length > 0) {
            JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"共享商品不能加入购物车" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertVC addAction:sure];
            [self presentViewController:alertVC animated:YES completion:nil];
        }else{
            //  直接加入购物车
            if (self.productSkuArray.count > 0){
                [self popActionView];
            }else{//如果无规格的
                
                if ([_skuAmount intValue] > 0 || [_inventory intValue] > 0 ) {
                    
                    //添加有规格的数据进入购物车  传入有规格的json数据
                    [self addToshoppingCarPostproductId:_productSkuId];
                }else{
                    JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"这个商品已经没有库存了！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alertVC addAction:sure];
                    [self presentViewController:alertVC animated:YES completion:nil];
                }
            }
        }
       
    }else{
        [self isNotLoginWithTabbar:YES];
        
    }
  
}
#pragma mark -  立即购买外部的
-(void)didClickBuyNowView
{
    if (BBUserDefault.isLogin == 1) {
        if (self.productSkuArray.count > 0) {//有规格
            
            [self popActionView];
            
        }else{
            //没有规格 - 直接传值
            if ([_skuAmount intValue] > 0 || [_inventory intValue] > 0 ) {
                
                //当规格为空的时候才组装下列数据
                if ([self isEmptyArray:self.productSkuArray]) {
                    
                    //---------------没有规格的数据------------------
                    NSMutableArray * goodsListArray    = [NSMutableArray array];
                    NSMutableDictionary * goodsListDic = [NSMutableDictionary dictionary];
                    NSMutableDictionary * storeListDic = [NSMutableDictionary dictionary];
                    
                    [goodsListDic setValue:_storeName forKey:@"storeName"];
                    [goodsListDic setValue:_netPurchasePrice forKey:@"originalPrice"];
                    [goodsListDic setValue:@"0" forKey:@"concessionalPrice"];//优惠价
                    [goodsListDic setValue:_coverImgUrl forKey:@"coverImgUrl"];//图片地址
                    [goodsListDic setValue:_netPurchasePrice forKey:@"purchasePrice"];//网购价
                    [goodsListDic setValue:_goodsId forKey:@"goodsId"];
                    [goodsListDic setValue:_storeId forKey:@"storeId"];
                    [goodsListDic setValue:_storeName forKey:@"storeName"];
                    [goodsListDic setObject:@"[]" forKey:@"goodsProp"];
                    [goodsListDic setValue:_productSkuId forKey:@"productId"];//无规格
                    
                    //只有共享进来的才有
                    if (_shareId == nil ) {
                        _shareId = @"";
                    }
                    if (_shareNum == nil) {
                        _shareNum = @"";
                    }
                    [goodsListDic setValue:_shareId forKey:@"shareId"];
                    [goodsListDic setValue:_shareNum forKey:@"shareNum"];
                    [goodsListDic setValue:_isReturned  forKey:@"isReturned"];//1支持退货 2不支持
                    
                    [goodsListDic setValue:_goodsUnit forKey:@"goodsUnit"];
                    [goodsListDic setValue:_goodsName forKey:@"goodsName"];
                    [goodsListDic setValue:[NSString stringWithFormat:@"%ld",_goodsCount] forKey:@"goodsCount"];
                    [goodsListArray addObject:goodsListDic];
                    
                    [storeListDic setValue:goodsListArray forKey:@"goodsList"];
                    [storeListDic setValue:_storeName forKey:@"storeName"];
                    [storeListDic setValue:_storeId forKey:@"storeId"];
                    [self.noReluArray addObject:storeListDic];
                    NSLog(@"noReluArray ==  %@",self.noReluArray);
                    //---------------没有规格的数据------------------
                    ZFSureOrderViewController * vc =[[ZFSureOrderViewController alloc]init];
                    vc.userGoodsInfoJSON = self.noReluArray;//没有规格的数组
                    [self.navigationController pushViewController:vc animated:YES];
                }
                

                
            }else{
                JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"提示 " message:@"该商品已经没有库存了！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction  * sure        = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertVC addAction:sure];
                [self presentViewController:alertVC animated:YES completion:nil];
                
            }
        }
    }else
    {
        [self isNotLoginWithTabbar:YES];
    }
    
}

#pragma mark - <CouponTableViewDelegate> 领取优惠券代理
//关闭弹框
-(void)didClickCloseCouponView
{
    [self.couponTableView  reloadData];
    [self.couponBgView removeFromSuperview];
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
/**
 点爱心
 @param sender 收藏/取消收藏
 */
-(void )didclickLove:(UIButton *)sender
{
    sender.selected = !sender.selected;
    ///是否收藏    1.收藏 2.不是
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
        [self.tableView reloadData];
    });
    
}

#pragma mark - --------------------- 网络请求 ---------------------
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
                             @"collectType" :@"1"    //collectType    string    收藏类型    1商品 2门店    否
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

//匹配规格
-(void)skuMatchPostRequsetWithParam :(NSDictionary *) parma
{
    [SVProgressHUD show];
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
        [SVProgressHUD dismiss];

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
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
            _skuAmount = [NSString stringWithFormat:@"%@",amount];
            NSArray * relujsonArr       = response[@"data"][@"reluJson"];
            
            for (NSDictionary * sukDic in relujsonArr) {
                NSString * value = [sukDic objectForKey:@"value"];
                [chooseArray addObject:value];
            }
            NSString * chooseString = [chooseArray componentsJoinedByString:@" "];
            if (originalPriceStr == nil || _skuAmount == nil ) {
               
                _lb_price.text   = @"价格:0";
                _lb_price.text = @"库存:0";
                _lb_Sku.text     = @"选择规格";
            }else{
                _lb_Sku.text     = [NSString stringWithFormat:@"已选择:%@",chooseString];
                _lb_price.text   = [NSString stringWithFormat:@"价格:¥%@",originalPriceStr];
                _lb_inShock.text = [NSString stringWithFormat:@"库存:%@",_skuAmount];
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
        if (self.skuBgView != nil) {
            [self.skuBgView removeFromSuperview];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        
    }];
}
#pragma mark - 获取用户优惠券列表   recomment/getUserCouponList
-(void)recommentPostRequstCouponList
{
    //idType    number    0 平台 1 商家 2 商品 3 所有    否
    //resultId    number    平台编号/商店编号/商品编号    是
    // userId    number    领优惠券用户编号    否
    // status    number    0 未领取 1 未使用 2 已使用 3 已失效    否
    NSDictionary * parma = @{
                             @"idType":@"3",
                             @"resultId":@"",
                             @"userId":BBUserDefault.cmUserId,
                             @"status":@"0",
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             @"storeId":_storeId,
                             @"goodsId":_goodsId,
                             
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/getUserCouponList"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {
            if (self.couponList.count > 0) {
                [self.couponList removeAllObjects];
            }
            CouponModel * coupon = [CouponModel mj_objectWithKeyValues:response];
            for (Couponlist * list in coupon.couponList) {
                [self.couponList addObject:list];
            }
            [self.couponTableView reloadData];
            [SVProgressHUD dismiss];
        }
        [self.tableView  reloadData];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 点击领取优惠券    recomment/receiveCoupon
-(void)getCouponesPostRequst:(NSString *)couponId
{
    NSDictionary * parma = @{
                             @"userName":BBUserDefault.nickName,
                             @"userPhone":BBUserDefault.userPhoneNumber,
                             @"couponId":couponId,
                             @"userId":BBUserDefault.cmUserId,
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/recomment/receiveCoupon"] params:parma success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"] ) {
            //领取成功后移除
            [self didClickCloseCouponView];
            //在刷新下列表
            [self recommentPostRequstCouponList];
            [SVProgressHUD dismiss];
            [self.view makeToast:@"领取优惠券成功" duration:2 position:@"center"];
        }else
        {
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];

        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
#pragma mark  - 商品详情 网络请求getGoodsDetailsInfo
-(void)goodsDetailListPostRequset{
    
    
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
            _accId    = goodsmodel.data.accId;//云信ID
            
            //goods信息 ----goodsInfo
            _isReturned = goodsmodel.data.goodsInfo.isReturned;;//是否支持退货 1 支持 2不支持
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
            _store_address      = goodsmodel.data.storeInfo.address;//门店地址
            _juli         = goodsmodel.data.storeInfo.storeDist;//门店距离
            _store_latitude       = [NSString stringWithFormat:@"%.6f",[goodsmodel.data.storeInfo.latitude doubleValue]];//经度
            _store_longitude       = [NSString stringWithFormat:@"%.6f",[goodsmodel.data.storeInfo.longitude doubleValue]];//经度
            
            //图片详情网址
            _htmlDivString = goodsmodel.data.goodsInfo.goodsDetail;//商品详情
            _htmlSkuParam = goodsmodel.data.goodsInfo.specificationsUrl;//规格web
//            _htmlPromiss = goodsmodel.data.goodsInfo.goodsPeomise;//商家承诺
            _priceRange  = goodsmodel.data.goodsInfo.priceRange;//范围价格
            _netPurchasePrice = goodsmodel.data.goodsInfo.netPurchasePrice;//价格
            _goodsUnit = goodsmodel.data.goodsInfo.goodsUnit ;

            //添加有规格的数组
            for (Productattribute * product in goodsmodel.data.productAttribute) {
                [self.productSkuArray addObject:product];
            }
            //获取到H5的标签
            [self mas_MutableStringWithHTMLString:_htmlDivString];
            
            //是否收藏    1.收藏 2.不是
            [self iscollect];

            NSArray * imagesArray = [[NSArray alloc]init];
            imagesArray = [_attachImgUrl componentsSeparatedByString:@","];
            [self cycleScrollViewInitImges:imagesArray];
            
            if (BBUserDefault.isLogin == 1) {
                [self recommentPostRequstCouponList];//获取优惠券
                [self getSkimFootprintsSavePostRequst];//获取到商品name后再加入足记

            }
            [self appriaseToPostRequest];//评论列表
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}

#pragma mark - 评论的网络请求 getGoodsCommentInfo
-(void)appriaseToPostRequest
{
    NSDictionary * parma = @{
                             @"goodsId":_goodsId,
                             @"goodsComment":@"",
                             @"imgComment":@"",
                             @"pageSize":@"1",
                             @"pageIndex":@"1",
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsCommentInfo",zfb_baseUrl] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.appraiseListArray.count >0) {
                [self.appraiseListArray  removeAllObjects];
            }
            AppraiseModel * appraise = [AppraiseModel mj_objectWithKeyValues:response];
            for (Findlistreviews * infoList in appraise.data.goodsCommentList.findListReviews) {
                [self.appraiseListArray addObject:infoList];
            }
            [self.tableView reloadData];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
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


//判断选择的版快
-(void)segumentSelectionChange:(NSInteger)selection
{
    NSLog(@"  -----%ld----",selection);
    _selectSegmentTag = selection;

    if (selection == 0) {
   
        NSIndexPath *topRow = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:topRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else if (selection == 1)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }
    else{
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [self settingNavBarBgName:@"nav64_gray"];
}
- (void)viewWillDisappear:(BOOL)animated{
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
