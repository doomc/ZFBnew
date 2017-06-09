//
//  ZFEditAddressViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  添加收货地址

#import "ZFEditAddressViewController.h"

#import "ZFDefaultAddressCell.h"
#import "ZFAddressCell.h"


@interface ZFEditAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView  * mytableView;

@property(nonatomic,strong)NSArray  * titles;

@end

@implementation ZFEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"编辑收货地址";
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.mytableView.delegate= self;
    self.mytableView.dataSource = self;
    [self.view addSubview:self.mytableView];
    
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFAddressCell" bundle:nil] forCellReuseIdentifier:@"ZFAddressCellid"];
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZFDefaultAddressCell" bundle:nil] forCellReuseIdentifier:@"ZFDefaultAddressCellid"];
    

    _titles = @[@"收货人",@"手机号码",@"备用号码",@"省、市、区",@"详细地址"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        return 60;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        ZFDefaultAddressCell * defaultCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFDefaultAddressCellid" forIndexPath:indexPath];
        
        return defaultCell;
    }
    ZFAddressCell * addCell = [self.mytableView dequeueReusableCellWithIdentifier:@"ZFAddressCellid" forIndexPath:indexPath];

    addCell.lb_titles.text =  _titles[indexPath.row];
    
    return addCell;
}

@end
