//
//  UsedCouponViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//   已使用优惠券


#import "UsedCouponViewController.h"
#import "CouponUsedCell.h"

@interface UsedCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * tabelView;
@property (nonatomic , strong) NSMutableArray * couponArray;

@end

@implementation UsedCouponViewController
-(UITableView *)tabelView
{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 64 - 44) style:UITableViewStylePlain
                      ];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.separatorStyle =  UITableViewCellSelectionStyleNone;
    }
    return _tabelView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tabelView];
    [self.tabelView registerNib:[UINib nibWithNibName:@"CouponUsedCell" bundle:nil] forCellReuseIdentifier:@"CouponUsedCellid"];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 100;
  
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CouponUsedCell * cell = [ self.tabelView dequeueReusableCellWithIdentifier:@"CouponUsedCellid" forIndexPath:indexPath];
    return cell;
 
 
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
