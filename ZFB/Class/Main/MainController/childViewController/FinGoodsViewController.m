//
//  FinGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FinGoodsViewController.h"
#import "FindStoreCell.h"
#import "ZFMainListCell.h"
#import "HotTableViewCell.h"
#import "HotCollectionViewCell.h"

typedef NS_ENUM(NSUInteger, CellType) {
    CellTypeWithFindStoreCell, //cell Type
    CellTypeWithHotTableViewCell,
    CellTypeWithMainListCell
};
@interface FinGoodsViewController ()
<
SDCycleScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate
//UICollectionViewDataSource,
//UICollectionViewDelegate,
//UICollectionViewDelegateFlowLayout
>

@property(strong,nonatomic)UIView * CircleHeadView;
@property(strong,nonatomic)UITableView * findGoods_TableView;
@property(strong,nonatomic)SDCycleScrollView *cycleScrollView ;
@property(strong,nonatomic)UICollectionView *collectView ;


@end

@implementation FinGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self initWithFindGoods_TableView];

    [self CDsyceleSettingRunningPaint];
    
    
    
}
-(void)CreatCollectionViewFlowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    //确定item的大小
    layout.itemSize = CGSizeMake(89, 95);
    
    //确定横向间距
    layout.minimumLineSpacing = 10;
    
    //确定纵向间距
    layout.minimumInteritemSpacing = 10;
    
    //确定距离上左下右的距离
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //头尾部高度
    layout.headerReferenceSize = CGSizeMake(10, 10);
    layout.footerReferenceSize = CGSizeMake(10, 10);
    
    //确定滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //设置集合视图代理
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    
   // [self addSubview:self.collectView];
}


/**
 初始化home_tableView
 */
-(void)initWithFindGoods_TableView
{
    
    self.findGoods_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -48-64-44) style:UITableViewStylePlain];
    self.findGoods_TableView.delegate = self;
    self.findGoods_TableView.dataSource = self;
    [self.view addSubview:_findGoods_TableView];
    
    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"FindStoreCell" bundle:nil] forCellReuseIdentifier:@"FindStoreCell"];
    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"ZFMainListCell" bundle:nil] forCellReuseIdentifier:@"ZFMainListCell"];
    

}

/**
 初始化功能板块
 */
-(void)initFunctionWithInterface
{
    
}

/**
 初始化轮播
 */
-(void)CDsyceleSettingRunningPaint
{
  
    self.title = @"轮播Demo";
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    // 图片配文字
    NSArray *titles = @[@"感谢您的支持，如果下载的",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到gsdios@126.com",
                        @"感谢您的支持"
                        ];
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
   
    //自定义dot 大小和图案
    //_cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    //_cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    //_cycleScrollView.titlesGroup = titles;
    
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
     self.findGoods_TableView.tableHeaderView = _cycleScrollView;

}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
  //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}





#pragma mark - datasoruce  代理实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2 ) {
        return 3;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;

    }
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = nil;
    if (section == 1) {
        headView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, KScreenW, 35)];
        [headView setBackgroundColor:randomColor];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 5.0f, 200.0f, 30.0f)];
        [labelTitle setBackgroundColor:HEXCOLOR(0x363636)];
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.text = @"🔥热卖推荐";
        [headView addSubview:labelTitle];
        
        
        UIImageView * logo = [[UIImageView alloc]init ];//定位icon
        logo.frame =CGRectMake(5, 5, 20, 30);
        logo.backgroundColor = [UIColor redColor];
        [headView addSubview:logo];
        
        return headView;

    }
   else  if (section== 2) {
        headView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, KScreenW, 35)];
        [headView setBackgroundColor:randomColor];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 5.0f, 200.0f, 30.0f)];
        [title setBackgroundColor:HEXCOLOR(0x363636)];
        title.textAlignment = NSTextAlignmentLeft;
        title.text = @"❤️猜你喜欢";
        [headView addSubview:title];
        
        UIImageView * logo2 = [[UIImageView alloc]init ];//定位icon
        logo2.frame =CGRectMake(5, 5, 20, 30);
        logo2.backgroundColor = [UIColor redColor];
        [headView addSubview:logo2];
        return headView;
        
  
    }
    
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        return 145;

    }
    return 276/2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cell_findStoreID = @"FindStoreCell";
    static NSString * cell_listID = @"ZFMainListCell";
    static NSString * cell_hotID = @"HotTableViewCell";
    
    FindStoreCell *storeCell = [self.findGoods_TableView  dequeueReusableCellWithIdentifier:cell_findStoreID];
    ZFMainListCell * listCell = [self.findGoods_TableView dequeueReusableCellWithIdentifier:cell_listID];
    HotTableViewCell * hotCell = [self.findGoods_TableView dequeueReusableCellWithIdentifier:cell_hotID];
    
    
    switch (indexPath.section) {
        case CellTypeWithMainListCell:
            if (!listCell) {
                listCell  =[[ ZFMainListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_listID];
            }
            return listCell;
            break;
        case CellTypeWithHotTableViewCell:
            if (!hotCell) {
                hotCell  =[[ HotTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_hotID];
            }
            return listCell;
            break;
         case CellTypeWithFindStoreCell:
            
            if (!storeCell) {
                
                storeCell= [[FindStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_findStoreID];
                
            }
            
            return storeCell;
        default:
            break;
    }
    
    return storeCell;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
