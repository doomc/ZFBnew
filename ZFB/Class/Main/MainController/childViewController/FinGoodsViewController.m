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
#import "GuessCell.h"
#import "DetailFindGoodsViewController.h"
typedef NS_ENUM(NSUInteger, CellType) {
    
    CellTypeWithMainListCell,//功能cell 0
    CellTypeWithHotTableViewCell,
    CellTypeWithGuessCell,
    
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

/**
 初始化home_tableView
 */
-(void)initWithFindGoods_TableView
{
    
    self.findGoods_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -48-64-44) style:UITableViewStylePlain];
    self.findGoods_TableView.delegate = self;
    self.findGoods_TableView.dataSource = self;
    [self.view addSubview:_findGoods_TableView];
    
    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"GuessCell" bundle:nil] forCellReuseIdentifier:@"GuessCell"];
    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"ZFMainListCell" bundle:nil] forCellReuseIdentifier:@"ZFMainListCell"];
    [self.findGoods_TableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil] forCellReuseIdentifier:@"HotTableViewCell"];
    
    
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

    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
    
    //自定义dot 大小和图案pageControlCurrentDot
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"dot_selected"];
//    _cycleScrollView.titlesGroup = titles;
    
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
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 3, 200.0f, 30.0f)];
        labelTitle.textColor =HEXCOLOR(0x363636);
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.text = @"热卖推荐";
        [headView addSubview:labelTitle];
        
        
        UIImageView * logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fire"] ];//定位icon
        logo.frame =CGRectMake(5, 5, 25, 25);
        [headView addSubview:logo];
        
        return headView;
        
    }
    else  if (section== 2) {
        headView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, KScreenW, 35)];
        [headView setBackgroundColor:randomColor];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 3.0f, 200.0f, 30.0f)];
        title.textColor =HEXCOLOR(0x363636);
        title.textAlignment = NSTextAlignmentLeft;
        title.text = @"猜你喜欢";
        [headView addSubview:title];
        
        UIImageView * logo2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"love"] ];//定位icon
        logo2.frame =CGRectMake(5, 6, 25, 25);
        [headView addSubview:logo2];
        return headView;
        
        
    }
    
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        return 165;
    }
        if (indexPath.section == 1 ) {
            return 125;
        }
    return  138;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cell_guessID = @"GuessCell";
    static NSString * cell_listID = @"ZFMainListCell";
    static NSString * cell_hotID = @"HotTableViewCell";
    
    if (indexPath.section == CellTypeWithMainListCell ) {
        
        ZFMainListCell * listCell = [self.findGoods_TableView dequeueReusableCellWithIdentifier:cell_listID forIndexPath:indexPath];
        
        return listCell;
        
    }else if(indexPath.section == CellTypeWithHotTableViewCell )
    {
        
        HotTableViewCell * hotCell = [self.findGoods_TableView dequeueReusableCellWithIdentifier:cell_hotID forIndexPath:indexPath];
      
        //刷新cell
       // [hotCell.HcollectionView reloadData];
    
        
        return hotCell;
    }else{
        
        GuessCell *guessCell = [self.findGoods_TableView  dequeueReusableCellWithIdentifier:cell_guessID forIndexPath:indexPath];
        
        
        return guessCell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld  ,row =%ld",indexPath.section , indexPath.row);

    DetailFindGoodsViewController * findVCgoods =[[DetailFindGoodsViewController alloc]init];
    [self.navigationController pushViewController:findVCgoods animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
