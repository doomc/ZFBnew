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

@interface DetailStoreViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)SDCycleScrollView * sd_HeadScrollView;
@property(nonatomic,strong)UICollectionReusableView * tempView;
@property(nonatomic,strong)UICollectionView * main_ColletionView;

@end

@implementation DetailStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor =randomColor;
    
    
    [self CreatCollctionViewInterface];
    [self CDsyceleSettingRunningPaint];
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(pushNext)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
 
}
-(void)pushNext
{
    
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
    //_cycleScrollView.titlesGroup = titles;
    
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

    UICollectionViewFlowLayout * layout  = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    layout.minimumInteritemSpacing = 30;
//    layout.minimumLineSpacing = 20;
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
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
     ZFDetailStoreCell  *cell = (ZFDetailStoreCell *)[_main_ColletionView dequeueReusableCellWithReuseIdentifier:@"ZFDetailStoreCellid" forIndexPath:indexPath];
//    
//    cell.botlabel.text = [NSString stringWithFormat:@"{%ld,%ld}",(long)indexPath.section,(long)indexPath.row];
//    
//    cell.backgroundColor = [UIColor yellowColor];、
//    cell.backgroundColor =[ UIColor redColor];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (KScreenW -50-20-20)*0.5 , 150);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15,  20 , 10, 20);
    
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    CGFloat  _headViewHeignt = 155.f;
    if (kind == UICollectionElementKindSectionHeader){
        
        _tempView  = [_main_ColletionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];        
        //轮播
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, _headViewHeignt)];
//        _sd_HeadScrollView = [[SDCycleScrollView alloc]initWithFrame:headView.bounds];
        headView = _sd_HeadScrollView;
        
        [_tempView addSubview:headView];
        
    

        //设置title
        UIView * titleView =[[ UIView alloc]initWithFrame:CGRectMake(0, _headViewHeignt, KScreenW, 40)];
        [_tempView addSubview:titleView];

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
        UIView * locationView= [[ UIView alloc]initWithFrame:CGRectMake(0, 40+_headViewHeignt, KScreenW, 40)];
        [_tempView addSubview:locationView];

        //定位logo
        UIImageView * icon_location = [[ UIImageView alloc]initWithFrame:CGRectMake(10, 5, 25, 25)];
        icon_location.image =[ UIImage imageNamed:@"location_icon2"];
        [locationView addSubview:icon_location];
        
        //电话logo
        UIImageView * icon_phone = [[ UIImageView alloc]initWithFrame:CGRectMake(KScreenW-15-20, 5, 20, 25)];
        icon_phone.image =[ UIImage imageNamed:@"calling_icon"];
        [locationView addSubview:icon_phone];

        UILabel * locatext = [[UILabel alloc]initWithFrame:CGRectMake( 35, 0, KScreenW -100, 39)];
        locatext.text = @"渝北区新牌坊清风南路-龙湖-水晶郦城西门-组团";
        locatext.textAlignment = NSTextAlignmentLeft;
        locatext.font =[ UIFont systemFontOfSize:12.0];
        locatext.textColor = HEXCOLOR(0x363636);
       
        
        [locationView addSubview:locatext];
        
        //全部商品section
        UIView *sectionView =[[ UIView alloc]initWithFrame:CGRectMake(0, 80+_headViewHeignt, KScreenW, 40)];
        [_tempView addSubview:sectionView];
        
        UIImageView * icon_sec = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 25, 25)];
        icon_sec.image =[ UIImage imageNamed:@"more_icon"];
        [sectionView addSubview:icon_sec];
        
        UILabel * sectionTitle= [[ UILabel alloc]initWithFrame:CGRectMake(10+20+15, 0, 100, 40)];
        sectionTitle.text =@"全部商品";
        sectionTitle.font =[UIFont systemFontOfSize:13];
        sectionTitle.textAlignment = NSTextAlignmentLeft;
        sectionTitle.textColor = HEXCOLOR(0x363636);
        [sectionView addSubview:sectionTitle];
       
         reusableview = _tempView;
        
    }
 
    return reusableview;

 
}
//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
     return CGSizeMake(KScreenW , 275);
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
