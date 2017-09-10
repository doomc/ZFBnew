//
//  ZFEvaluateGoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  新评价晒单（单个商品）


#import "ZFEvaluateGoodsViewController.h"
#import "ZFServiceEvaluteCell.h"
#import "ZFEvaluateGoodsCell.h"

@interface ZFEvaluateGoodsViewController () <UITableViewDelegate,UITableViewDataSource ,ZFEvaluateGoodsCellDelegate,ZFServiceEvaluteCellDelegate>

@property (nonatomic,strong) UITableView * tableview;

@end

@implementation ZFEvaluateGoodsViewController

-(UITableView *)tableview
{
    if (!_tableview ) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    self.title = @"晒单";
    
    [self.view addSubview:self.tableview];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"ZFServiceEvaluteCell" bundle:nil] forCellReuseIdentifier:@"ZFServiceEvaluteCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ZFEvaluateGoodsCell" bundle:nil] forCellReuseIdentifier:@"ZFEvaluateGoodsCell"];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 2;
    }
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 360;
    }

    return  208;
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        ZFEvaluateGoodsCell * goodsCell = [self.tableview dequeueReusableCellWithIdentifier:@"ZFEvaluateGoodsCell" forIndexPath:indexPath];
        goodsCell.delegate = self;
        return goodsCell;
        
    }else{
        
        ZFServiceEvaluteCell * serviceCell = [self.tableview dequeueReusableCellWithIdentifier:@"ZFServiceEvaluteCell" forIndexPath:indexPath];
        
        serviceCell.delegate = self;
        return serviceCell;
        
    
    }
}

#pragma mark - ZFEvaluateGoodsCellDelegate
//传入选择的图片
-(void)uploadImageArray:(NSMutableArray *)uploadArr
{
    
}
//刷新高度
-(void)reloadCellHeight:(CGFloat)cellHeight
{
    
}
#pragma mark - ZFServiceEvaluteCellDelegate

//提交
-(void)didClickCommit
{
    
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
