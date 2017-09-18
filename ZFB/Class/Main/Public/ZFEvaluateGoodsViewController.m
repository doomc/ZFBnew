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
{
    CGFloat _cellHeight;
    NSString * _textViewValues;
    
}
@property (nonatomic,strong) UITableView * tableview;
@property (nonatomic,strong) NSArray     * upImgArray;

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

    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_upImgArray.count > 0) {
            return _cellHeight + 240 + 50 ;
        }
        return 113 + 240 + 50;
    }else{
        return 210 ;
    }
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
    _upImgArray = uploadArr;
    [self.tableview reloadData];
    
    NSLog(@"%@",_upImgArray);
}
//刷新高度
-(void)reloadCellHeight:(CGFloat)cellHeight
{
    _cellHeight = cellHeight;
    
}
//获取textview的内容
-(void)getTextViewValues:(NSString *)textViewValues
{
    NSLog(@" 外部的 %@",textViewValues);
    _textViewValues = textViewValues;
}
#pragma mark - ZFServiceEvaluteCellDelegate
//提交
-(void)didClickCommit
{
    NSLog(@"点击提交了");
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
