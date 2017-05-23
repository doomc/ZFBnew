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

#import "DetailStoreViewController.h"

@interface ZFAllStoreViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property(nonatomic,strong) UITableView * all_tableview;
@property(nonatomic,strong) UIView * sectionView;

@property(nonatomic,strong) UIButton * farway_btn;
@property(nonatomic,strong) UIButton * all_btn;

@property (nonatomic,weak)UIButton *selectedBtn;
@end

@implementation ZFAllStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.farway_btn.selected = YES;
    self.selectedBtn = _farway_btn;
    
    [self initAll_tableviewInterface];
    [self CDsyceleSettingRunningPaint];
    [self creatButtonWithDouble];
}

-(void)initAll_tableviewInterface
{
    
    self.title =@"全部门店";
    self.all_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.all_tableview];
    self.all_tableview.delegate = self;
    self.all_tableview.dataSource= self;
    
    [self.all_tableview registerNib:[UINib nibWithNibName:@"AllStoreCell" bundle:nil] forCellReuseIdentifier:@"AllStoreCell"];
    
    
    
    
}
/**初始化轮播 */
-(void)CDsyceleSettingRunningPaint
{
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
    return self.sectionView;
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

-(void)creatButtonWithDouble
{
    self.sectionView =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
    
    self.farway_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.farway_btn.frame =CGRectMake( 0, 0, KScreenW*0.5, 40);
    [self.farway_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [self.farway_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
    [self.farway_btn setTitle:@"距离最近" forState:UIControlStateNormal];
    
    self.farway_btn.backgroundColor = HEXCOLOR(0xffcccc);
    [ self.farway_btn setImage:[UIImage imageNamed:@"arrows_down_white"] forState:UIControlStateNormal];
    self.farway_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ self.farway_btn addTarget:self action:@selector(buttonBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.sectionView  addSubview: _farway_btn];
    
    
    _all_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _all_btn.frame =CGRectMake(KScreenW *0.5 , 0, KScreenW*0.5, 40);
    _all_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_all_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_all_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 120, 0, 0)];
    [_all_btn setTitle:@"全部" forState:UIControlStateNormal];
    [_all_btn addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _all_btn.backgroundColor = [UIColor whiteColor];
    
    [_all_btn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    [_all_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
    [self.sectionView  addSubview:_all_btn];
    
    
    
}

-(void)buttonBtnClick2:(UIButton *)button
{
    self.selectedBtn.selected = YES;
    [self.farway_btn setImage:[UIImage imageNamed:@"arrows_down_white"] forState:UIControlStateNormal];
    [self.farway_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.farway_btn.backgroundColor = HEXCOLOR(0xffcccc);
    
    [self.all_btn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    [self.all_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
    self.all_btn.backgroundColor =  [UIColor whiteColor];
    
    
}
-(void)buttonBtnClick:(UIButton *)button
{
    
    self.selectedBtn.selected = NO;
    [self.farway_btn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
    [self.farway_btn setImage:[UIImage imageNamed:@"arrows_down_black"] forState:UIControlStateNormal];
    self.farway_btn.backgroundColor =[UIColor whiteColor];
    
    
    [self.all_btn setImage:[UIImage imageNamed:@"arrows_down_white"] forState:UIControlStateNormal];
    [self.all_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.all_btn.backgroundColor =  HEXCOLOR(0xffcccc);
    
    
    
    
    
}

@end
