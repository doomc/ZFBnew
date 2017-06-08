//
//  ZFMyOpinionViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  我的意见

#import "ZFMyOpinionViewController.h"
#import "ZFMyOpinionCell.h"

@interface ZFMyOpinionViewController () <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView  * tableView;
@end

@implementation ZFMyOpinionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFMyOpinionCell" bundle:nil] forCellReuseIdentifier:@"ZFMyOpinionCellid"];
    
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -104) style:UITableViewStylePlain];
        _tableView.dataSource =self;
        _tableView.delegate= self;
    }
    return _tableView;
}
#pragma mark - datasoruce  代理实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
 
    height = [self.tableView fd_heightForCellWithIdentifier:@"ZFMyOpinionCellid" cacheByIndexPath:indexPath configuration:^(id cell) {
        
    }];
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFMyOpinionCell *cell = [self.tableView  dequeueReusableCellWithIdentifier:@"ZFMyOpinionCellid" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (indexPath.section == 0) {
        cell.lb_title.text = @"车市数据ntents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/PrivateFrameworks/AssetsLibraryServices.framework/AssetsLibraryServices (0x11689fcc0) and /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/PrivateFrameworks/PhotoLibraryServices.framework/PhotoLibraryServices (0x1166156f0). One of the two will be used. Which one is undefined.";
         cell.lb_status.text =@"已阅读";
    }
    if (indexPath.section == 1) {
        cell.lb_title.text = @"车市数据";
        cell.lb_status.text =@"已阅读";

    }
    if (indexPath.section == 2) {
        cell.lb_title.text = @"<UITableView: 0x7f854a97d000; frame = (0 0; 375 667); clipsToBounds = YES; gestureRecognizers = <NSArray: 0x608000253cb0>; layer = <CALayer: 0x6080004322c0>; contentOffset: {0, 0}; contentSize: {0, 0}>";
        cell.lb_status.text =@"已阅读";

    }
    return cell;
    
}
#pragma tableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
