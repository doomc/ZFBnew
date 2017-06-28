//
//  DetailFindGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  商品详情

#import "DetailFindGoodsViewController.h"
#import "ZFTitleAndChooseListCell.h"
#import "ZFbabyEvaluateCell.h"
#import "ZFLoctionNavCell.h"
#import "ZFLocationGoToStoreCell.h"
#import "ZFGoodsFooterView.h"

#import "ZFEvaluateViewController.h"
#import "ZFSureOrderViewController.h"
#import "DetailGoodsModel.h"

#import "SukItemCollectionViewCell.h"
#import "SkuFooterReusableView.h"
#import "SkuHeaderReusableView.h"

#import "JXMapNavigationView.h"//地图导航

typedef NS_ENUM(NSUInteger, typeCell) {
    
    typeCellrowOftitleCell, //0 第一行cell
    typeCellrowOfbabyCell,
    typeCellrowOfGoToStoreCell,
    typeCellrowOflocaCell,
};
@interface DetailFindGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SkuFooterReusableViewDelegate>
{
    NSString * _goodsName;
    NSString * _sotreName;
    NSString * _contactPhone;
    NSString * _juli;
    NSString * _address;
    NSString * _storeId;
    NSString * _coverImgUrl;
    NSString * _attachImgUrl;
    NSString * _netPurchasePrice;
    NSString * _goodsSales;
    NSString * _inStock;
    NSInteger  _commentNum;

    NSMutableArray *selectIndexPathArr;//保存indexpath的数组
    NSMutableArray * addArr;
    
    NSString * _sizeOrColorStr;//保存sku规格的字符串
    NSInteger _goodsCount;//添加的商品个数
    UILabel * lb_Sku;//弹框上视图的选择的sku
    UILabel * lb_inShock ;//库存
    UILabel * lb_price;//价格
 
}
@property(nonatomic,strong) UITableView * list_tableView;
@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,strong) UIView * footerView;
@property(nonatomic,strong) UIView * popView;
@property(nonatomic,strong) UIView * BgView;//背景view

@property(nonatomic,strong) UIButton * contactService;//客服
@property(nonatomic,strong) UIButton * addShopCar;//加入购物车
@property(nonatomic,strong) UIButton * rightNowGo;//立即购买

@property(nonatomic,strong) SDCycleScrollView* cycleScrollView;
@property(nonatomic,strong) NSMutableArray * reluJsonKeyArray;//列表个数
@property(nonatomic,strong) NSArray * relujsonValueArray ;//色值个数
@property(nonatomic,strong) NSArray * imagesURLStrings;//轮播数组
@property(nonatomic,strong) UICollectionView * SkuColletionView;

@property(nonatomic,strong) SkuFooterReusableView * skufooterView;
@property(nonatomic,strong) NSIndexPath  * indexPath;//记录选择的index

@property (nonatomic, strong)JXMapNavigationView *mapNavigationView;//弹框地图指定到位置


@end

@implementation DetailFindGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _goodsCount = 1; //默认商品数量
    
    selectIndexPathArr = [NSMutableArray arrayWithObjects:@"1",@"1", nil];//用来保存 new 、old的index
    
    [self goodsDetailListPostRequset];//网络请求
    [self creatInterfaceDetailTableView];//初始化控件tableview
    [self settingHeaderViewAndFooterView];//初始化footerview
    self.list_tableView.tableHeaderView = self.cycleScrollView;//加载轮播
    
}

-(SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 594/2) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.infiniteLoop =NO;
    }
    return _cycleScrollView;
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
    
}

-(void)creatInterfaceDetailTableView
{
    self.title = @"商品详情";
    
    self.list_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-49) style:UITableViewStylePlain];
    self.list_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.list_tableView];
    
    self.list_tableView.delegate = self;
    self.list_tableView.dataSource= self;
    
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFTitleAndChooseListCell" bundle:nil] forCellReuseIdentifier:@"ZFTitleAndChooseListCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFbabyEvaluateCell" bundle:nil] forCellReuseIdentifier:@"ZFbabyEvaluateCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFLoctionNavCell" bundle:nil]
              forCellReuseIdentifier:@"ZFLoctionNavCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFLocationGoToStoreCell" bundle:nil] forCellReuseIdentifier:@"ZFLocationGoToStoreCell"];
    
}

/**
 设置头尾 视图
 */
-(void)settingHeaderViewAndFooterView
{
    
    UIView * tempView = [[NSBundle mainBundle]loadNibNamed:@"ZFGoodsFooterView" owner:self options:nil].lastObject;
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenH-49, KScreenW, 49)];
    [self.footerView addSubview: tempView];
    [self.view addSubview:self.footerView];
    
    //自定义导航按钮
    UIButton  * right_btn  =[ UIButton buttonWithType:UIButtonTypeCustom];
    right_btn.frame = CGRectMake(0, 0, 20, 20);
    [right_btn setBackgroundImage:[UIImage imageNamed:@"Love_selected"] forState:UIControlStateNormal];
    [right_btn addTarget:self action:@selector(didclickLove:) forControlEvents:UIControlEventTouchUpInside];
    //自定义button必须执行
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.contactService = [tempView viewWithTag:2001];//客服
    self.addShopCar =   [tempView viewWithTag:2002];//加入购物车
    self.rightNowGo =  [tempView viewWithTag:2003];//立即抢购
    
    [self.rightNowGo addTarget:self action:@selector(rightNowGo:) forControlEvents:UIControlEventTouchUpInside];
    [self.addShopCar addTarget:self action:@selector(addShopCar:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 立即抢购
-(void)rightNowGo:(UIButton *)sender
{
    
    ZFSureOrderViewController * vc =[[ZFSureOrderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 加入购物车
-(void)addShopCar:(UIButton * )sender
{
    
    [self popAcenterView];
}

/**
 点爱心
 
 @param sender 收藏/取消收藏
 */
-(void )didclickLove:(UIButton *)sender
{
    NSLog(@"love did");
}
#pragma mark  -tableView  delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        
        return 96;
    }
    if (indexPath.row == 2) {
        return 54;
    }
    if (indexPath.row == 5) {
        
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
        
        listCell.lb_title.text = _goodsName;
        listCell.lb_price.text = [NSString stringWithFormat:@"¥%@",_netPurchasePrice];
        listCell.lb_sales.text = [NSString stringWithFormat:@"已售%@件",_goodsSales];
        return listCell;
        
    }else if (indexPath.row == typeCellrowOfbabyCell)
    {
        ZFbabyEvaluateCell  *  babyCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFbabyEvaluateCell" forIndexPath:indexPath];
        babyCell.lb_commonCount.text = [NSString stringWithFormat:@"(%ld)",_commentNum];
        return babyCell;
        
    }else if (indexPath.row == typeCellrowOfGoToStoreCell)
    {
        
        ZFLocationGoToStoreCell  *  goToStoreCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFLocationGoToStoreCell" forIndexPath:indexPath];
        CGFloat juli = [_juli floatValue]*0.001;
        goToStoreCell.lb_address.text =  [NSString stringWithFormat:@"%@  %.2fkm",_address,juli];
        goToStoreCell.lb_storeName.text = _sotreName;
        
        
        return goToStoreCell;
    }
    else if (indexPath.row == typeCellrowOflocaCell)
    {
        
        ZFLoctionNavCell  *  locaCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFLoctionNavCell" forIndexPath:indexPath];
        [locaCell.whereTogo addTarget:self action:@selector(whereTogoMap:) forControlEvents:UIControlEventTouchUpInside];
        [locaCell.contactPhone addTarget:self action:@selector(contactPhone:) forControlEvents:UIControlEventTouchUpInside];
        
        return locaCell;
        
    }   else if (indexPath.row == 4)
    {
        ZFbabyEvaluateCell  *  goodsDetailCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFbabyEvaluateCell" forIndexPath:indexPath];
        goodsDetailCell.lb_title.text = @"宝贝详情";
        [goodsDetailCell.lb_commonCount removeFromSuperview];
        [goodsDetailCell.img_arrowRight removeFromSuperview];
        return goodsDetailCell;
        
    }
    UITableViewCell  * custopmCell = [self.list_tableView dequeueReusableCellWithIdentifier:custopmCellID];
    if (!custopmCell) {
        custopmCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:custopmCellID];
        custopmCell.backgroundColor = randomColor;
    }
    return custopmCell;
}

#pragma mark - 到这去 唤醒地图
-(void)whereTogoMap:(UIButton *)sender
{
    //当前位置导航到指定地

    [self.mapNavigationView showMapNavigationViewWithtargetLatitude:22.488260 targetLongitute:113.915049 toName:@"中海油华英加油站"];
    [self.view addSubview:_mapNavigationView];
    
//    //从指定地导航到指定地
//        [self.mapNavigationView showMapNavigationViewFormcurrentLatitude:30.306906 currentLongitute:120.107265 TotargetLatitude:22.488260 targetLongitute:113.915049 toName:@"中海油华英加油站"];
//        [self.view addSubview:_mapNavigationView];
}
#pragma mark - 联系门店 唤醒地图
-(void)contactPhone:(UIButton *)sender
{
    JXTAlertController * alert = [JXTAlertController alertControllerWithTitle:@"确认拨打023-68006800联系门店吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * sure =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        UIWebView *callWebView = [[UIWebView alloc] init];
        NSURL *telURL = [NSURL URLWithString:@"tel:023-68006800"];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebView];

    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld,row == %ld",indexPath.section ,indexPath.row);
    
    if (indexPath.row == 1) {
        
        ZFEvaluateViewController * evc = [[ZFEvaluateViewController alloc]init];
        //        DetailGoodsModel * model = self.goodsListArray[indexPath.row];
        //        evc.goodsId = model.goodsId;
        [self.navigationController pushViewController:evc animated:YES];
        
    }
    
}


#pragma mark - SKUColleView -UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.reluJsonKeyArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Relujson * relujson = self.reluJsonKeyArray[section];
    _relujsonValueArray = [[NSArray alloc]init];
    _relujsonValueArray = [relujson.value  componentsSeparatedByString:@","];
    NSLog(@"_relujsonValueArray  ==== %@",_relujsonValueArray);
    
    return  _relujsonValueArray.count;
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
    
    UICollectionReusableView * reusableView = nil;
    Relujson * relujson = self.reluJsonKeyArray[indexPath.section];
    
    NSLog(@"name = =========%@ =========relujson.value =%@",relujson.name, relujson.value );
    if ( kind  == UICollectionElementKindSectionHeader ) {
        
        SkuHeaderReusableView* headerView = (SkuHeaderReusableView *)[self.SkuColletionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *  lb_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 30)];
        lb_title.font = [UIFont systemFontOfSize:14];
        lb_title.text = relujson.name;
        lb_title.textColor = HEXCOLOR(0x363636);
        [headerView addSubview:lb_title];
        
        reusableView = headerView;
        
    }
    
    return reusableView;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SukItemCollectionViewCell * cell = [self.SkuColletionView dequeueReusableCellWithReuseIdentifier:@"SukItemCollectionViewCellid" forIndexPath:indexPath];
    
    Relujson * relujson = self.reluJsonKeyArray[indexPath.section];
    NSArray * newJson = [relujson.value  componentsSeparatedByString:@","];
    [cell.selectItemColor setTitle:newJson[indexPath.row] forState:UIControlStateNormal] ;
    
    [cell.selectItemColor setBackgroundColor:HEXCOLOR(0xffffff)];
    [cell.selectItemColor setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    cell.selectItemColor.selected = NO;
    
//    cell.itemDelegate = self;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SukItemCollectionViewCell * newCell  = (SukItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    id str =   [selectIndexPathArr objectAtIndex:indexPath.section];//找到当前点击的indexPath
    
    if ([str isKindOfClass:[NSIndexPath class]]) {
        
        NSIndexPath *oldIndexPath = [selectIndexPathArr objectAtIndex:indexPath.section];
        SukItemCollectionViewCell * oldCell = (SukItemCollectionViewCell *)[collectionView cellForItemAtIndexPath: oldIndexPath];
        
        oldCell.selectItemColor.selected = NO;
        [self selectedButton:oldCell.selectItemColor];
        
        newCell.selectItemColor.selected = YES;
        [self selectedButton:newCell.selectItemColor];
        
 
    }else{
        
        newCell.selectItemColor.selected = YES;
        [self selectedButton:newCell.selectItemColor];
        
    }
    
    [selectIndexPathArr replaceObjectAtIndex:indexPath.section withObject:indexPath];
//    
//    NSLog(@"  =========_sizeOrColorStr =======  %@ ", _sizeOrColorStr );
//    NSLog(@" section = %ld  ,row = %ld",indexPath.section,indexPath.item);
    
    //    [self.SkuColletionView reloadData];

}

#pragma mark -  改变选中的状态
-(void)selectedButton:(UIButton *)button{
    
    if (button.selected == YES) {
      
        _sizeOrColorStr = button.titleLabel.text;
        
        NSLog(@" name.value === %@",_sizeOrColorStr);
//        addArr = [NSMutableArray arrayWithObject:_sizeOrColorStr];
//        NSLog(@"addArr =  %@",addArr);
        [button setBackgroundColor:HEXCOLOR(0xfe6d6a)];
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        
    }else{
        [button setBackgroundColor:HEXCOLOR(0xffffff)];
        [button setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
        
    }
}


#pragma mark - deleteRemoveTheBackgroundView 删除操作
-(void)deleteRemoveTheBackgroundView:(UIButton *)sender
{
    NSLog(@"didClick");
    if (self.BgView != nil) {
        
        
        [self.BgView removeFromSuperview];
    }
}


#pragma mark  - 商品详情 网络请求
-(void)goodsDetailListPostRequset{
    
    // [SVProgressHUD show];
    
    NSDictionary * parma = @{
                             
                             @"svcName":@"getGoodsDetailsInfo",
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"goodsId":_goodsId,//商品id
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        //        NSLog(@"  %@  = responseObject  " ,responseObject);
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.reluJsonKeyArray.count >0) {
                
                [self.reluJsonKeyArray  removeAllObjects];
                
            }else{
                
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                
                NSDictionary * statusDict = [NSDictionary dictionary] ;
                //MJEXTENTION
                DetailGoodsModel * goodsModel = [DetailGoodsModel mj_objectWithKeyValues:jsondic];
                
                for (Cmgoodsdetailslist * goodslist in goodsModel.cmGoodsDetailsList) {
                    
                    _goodsName = goodslist.goodsName;
                    _sotreName = goodslist.sotreName;
                    _contactPhone = goodslist.contactPhone;
                    _juli = goodslist.juli;
                    _address = goodslist.address;
                    _storeId = goodslist.sotreId;
                    _coverImgUrl = goodslist.coverImgUrl;
                    _attachImgUrl = goodslist.attachImgUrl;
                    _netPurchasePrice = goodslist.netPurchasePrice;//价格
                    _goodsSales = goodslist.goodsSales;
                    _commentNum = goodslist.commentNum;
                    _inStock = goodslist.productSku.inStock;//库存
                    //    NSLog(@" 店名 = %@ ////////  手机号= %@ ////////  距离 =%@" ,_goodsName,_contactPhone,_juli);
                    statusDict = goodslist.productSku.mj_keyValues;
                }
                
 
//             NSArray * productSkuArr = [NSArray arrayWithObject:statusDict[@"reluJson"]];
                self.reluJsonKeyArray = [Relujson mj_objectArrayWithKeyValuesArray:statusDict[@"reluJson"]];
                
                NSLog(@"---------------reluJsonKeyArray  = %@ --------------- ",self.reluJsonKeyArray);
                
                _imagesURLStrings = [[NSArray alloc]init];
                _imagesURLStrings = [_attachImgUrl componentsSeparatedByString:@","];
                [self.list_tableView reloadData];
                
            }
            
            [SVProgressHUD dismiss];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    }];
    
}


#pragma mark - 添加到购物车:saveShoppingCart
-(void)addToshoppingCarPost
{
//    [SVProgressHUD show];
    NSString * count = [NSString stringWithFormat:@"%ld",_goodsCount];
    _sizeOrColorStr = @"{color:黑色,size:xxl}";
    NSDictionary * parma = @{
                             
                             @"svcName":@"saveShoppingCart",
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"goodsId":_goodsId,
                             @"storeId":_storeId,
                             @"goodsCount":count,//商品个数
                             @"goodsProp":_sizeOrColorStr,//商品规格
                             @"userKeyMd5":BBUserDefault.userKeyMd5,//商品id
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.reluJsonKeyArray.count >0) {
                
                [self.reluJsonKeyArray  removeAllObjects];
                
            }else{
                
                if (self.BgView != nil) {
                    
                    [self.BgView removeFromSuperview];
                }
                
                NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
                
                NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
                NSLog(@" -  - - -- - - -- - -%@ - --- -- - - -- - -",jsondic);
                [self.view makeToast:@"成功添加到购物车" duration:2 position:@"bottom"];

                [self.list_tableView reloadData];
                
            }
            [SVProgressHUD dismiss];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    }];
    
}

#pragma mark  - 选择商品数量
-(void)addCount:(NSInteger)count
{
    NSLog(@"%ld",count);
    _goodsCount = count;
    
}

#pragma mark -  弹框选择规格 popAcenterView ----------
-(void)popAcenterView
{
    self.BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    self.BgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3f];
    [self.view addSubview:self.BgView];
    [self.list_tableView bringSubviewToFront:self.BgView];
    
    self.popView = [[UIView alloc]init];
    self.popView.backgroundColor = [UIColor whiteColor];
    [self.BgView addSubview:self.popView];
    
    //头视图
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(30, -10, 80, 80)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 2;
    [self.popView addSubview:headView];
    
    UIImageView * img = [[UIImageView alloc]init];
    img.clipsToBounds = YES;
    img.image =[UIImage imageNamed:@"11.png"];
    [headView addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    lb_price = [UILabel new];
    lb_price.text = [NSString stringWithFormat:@"¥%@",_netPurchasePrice];
    lb_price.textColor = HEXCOLOR(0xfe6d6a);
    lb_price.font = [UIFont systemFontOfSize:14];
    [self.popView addSubview:lb_price];
    
    //库存
    lb_inShock = [UILabel new];
    lb_inShock.text =_inStock;
    lb_inShock.textColor = HEXCOLOR(0xfe6d6a);
    lb_inShock.font = [UIFont systemFontOfSize:12];
    [self.popView addSubview:lb_inShock];
    
    
    //lb_Sku规格
    lb_Sku = [UILabel new];
    lb_Sku.text = _sizeOrColorStr;
    //    lb_Sku.text = @"已选择 颜色：白色 尺寸：M";
    lb_Sku.textColor = HEXCOLOR(0xfe6d6a);
    lb_Sku.font = [UIFont systemFontOfSize:12];
    [self.popView addSubview:lb_Sku];
    
    UILabel * lb_line = [UILabel new];
    lb_line.backgroundColor = HEXCOLOR(0xfe6d6a);
    [self.popView addSubview:lb_line];
    
    
    UICollectionViewFlowLayout * layout  = [[UICollectionViewFlowLayout alloc]init];
    //    layout.footerReferenceSize = CGSizeMake(KScreenW, 40);
    layout.headerReferenceSize = CGSizeMake(KScreenW, 40);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.SkuColletionView = [[UICollectionView alloc]initWithFrame:CGRectMake(30, 90, KScreenW - 60, 80) collectionViewLayout:layout];;
    self.SkuColletionView.delegate  =self;
    self.SkuColletionView.dataSource = self;
    self.SkuColletionView.backgroundColor = [UIColor whiteColor];
    [self.popView addSubview:self.SkuColletionView];
    
    [self.SkuColletionView registerNib:[UINib nibWithNibName:@"SukItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SukItemCollectionViewCellid"];
    [self.SkuColletionView  registerClass:[SkuHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.SkuColletionView registerNib:[UINib nibWithNibName:@"SkuFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    self.skufooterView = [[NSBundle mainBundle]loadNibNamed:@"SkuFooterReusableView" owner:self options:nil].lastObject;
    self.skufooterView.countDelegate = self;
    [self.popView addSubview:self.skufooterView];
    
 
    //  删除
    UIButton * delete = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.clipsToBounds = YES;
    delete.layer.cornerRadius = 4;
    delete.titleLabel.font = [UIFont systemFontOfSize:14];
    delete.backgroundColor = HEXCOLOR(0xfe6d6a);
    [delete setTitle:@"删除"forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteRemoveTheBackgroundView:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:delete];
    
    //加入购物车
    UIButton * addShopCar = [UIButton buttonWithType:UIButtonTypeCustom];
    addShopCar.clipsToBounds = YES;
    addShopCar.layer.cornerRadius = 4;
    addShopCar.titleLabel.font = [UIFont systemFontOfSize:14];
    addShopCar.backgroundColor = HEXCOLOR(0xfe6d6a);
    [addShopCar setTitle:@"加入购物车"forState:UIControlStateNormal];
    [addShopCar addTarget:self action:@selector(SecondAddShopCar:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:addShopCar];
    
    //立即抢购
    UIButton * buyNow = [UIButton buttonWithType:UIButtonTypeCustom];
    buyNow.clipsToBounds = YES;
    buyNow.layer.cornerRadius = 4;
    buyNow.titleLabel.font = [UIFont systemFontOfSize:14];
    buyNow.backgroundColor = HEXCOLOR(0xfe6d6a);
    [buyNow setTitle:@"立即抢购"forState:UIControlStateNormal];
    [self.popView addSubview:buyNow];
    
    //添加约束
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.BgView);
        make.size.mas_equalTo(CGSizeMake(KScreenW, 190+self.SkuColletionView.collectionViewLayout.collectionViewContentSize.height));//KScreenH/2 + 100
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

-(NSMutableArray *)reluJsonKeyArray
{
    if (!_reluJsonKeyArray) {
        _reluJsonKeyArray = [NSMutableArray array];
    }
    return _reluJsonKeyArray;
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
