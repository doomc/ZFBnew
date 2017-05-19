//
//  ZFEvaluateViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  self.title = @"评论";


#import "ZFEvaluateViewController.h"
#import "ZFAppraiseCell.h"

@interface ZFEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView* evaluate_tableView;
@property (nonatomic ,strong) UIView * sectionView;

@end

@implementation ZFEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initWithEvaluate_tableView];
}


/**初始化evaluate_tableView*/
-(void)initWithEvaluate_tableView
{
    self.title = @"评论";

    self.evaluate_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH -64) style:UITableViewStylePlain];

    [self.view addSubview:_evaluate_tableView];
    self.evaluate_tableView.delegate = self;
    self.evaluate_tableView.dataSource = self;
    
    [self.evaluate_tableView registerNib:[UINib nibWithNibName:@"ZFAppraiseCell" bundle:nil] forCellReuseIdentifier:@"ZFAppraiseCell"];
 
    self.sectionView = [[NSBundle mainBundle]loadNibNamed:@"ZFAppraiseSectionView" owner:self options:nil].lastObject;
    
}

#pragma mark - datasoruce  代理实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    
    return self.sectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return  115;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFAppraiseCell *appraiseCell = [self.evaluate_tableView  dequeueReusableCellWithIdentifier:@"ZFAppraiseCell" forIndexPath:indexPath];
    
    return appraiseCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld  ,row =%ld",indexPath.section , indexPath.row);
    
}

@end
