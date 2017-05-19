//
//  ZFAllStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFAllStoreViewController.h"
#import "AllStoreCell.h"
#import "SDCycleScrollView.h"
#import "ZFAllStore_sectionView.h"
#import "DetailStoreViewController.h"

@interface ZFAllStoreViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property(nonatomic,strong) UITableView * all_tableview;
@property(nonatomic,strong) UIView * sectionView;


@end

@implementation ZFAllStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self initAll_tableviewInterface];
    [self CDsyceleSettingRunningPaint];
    
}

-(void)initAll_tableviewInterface
{
    self.title =@"全部门店";

    self.all_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.all_tableview];
    
    self.all_tableview.delegate = self;
    self.all_tableview.dataSource= self;
    
    [self.all_tableview registerNib:[UINib nibWithNibName:@"AllStoreCell" bundle:nil] forCellReuseIdentifier:@"AllStoreCell"];
    self.sectionView = [[NSBundle mainBundle]loadNibNamed:@"ZFAllStore_sectionView" owner:self options:nil].lastObject;
    

}
/**初始化轮播 */
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
    SDCycleScrollView *  _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
    
    //自定义dot 大小和图案pageControlCurrentDot
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"dot_selected"];
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.all_tableview.tableHeaderView = _cycleScrollView;
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}


#pragma mark -  tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    AllStoreCell *all_cell = [self.all_tableview dequeueReusableCellWithIdentifier:@"AllStoreCell" forIndexPath:indexPath];
    return all_cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section= %ld ,row =  %ld",indexPath.section ,indexPath.row);
    
    //跳转到门店详情
    DetailStoreViewController * detailStroeVC =[[ DetailStoreViewController alloc]init];
    [self.navigationController pushViewController:detailStroeVC animated:YES];
}
@end
