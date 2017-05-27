//
//  ZFPregressCheckViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFPregressCheckViewController.h"
#import "ZFPregressCheckCell.h"
#import "ZFPregressCheckCell2.h"
@interface ZFPregressCheckViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation ZFPregressCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请退货";
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFPregressCheckCell" bundle:nil] forCellReuseIdentifier:@"ZFPregressCheckCellid"];
 
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFPregressCheckCell2" bundle:nil] forCellReuseIdentifier:@"ZFPregressCheckCellid2"];
 
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStyleGrouped];
        _tableView.delegate =self ;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 4;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =  0;
    if (indexPath.section == 0) {
     
        height  = [tableView fd_heightForCellWithIdentifier:@"ZFPregressCheckCellid" configuration:^(id cell) {
            
        }];
        
    }
    height  = [tableView fd_heightForCellWithIdentifier:@"ZFPregressCheckCellid" configuration:^(id cell) {
        
    }];

    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.001;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        ZFPregressCheckCell * CheckCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFPregressCheckCellid" forIndexPath:indexPath];
        return CheckCell;

    }
    ZFPregressCheckCell2 * CheckCell2 = [self.tableView dequeueReusableCellWithIdentifier:@"ZFPregressCheckCellid2" forIndexPath:indexPath];
    return CheckCell2;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld == section ，%ld == row",indexPath.section,indexPath.row);
 
}

@end
