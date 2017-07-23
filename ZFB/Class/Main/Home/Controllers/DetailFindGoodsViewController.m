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
//controlller
#import "ZFEvaluateViewController.h"
#import "ZFSureOrderViewController.h"
//model
#import "DetailGoodsModel.h"
//sku - view
#import "SukItemCollectionViewCell.h"
#import "SkuFooterReusableView.h"
#import "SkuHeaderReusableView.h"

#import "JXMapNavigationView.h"//地图导航

typedef NS_ENUM(NSUInteger, typeCell) {
    
    typeCellrowOftitleCell, //0 第一行cell
    typeCellrowgoodsSelectedCell,
    typeCellrowOfbabyCell,
    typeCellrowOfGoToStoreCell,
    typeCellrowOflocaCell,
};
@interface DetailFindGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SkuFooterReusableViewDelegate>
{
    NSString * _goodsName;
    NSString * _storeName;
    NSString * _contactPhone;
    NSString * _juli;
    NSString * _address;
    NSString * _storeId;
    NSString * _coverImgUrl;
    NSString * _attachImgUrl;
    NSString * _netPurchasePrice;
    NSString * _inStock;
    NSString * _commentNum;
    NSInteger  _isCollect;
    NSInteger  _goodsSales;
    
    NSMutableDictionary *dictProductValue; //保存选择的数据
    NSMutableArray * addArr;
    
    NSString * _sizeOrColorStr;//保存sku规格的字符串
    NSInteger _goodsCount;//添加的商品个数
    UILabel * lb_Sku;//弹框上视图的选择的sku
    UILabel * lb_inShock ;//库存
    UILabel * lb_price;//价格
    UIImageView * goodsImgaeView ;//视窗视图
    UIButton  * collectButton ;//collectButton收藏按钮
}
@property (nonatomic,strong) UITableView * list_tableView;
@property (nonatomic,strong) UIView      * headerView;
@property (nonatomic,strong) UIView      * footerView;
@property (nonatomic,strong) UIView      * popView;
@property (nonatomic,strong) UIView      * BgView;//背景view

@property (nonatomic,strong) UIButton * contactService;//客服
@property (nonatomic,strong) UIButton * addShopCar;//加入购物车
@property (nonatomic,strong) UIButton * rightNowGo;//立即购买

@property (nonatomic,strong) SDCycleScrollView * cycleScrollView;

@property (nonatomic,strong) NSMutableArray * productSkuArray;//sku个数
@property (nonatomic,strong) NSMutableArray * reluJsonKeyArray;//列表个数

@property (nonatomic,strong) NSArray * relujsonValueArray ;//色值个数
@property (nonatomic,strong) NSArray            * imagesURLStrings;//轮播数组
@property (nonatomic,strong) UICollectionView   * SkuColletionView;

@property (nonatomic,strong ) SkuFooterReusableView * skufooterView;
@property (nonatomic,strong ) NSIndexPath           * indexPath;//记录选择的index
@property (nonatomic, strong) JXMapNavigationView   *mapNavigationView;//弹框地图指定到位置


@end

@implementation DetailFindGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _goodsCount = 1;//默认商品数量
    
    dictProductValue = [NSMutableDictionary dictionary];//用来保存 new 、old的index
    
    [self creatInterfaceDetailTableView];//初始化控件tableview
    [self settingHeaderViewAndFooterView];//初始化footerview
    
}

-(void)cycleScrollViewInit
{
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    _cycleScrollView                      = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 594/2) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.imageURLStringsGroup = _imagesURLStrings;
    _cycleScrollView.pageControlStyle     = SDCycleScrollViewPageContolStyleNone;
    _cycleScrollView.delegate             = self;
    _cycleScrollView.autoScroll           = NO;
    _cycleScrollView.infiniteLoop         = NO;
    self.list_tableView.tableHeaderView   = _cycleScrollView;//加载轮播
    
    
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
    
}

-(void)creatInterfaceDetailTableView
{
    self.title = @"商品详情";
    
    self.list_tableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-49) style:UITableViewStylePlain];
    self.list_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.list_tableView];
    
    self.list_tableView.delegate   = self;
    self.list_tableView.dataSource = self;
    
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFTitleAndChooseListCell" bundle:nil] forCellReuseIdentifier:@"ZFTitleAndChooseListCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFbabyEvaluateCell" bundle:nil]
              forCellReuseIdentifier:@"ZFbabyEvaluateCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFLoctionNavCell" bundle:nil]
              forCellReuseIdentifier:@"ZFLoctionNavCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFLocationGoToStoreCell" bundle:nil]
              forCellReuseIdentifier:@"ZFLocationGoToStoreCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"DetailgoodsSelectCell" bundle:nil]
              forCellReuseIdentifier:@"DetailgoodsSelectCell"];
}

/**
 设置头尾 视图
 */
-(void)settingHeaderViewAndFooterView
{
    
    UIView * tempView = [[NSBundle mainBundle]loadNibNamed:@"ZFGoodsFooterView" owner:self options:nil].lastObject;
    self.footerView   = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenH-49, KScreenW, 49)];
    [self.footerView addSubview: tempView];
    [self.view addSubview:self.footerView];
    
    //收藏按钮
    collectButton  =[ UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(0, 0, 20, 20);
    [collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
    [collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(didclickLove:) forControlEvents:UIControlEventTouchUpInside];
    
    //自定义button必须执行
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.contactService = [tempView viewWithTag:2001];//客服
    self.addShopCar     = [tempView viewWithTag:2002];//加入购物车
    self.rightNowGo     = [tempView viewWithTag:2003];//立即抢购
    
    [self.rightNowGo addTarget:self action:@selector(rightNowGo:) forControlEvents:UIControlEventTouchUpInside];
    [self.addShopCar addTarget:self action:@selector(addShopCar:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 立即抢购
-(void)rightNowGo:(UIButton *)sender
{
    
    ZFSureOrderViewController * vc =[[ZFSureOrderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 加入购物车- 选择规格
-(void)addShopCar:(UIButton * )sender
{
    
    [self addToshoppingCarPost];
    //    [self popActionView];
}

/**
 点爱心
 
 @param sender 收藏/取消收藏
 */
-(void )didclickLove:(UIButton *)sender
{
#warning  -- 有问题 取消收藏判断有问题;
    sender.selected = !sender.selected;
    ///是否收藏	1.收藏 2.不是
    if (_isCollect == 1) {
        
        [self cancelCollectedPostRequest];//取消收藏
        
    }else{
        
        [self addCollectedPostRequest]; //添加收藏
        
    }
    
    
}
#pragma mark  -tableView  delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        
        return 56;
    }
    else if (indexPath.row == 1 ) {
        
        //        if (self.productSkuArray.count > 0) {
        //            return 40;
        //        }
        return 40;
    }
    
    else if (indexPath.row == 3) {
        return 54;
    }
    else if (indexPath.row == 6) {
        
        return 200;
    }
    return 44;
}

#pragma mark  - datasurce
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * custopmCellID =@"custopmCellID";
    
    
    if (indexPath.row == typeCellrowOftitleCell) {
        
        ZFTitleAndChooseListCell  * listCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFTitleAndChooseListCell" forIndexPath:indexPath];
        listCell.selectionStyle              = UITableViewCellSelectionStyleNone;
        listCell.lb_title.text               = _goodsName;
        listCell.lb_price.text               = [NSString stringWithFormat:@"¥%@",_netPurchasePrice];
        listCell.lb_sales.text               = [NSString stringWithFormat:@"已售%ld件",_goodsSales];
        return listCell;
        
    }
    else if (indexPath.row == typeCellrowgoodsSelectedCell)
    {
        
        DetailgoodsSelectCell  *  selectCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"DetailgoodsSelectCell" forIndexPath:indexPath];
        
#warning  -  暂时死数据
        selectCell.lb_selectSUK.text = [NSString stringWithFormat:@"已选择 灰色 XL"];
        selectCell.selectionStyle    = UITableViewCellSelectionStyleNone;
        
        return selectCell;
        
    }
    else if (indexPath.row == typeCellrowOfbabyCell)
    {
        ZFbabyEvaluateCell  *  babyCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFbabyEvaluateCell" forIndexPath:indexPath];
        babyCell.lb_commonCount.text    = [NSString stringWithFormat:@"(%@)",_commentNum];
        babyCell.selectionStyle         = UITableViewCellSelectionStyleNone;
        
        return babyCell;
        
    }else if (indexPath.row == typeCellrowOfGoToStoreCell)
    {
        
        ZFLocationGoToStoreCell  *  goToStoreCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFLocationGoToStoreCell" forIndexPath:indexPath];
        goToStoreCell.selectionStyle              = UITableViewCellSelectionStyleNone;
        CGFloat juli                              = [_juli floatValue]*0.001;
        goToStoreCell.lb_address.text             = [NSString stringWithFormat:@"%@  %.2fkm",_address,juli];
        goToStoreCell.lb_storeName.text           = _storeName;
        
        
        return goToStoreCell;
    }
    else if (indexPath.row == typeCellrowOflocaCell)
    {
        ZFLoctionNavCell  *  locaCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFLoctionNavCell" forIndexPath:indexPath];
        locaCell.selectionStyle       = UITableViewCellSelectionStyleNone;
        [locaCell.whereTogo addTarget:self action:@selector(whereTogoMap:) forControlEvents:UIControlEventTouchUpInside];
        [locaCell.contactPhone addTarget:self action:@selector(contactPhone:) forControlEvents:UIControlEventTouchUpInside];
        
        return locaCell;
        
    }
    else if (indexPath.row == 4)
    {
        ZFbabyEvaluateCell  *  goodsDetailCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFbabyEvaluateCell" forIndexPath:indexPath];
        goodsDetailCell.selectionStyle         = UITableViewCellSelectionStyleNone;
        goodsDetailCell.lb_title.text          = @"宝贝详情";
        [goodsDetailCell.lb_commonCount removeFromSuperview];
        [goodsDetailCell.img_arrowRight removeFromSuperview];
        return goodsDetailCell;
        
    }
    UITableViewCell  * custopmCell = [self.list_tableView dequeueReusableCellWithIdentifier:custopmCellID];
    if (!custopmCell) {
        custopmCell                 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:custopmCellID];
        custopmCell.backgroundColor = randomColor;
    }
    return custopmCell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld,row == %ld",indexPath.section ,indexPath.row);
    
    if (indexPath.row == 1) {
        
        [self popActionView];
    }
    if (indexPath.row == 2) {
        
        ZFEvaluateViewController * evc = [[ZFEvaluateViewController alloc]init];
        evc.goodsId                    = _goodsId;
        [self.navigationController pushViewController:evc animated:YES];
        
    }
    
}



#pragma mark - SKUColleView -UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.productSkuArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Productattribute * product = self.productSkuArray[section];
//    NSLog(@"product.reluJson  ==== %@",product.valueList);

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
    SukItemCollectionViewCell * cell = [self.SkuColletionView
                                        dequeueReusableCellWithReuseIdentifier:@"SukItemCollectionViewCellid" forIndexPath:indexPath];
    
    Productattribute * product = self.productSkuArray[indexPath.section];
    Valuelist * value          = product.valueList[indexPath.row];
    cell.valueObj              = value;
    Valuelist * tempValue      = [dictProductValue objectForKey:@(indexPath.section).stringValue];
    cell.isSelecteditems     = value.selectedId == tempValue.nameId;
    
    
    NSLog(@"%d %ld  %ld  ",cell.isSelecteditems ,value.selectedId,tempValue.nameId);
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"----%ld-----",indexPath.item);
  
    Productattribute *product = self.productSkuArray[indexPath.section];
    Valuelist *value          = product.valueList[indexPath.item];
    
    if (value) {
        value.selectedId = value.nameId;
        [dictProductValue setValue:value forKey:@(indexPath.section).stringValue];
        NSLog(@"规格：== %@",dictProductValue);
        _sizeOrColorStr = value.name;
        NSLog(@"规格：== %@",_sizeOrColorStr);
        
    }
    [self.SkuColletionView reloadData];
}


#pragma mark - 到这去 唤醒地图
-(void)whereTogoMap:(UIButton *)sender
{
    //当前位置导航到指定地
    
    [self.mapNavigationView showMapNavigationViewWithtargetLatitude:22.488260 targetLongitute:113.915049 toName:@"中海油华英加油站"];
    [self.view addSubview:_mapNavigationView];
    [self.view bringSubviewToFront:_mapNavigationView];
    
    //    //从指定地导航到指定地
    //        [self.mapNavigationView showMapNavigationViewFormcurrentLatitude:30.306906 currentLongitute:120.107265 TotargetLatitude:22.488260 targetLongitute:113.915049 toName:@"中海油华英加油站"];
    //        [self.view addSubview:_mapNavigationView];
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
    NSLog(@"%ld",count);
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
    goodsImgaeView.image =[UIImage imageNamed:@"11.png"];
    [headView addSubview:goodsImgaeView];
    
    
    
    lb_price           = [UILabel new];
    lb_price.text      = @"123";//[NSString stringWithFormat:@"¥%@",_netPurchasePrice]
    lb_price.textColor = HEXCOLOR(0xfe6d6a);
    lb_price.font      = [UIFont systemFontOfSize:14];
    [self.popView addSubview:lb_price];
    
    //库存
    lb_inShock           = [UILabel new];
    lb_inShock.text =@"20";
    lb_inShock.textColor = HEXCOLOR(0xfe6d6a);
    lb_inShock.font      = [UIFont systemFontOfSize:12];
    [self.popView addSubview:lb_inShock];
    
    
    //lb_Sku规格
    lb_Sku           = [UILabel new];
    //        lb_Sku.text = _sizeOrColorStr;
    lb_Sku.text      = @"已选择 颜色：白色 尺寸：M";
    lb_Sku.textColor = HEXCOLOR(0xfe6d6a);
    lb_Sku.font      = [UIFont systemFontOfSize:12];
    [self.popView addSubview:lb_Sku];
    
    UILabel * lb_line       = [UILabel new];
    lb_line.backgroundColor = HEXCOLOR(0xfe6d6a);
    [self.popView addSubview:lb_line];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //    layout.footerReferenceSize = CGSizeMake(KScreenW, 40);
    layout.headerReferenceSize          = CGSizeMake(KScreenW, 40);
    
    layout.scrollDirection                = UICollectionViewScrollDirectionVertical;
    self.SkuColletionView                 = [[UICollectionView alloc]initWithFrame:CGRectMake(30, 90, KScreenW - 60, 80) collectionViewLayout:layout];;
    self.SkuColletionView.delegate        = self;
    self.SkuColletionView.dataSource      = self;
    self.SkuColletionView.backgroundColor = [UIColor whiteColor];
    [self.popView addSubview:self.SkuColletionView];
    
    [self.SkuColletionView registerNib:[UINib nibWithNibName:@"SukItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SukItemCollectionViewCellid"];
    //注册区头
    [self.SkuColletionView  registerClass:[SkuHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.SkuColletionView registerNib:[UINib nibWithNibName:@"SkuFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    self.skufooterView               = [[NSBundle mainBundle]loadNibNamed:@"SkuFooterReusableView" owner:self options:nil].lastObject;
    self.skufooterView.countDelegate = self;
    [self.popView addSubview:self.skufooterView];
    
    
    //  删除
    UIButton * delete         = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.clipsToBounds      = YES;
    delete.layer.cornerRadius = 4;
    delete.titleLabel.font    = [UIFont systemFontOfSize:14];
    delete.backgroundColor    = HEXCOLOR(0xfe6d6a);
    [delete setTitle:@"删除"forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteRemoveTheBackgroundView:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:delete];
    
    //加入购物车
    UIButton * addShopCar         = [UIButton buttonWithType:UIButtonTypeCustom];
    addShopCar.clipsToBounds      = YES;
    addShopCar.layer.cornerRadius = 4;
    addShopCar.titleLabel.font    = [UIFont systemFontOfSize:14];
    addShopCar.backgroundColor    = HEXCOLOR(0xfe6d6a);
    [addShopCar setTitle:@"加入购物车"forState:UIControlStateNormal];
    [self.popView addSubview:addShopCar];
    
    //立即抢购
    UIButton * buyNow         = [UIButton buttonWithType:UIButtonTypeCustom];
    buyNow.clipsToBounds      = YES;
    buyNow.layer.cornerRadius = 4;
    buyNow.titleLabel.font    = [UIFont systemFontOfSize:14];
    buyNow.backgroundColor    = HEXCOLOR(0xfe6d6a);
    [buyNow setTitle:@"立即抢购"forState:UIControlStateNormal];
    [self.popView addSubview:buyNow];
    
    //添加约束
    [goodsImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    //colletionView
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.BgView);
        make.size.mas_equalTo(CGSizeMake(KScreenW, KScreenH/2 + 100));//KScreenH/2 + 100
        //190+self.SkuColletionView.collectionViewLayout.collectionViewContentSize.height
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
        make.size.mas_equalTo(CGSizeMake(40, 40));
        
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

#pragma mark -SecondAddShopCar 加入购物车
-(void)SecondAddShopCar:(UIButton *)button
{
    
    [self addToshoppingCarPost];
    NSLog(@"加入购物车 。请求接口");
}




#pragma mark  - 商品详情 网络请求getGoodsDetailsInfo
-(void)goodsDetailListPostRequset{
    
    NSLog(@" 经度 %@ ----- 纬度 %@",BBUserDefault.latitude,BBUserDefault.longitude);
    NSDictionary * parma = @{
                             
                             @"latitude":BBUserDefault.latitude,
                             @"longitude":BBUserDefault.longitude,
                             @"goodsId":_goodsId,//商品id
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsDetailsInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            DetailGoodsModel * detailModel = [DetailGoodsModel mj_objectWithKeyValues:response];
            
            //goods信息 ----goodsInfo
            _goodsName        = detailModel.data.goodsInfo.goodsName;//商品名
            _coverImgUrl      = detailModel.data.goodsInfo.coverImgUrl;//商品封面
            _attachImgUrl     = detailModel.data.goodsInfo.attachImgUrl;//图片链接
            _netPurchasePrice = detailModel.data.goodsInfo.netPurchasePrice;//价格
            _goodsSales       = detailModel.data.goodsInfo.goodsSales;//已经销售
            _commentNum       = detailModel.data.goodsInfo.commentNum;//评论数
            _isCollect        = detailModel.data.goodsInfo.isCollect;//是否收藏
            _storeId          = [NSString stringWithFormat:@"%ld",detailModel.data.goodsInfo.storeId];//店铺id
            
            //store信息 ----storeInfo
            _storeName    = detailModel.data.storeInfo.storeName;//店名
            _contactPhone = detailModel.data.storeInfo.contactPhone;//联系手机号
            _address      = detailModel.data.storeInfo.address;//门店地址
            _juli         = detailModel.data.storeInfo.storeDist;//门店距离
            
            
            if (_isCollect == 1) {///是否收藏	1.收藏 2.不是
                
                [collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateNormal];
                
            }else
            {
                [collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
            }
            
           
            for (Productattribute * product in detailModel.data.productAttribute) {
                
                [self.productSkuArray addObject:product];
                
            }
            
            _imagesURLStrings = [[NSArray alloc]init];
            _imagesURLStrings = [_attachImgUrl componentsSeparatedByString:@","];
            NSLog(@"%@\n",self.productSkuArray);
            NSLog(@"%@",  _imagesURLStrings);
            
            [self cycleScrollViewInit];
            
            [self getSkimFootprintsSavePostRequst];//获取到商品name后再加入足记
            
        }
        [self.list_tableView reloadData];
        
        
    } progress:^(NSProgress *progeress) {
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(void)deathdata
{
    //复杂的字典[模型中有个数组属性，数组里面又要装着其他模型的字典]
    NSDictionary *dict_m8m = @{
                               @"data" : @{
                                       @"goodsInfo":@{
                                               
                                               },
                                       @"productAttribute" : @[
                                               @{
                                                   @"valueList" : @[
                                                           @{
                                                               @"nameId" : @"1",
                                                               @"valueId" : @"1",
                                                               @"nameStatus" : @"0",
                                                               @"goodsTypeId" : @"8",
                                                               @"orderNum" : @"1",
                                                               @"name" : @"红色",
                                                               },
                                                           @{
                                                               @"nameId" : @"2",
                                                               @"valueId" : @"1",
                                                               @"nameStatus" : @"0",
                                                               @"goodsTypeId" : @"8",
                                                               @"orderNum" : @"1",
                                                               @"name" : @"黑色",
                                                               },
                                                           @{
                                                               @"nameId" : @"3",
                                                               @"valueId" : @"1",
                                                               @"nameStatus" : @"0",
                                                               @"goodsTypeId" : @"8",
                                                               @"orderNum" : @"1",
                                                               @"name" : @"黄色",
                                                               },
                                                           ],
                                                   
                                                   @"nameId" : @"1",
                                                   @"nameStatus" : @"0",
                                                   @"goodsTypeId" : @"8",
                                                   @"orderNum" : @"1",
                                                   @"name" : @"颜色",
                                                   
                                                   },
                                               @{
                                                   @"valueList" : @[
                                                           @{
                                                               @"nameId" : @"4",
                                                               @"valueId" : @"1",
                                                               @"nameStatus" : @"0",
                                                               @"goodsTypeId" : @"8",
                                                               @"orderNum" : @"1",
                                                               @"name" : @"ll",
                                                               },
                                                           @{
                                                               @"nameId" : @"2",
                                                               @"valueId" : @"1",
                                                               @"nameStatus" : @"0",
                                                               @"goodsTypeId" : @"8",
                                                               @"orderNum" : @"1",
                                                               @"name" : @",ml",
                                                               },
                                                           @{
                                                               @"nameId" : @"3",
                                                               @"valueId" : @"1",
                                                               @"nameStatus" : @"0",
                                                               @"goodsTypeId" : @"8",
                                                               @"orderNum" : @"1",
                                                               @"name" : @"xl",
                                                               },
                                                           ],
                                                   
                                                   @"nameId" : @"1",
                                                   @"nameStatus" : @"0",
                                                   @"goodsTypeId" : @"8",
                                                   @"orderNum" : @"1",
                                                   @"name" : @"尺码",
                                                   
                                                   
                                                   }
                                               ]      

                                       }
                        };
    
    DetailGoodsModel * detailModel = [DetailGoodsModel mj_objectWithKeyValues:dict_m8m];
    
    
    for (Productattribute * product in detailModel.data.productAttribute) {
        
        [self.productSkuArray addObject:product];
        
    }
    [self.SkuColletionView reloadData];
 
}

#pragma mark - 添加收藏 getKeepGoodInfo
-(void)addCollectedPostRequest
{
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"goodId":_goodsId,
                             @"goodName":_goodsName,//商品名
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getKeepGoodInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
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
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/cancalGoodsCollect",zfb_baseUrl] params:parma success:^(id response) {
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
        _isCollect = 0;
        
        [self iscollect];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}
//判断是否收藏了
-(void)iscollect
{
    if (_isCollect == 1) {///是否收藏	1.收藏 2.不是
        
        [collectButton setBackgroundImage:[UIImage imageNamed:@"Collected"] forState:UIControlStateNormal];
        
    }else
    {
        [collectButton setBackgroundImage:[UIImage imageNamed:@"unCollected"] forState:UIControlStateNormal];
    }
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
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


#pragma mark - 添加到购物车:ShoppCartJoin
-(void)addToshoppingCarPost
{
    
    NSString * count     = [NSString stringWithFormat:@"%ld",_goodsCount];
    _sizeOrColorStr      = @"{color:黑色,size:xxl}";
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"storeId":_storeId,
                             @"storeName":_storeName,
                             @"goodsId":_goodsId,
                             @"goodsCount":count,//商品个数
                             @"goodsProp":@"",//商品规格
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/ShoppCartJoin",zfb_baseUrl] params:parma success:^(id response) {
        
        [self.view makeToast:@"加入购物车成功！" duration:2 position:@"center"];
        
        //                [self.list_tableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        
    }];
    
    
}

-(NSMutableArray *)reluJsonKeyArray
{
    if (!_reluJsonKeyArray) {
        _reluJsonKeyArray = [NSMutableArray array];
    }
    return _reluJsonKeyArray;
}

-(NSMutableArray *)productSkuArray
{
    if (!_productSkuArray) {
        _productSkuArray = [NSMutableArray array];
    }
    return _productSkuArray;
}


-(void)viewWillAppear:(BOOL)animated
{
 
   
//    [self goodsDetailListPostRequset];//网络请求
    
    
    [self deathdata];
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
