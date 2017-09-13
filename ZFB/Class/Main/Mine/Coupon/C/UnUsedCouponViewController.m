//
//  UnUsedCouponViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  未使用优惠券

#import "UnUsedCouponViewController.h"
#import "CouponCell.h"
#import "SectionCouponCell.h"
@interface UnUsedCouponViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * tabelView;
@property (nonatomic , strong) NSMutableArray * couponArray;

@end

@implementation UnUsedCouponViewController

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
    [self.tabelView registerNib:[UINib nibWithNibName:@"SectionCouponCell" bundle:nil] forCellReuseIdentifier:@"SectionCouponCellid"];
    [self.tabelView registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:@"CouponCellid"];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = 44;
    }
    else{
        height = 100;
    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        SectionCouponCell * sectionCell = [ self.tabelView dequeueReusableCellWithIdentifier:@"SectionCouponCellid" forIndexPath:indexPath];
        return sectionCell;
    }
    
    CouponCell * couponCell = [ self.tabelView dequeueReusableCellWithIdentifier:@"CouponCellid" forIndexPath:indexPath];
    return couponCell;
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
