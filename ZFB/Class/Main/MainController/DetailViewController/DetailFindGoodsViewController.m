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

typedef NS_ENUM(NSUInteger, typeCell) {
    typeCellrowOftitleCell, //0 第一行cell
    typeCellrowOfbabyCell,
    typeCellrowOfGoToStoreCell,
    typeCellrowOflocaCell,
};
@interface DetailFindGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property(nonatomic,strong)UITableView * list_tableView;
@property(nonatomic,strong)UIView * headerView;
@property(nonatomic,strong)UIView * footerView;
@property(nonatomic,strong)UIView * popView;

@property(nonatomic,strong)SDCycleScrollView* cycleScrollView;
@end

@implementation DetailFindGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self circleViewInterface];
    [self creatInterfaceDetailTableView];
    [self settingHeaderViewAndFooterView];
}

-(void)circleViewInterface
{
    self.title = @"轮播Demo";
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
 
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 594/2) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
//    _cycleScrollView.titlesGroup = titles;
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScroll = NO;
    _cycleScrollView.infiniteLoop =NO;

}
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
    
}

-(void)creatInterfaceDetailTableView
{
    self.title = @"商品详情";
    
    self.list_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64-50) style:UITableViewStylePlain];
    self.list_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.list_tableView];
    
    self.list_tableView.delegate = self;
    self.list_tableView.dataSource= self;
    
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFTitleAndChooseListCell" bundle:nil] forCellReuseIdentifier:@"ZFTitleAndChooseListCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFbabyEvaluateCell" bundle:nil] forCellReuseIdentifier:@"ZFbabyEvaluateCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFLoctionNavCell" bundle:nil] forCellReuseIdentifier:@"ZFLoctionNavCell"];
    [self.list_tableView registerNib:[UINib nibWithNibName:@"ZFLocationGoToStoreCell" bundle:nil] forCellReuseIdentifier:@"ZFLocationGoToStoreCell"];
    

}

/**
   设置头尾 视图
 */
-(void)settingHeaderViewAndFooterView
{
    self.list_tableView.tableHeaderView = _cycleScrollView;
    UIView * tempView = [[NSBundle mainBundle]loadNibNamed:@"ZFGoodsFooterView" owner:self options:nil].lastObject;
    
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenH-50, KScreenW, 50)];
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

    
    
}

/**
  点爱心

 @param sender 收藏/取消收藏
 */
-(void )didclickLove:(UIButton *)sender
{
    NSLog(@"love did");
}
/**
  弹框选择规格
 */
-(void)popAcenterView
{
    self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 320)];
    
    self.popView.backgroundColor =[ UIColor whiteColor];
    
    
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
        
        return 100;
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
        
        ZFTitleAndChooseListCell  * ListCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFTitleAndChooseListCell" forIndexPath:indexPath];
        
        return ListCell;
 
    }else if (indexPath.row == typeCellrowOfbabyCell)
    {
        ZFbabyEvaluateCell  *  babyCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFbabyEvaluateCell" forIndexPath:indexPath];
        
        return babyCell;
        
    }else if (indexPath.row == typeCellrowOfGoToStoreCell)
    {
       
        ZFLocationGoToStoreCell  *  goToStoreCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFLocationGoToStoreCell" forIndexPath:indexPath];
        
        return goToStoreCell;
    }
    else if (indexPath.row == typeCellrowOflocaCell)
    {
      
        ZFLoctionNavCell  *  locaCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFLoctionNavCell" forIndexPath:indexPath];
        
        return locaCell;
        
    }   else if (indexPath.row == 4)
    {
        ZFbabyEvaluateCell  *  babyCell = [self.list_tableView dequeueReusableCellWithIdentifier:@"ZFbabyEvaluateCell" forIndexPath:indexPath];
        
        return babyCell;
        
    }
    UITableViewCell  * custopmCell = [self.list_tableView dequeueReusableCellWithIdentifier:custopmCellID];
    if (!custopmCell) {
        custopmCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:custopmCellID];
        custopmCell.backgroundColor = randomColor;
    }
    return custopmCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld,row == %ld",indexPath.section ,indexPath.row);
    
    if (indexPath.row == 1) {
        
        ZFEvaluateViewController * evc = [[ZFEvaluateViewController alloc]init];
        [self.navigationController pushViewController:evc animated:YES];
        
    }
    
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
