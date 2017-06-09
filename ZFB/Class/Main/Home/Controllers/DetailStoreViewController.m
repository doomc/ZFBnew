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

@interface DetailStoreViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)SDCycleScrollView * sd_HeadScrollView;
@property(nonatomic,strong)UICollectionView * main_ColletionView;
@property(nonatomic,strong)UIView * sectionView;


@end

@implementation DetailStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor =randomColor;
    
    
    [self CreatCollctionViewInterface];
    [self CDsyceleSettingRunningPaint];
    [self creatHeadViewinterface];
   

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
-(void)CDsyceleSettingRunningPaint
{
    
    
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    \
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    _sd_HeadScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 310*0.5) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _sd_HeadScrollView.imageURLStringsGroup = imagesURLStrings;
    _sd_HeadScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
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
    [_main_ColletionView registerClass:[ZFDetailStoreCell class] forCellWithReuseIdentifier:@"ZFDetailStoreCellid"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [_main_ColletionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
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
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
     ZFDetailStoreCell  *cell = (ZFDetailStoreCell *)[_main_ColletionView dequeueReusableCellWithReuseIdentifier:@"ZFDetailStoreCellid" forIndexPath:indexPath];
 
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (KScreenW -30-20-20)*0.5 , 150);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(15,  20 , 10, 20);
    
}


-(void)creatHeadViewinterface
{
    CGFloat  ViewHeignt = 0;
    self.sectionView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    //设置title
    UIView * titleView =[[ UIView alloc]initWithFrame:CGRectMake(0, ViewHeignt, KScreenW, 40)];
    [_sectionView addSubview:titleView];
    
    UILabel * titleText_lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW*0.5, 39)];
    titleText_lb.text = @"KOTTE化妆品专卖店";
    titleText_lb.textColor = HEXCOLOR(0xfe6d6a);
    titleText_lb.font =[UIFont systemFontOfSize:12];
    titleView.backgroundColor = [UIColor yellowColor];
    [titleView addSubview:titleText_lb];
    
    //到店付
    UIButton * gotoStore_btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [gotoStore_btn addTarget:self action:@selector(didClickgotoStore_btn:) forControlEvents:UIControlEventTouchUpInside];
    gotoStore_btn.frame  = CGRectMake(KScreenW -100-15, 16, 100, 20);
    [gotoStore_btn setTitle:@"到店付" forState:UIControlStateNormal];
    gotoStore_btn.backgroundColor = HEXCOLOR(0xffffff);
    [titleView addSubview:gotoStore_btn];
    
    //下划线
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, KScreenW, 1)];
    line.backgroundColor = HEXCOLOR(0xdedede);
    [titleView addSubview:line];
    
    //位置定位
    UIView * locationView= [[ UIView alloc]initWithFrame:CGRectMake(0, 40+ViewHeignt, KScreenW, 40)];
    [_sectionView addSubview:locationView];
    
    //定位logo
    UIImageView * icon_location = [[ UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    icon_location.image =[ UIImage imageNamed:@"location_icon2"];
    [locationView addSubview:icon_location];
    
    //电话logo
    UIImageView * icon_phone = [[ UIImageView alloc]initWithFrame:CGRectMake(KScreenW-15-20, 5, 30, 30)];
    icon_phone.image =[ UIImage imageNamed:@"calling_icon"];
    [locationView addSubview:icon_phone];
    
    UILabel * locatext = [[UILabel alloc]initWithFrame:CGRectMake( 40, 0, KScreenW -80, 39)];
    locatext.text = @"渝北区新牌坊清风南路-龙湖-水晶郦城西门-组团";
    locatext.textAlignment = NSTextAlignmentLeft;
    locatext.font =[ UIFont systemFontOfSize:12.0];
    locatext.textColor = HEXCOLOR(0x363636);
    
    
    [locationView addSubview:locatext];
    
    //全部商品section
    UIView *sectionView =[[ UIView alloc]initWithFrame:CGRectMake(0, 80+ViewHeignt, KScreenW, 40)];
    sectionView.backgroundColor = HEXCOLOR(0xffcccc);
    [_sectionView addSubview:sectionView];
    
    UIImageView * icon_sec = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    icon_sec.image =[ UIImage imageNamed:@"more_icon"];
    [sectionView addSubview:icon_sec];
    
    UILabel * sectionTitle= [[ UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 40)];
    sectionTitle.text =@"全部商品";
    sectionTitle.font =[UIFont systemFontOfSize:13];
    sectionTitle.textAlignment = NSTextAlignmentLeft;
    sectionTitle.textColor = HEXCOLOR(0x363636);
    [sectionView addSubview:sectionTitle];

}

//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    CGFloat  _headViewHeignt = 155.f;
    if (indexPath.section == 0) {
        
        if (kind == UICollectionElementKindSectionHeader){
            UICollectionReusableView * _reusableView  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            
            //轮播
             UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, _headViewHeignt)];
            headView = _sd_HeadScrollView;
            [_reusableView addSubview: headView];
            reusableview = _reusableView;
            
            
        }
    }
    if (indexPath.section == 1) {
        
        if (kind == UICollectionElementKindSectionHeader){
            UICollectionReusableView * _reusableView  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            
            //轮播
            [_reusableView addSubview:_sectionView];
            reusableview = _reusableView;
            
            
        }
    }

    
    return reusableview;

}


//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(KScreenW , 155);
   
    }
    return CGSizeMake(KScreenW ,120);

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
   // DetailStoreCell *cell = (DetailStoreCell *)[collectionView cellForItemAtIndexPath:indexPath];
   
    NSLog(@"%ld",indexPath.item);
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